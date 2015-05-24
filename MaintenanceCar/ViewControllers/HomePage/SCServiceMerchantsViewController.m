//
//  SCServiceMerchantsViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCServiceMerchantsViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "SCMerchant.h"
#import "SCMerchantListCell.h"
#import "SCLocationManager.h"
#import "SCMerchantDetailViewController.h"
#import "SCMapViewController.h"
#import "SCSearchFilterView.h"
#import "SCStarView.h"

@interface SCServiceMerchantsViewController () <UITableViewDelegate, UITableViewDataSource, SCSearchFilterViewDelegate>
{
    NSInteger       _offset;            // 商家列表请求偏移量，用户上拉刷新的分页请求操作
    NSMutableArray *_merchants;         // 商家数据集合
    
    NSString       *_distance;
    NSString       *_majors;
}

@end

@implementation SCServiceMerchantsViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"[%@] - 列表", self.title]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _searchFilterView.noBrand = _noBrand;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"[%@] - 列表", self.title]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
    
    // 添加上拉刷新控件
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(upRefreshMerchantList)];
    [self.tableView.footer setHidden:YES];
    [self refreshMerchantList];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return MAIN_VIEW_CONTROLLER(@"SCServiceMerchantsViewController");
}

#pragma mark - Config Methods
/**
 *  初始化配置，列表设置，全局变量初始化都放在这里
 */
- (void)initConfig
{
    // 搜索列表请求参数初始化配置
    _offset    = Zero;                          // 第一次进入商家列表列表请求偏移量必须为0
    _distance  = @(SearchRadius).stringValue;
    _majors    = @"";

    _merchants = [@[] mutableCopy];             // 商家列表容器初始化
}

- (void)viewConfig
{
    _tableView.scrollsToTop      = YES;
    _tableView.tableFooterView   = [[UIView alloc] init];       // 设置footer视图，防止数据不够，显示多余的列表栏
    
    [_searchFilterView.serviceButton setTitle:self.title forState:UIControlStateNormal];
    [_searchFilterView.serviceButton setTitle:self.title forState:UIControlStateDisabled];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _merchants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantListCell" forIndexPath:indexPath];
    // 刷新商家列表，设置相关数据
    [cell handelWithMerchant:_merchants[indexPath.row]];
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 列表栏被点击，执行取消选中动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 根据选中的商家，取到其商家ID，跳转到商家页面进行详情展示
    SCMerchantDetailViewController *merchantDetialViewControler = MAIN_VIEW_CONTROLLER(@"SCMerchantDetailViewController");
    merchantDetialViewControler.merchant = _merchants[indexPath.row];
    merchantDetialViewControler.type     = _type;
    [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
}

#pragma mark - Action Methods
- (IBAction)mapItemPressed:(UIBarButtonItem *)sender
{
    if (_merchants.count)
    {
        // 地图按钮被点击，跳转到地图页面
        UINavigationController *mapNavigationController = MAIN_VIEW_CONTROLLER(@"SCMapViewNavigationController");
        SCMapViewController *mapViewController       = (SCMapViewController *)mapNavigationController.topViewController;
        mapViewController.merchants                  = _merchants;
        mapNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mapNavigationController animated:YES completion:nil];
    }
}

#pragma mark - Private Methods
- (void)refreshMerchantList
{
    [self showHUDOnViewController:self];
    
    __weak typeof(self) weakSelf = self;
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        [weakSelf startMerchantsRequestWithLatitude:latitude longitude:longitude];
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        [weakSelf hideHUDOnViewController:weakSelf];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"定位失败，采用当前城市中心坐标!"];
        [weakSelf showAlertWithTitle:@"温馨提示" message:@"定位失败，请检查您的定位服务是否打开：设置->隐私->定位服务"];
        [weakSelf startMerchantsRequestWithLatitude:latitude longitude:longitude];
    }];
}

- (void)startMerchantsRequestWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    NSString *apiURL = nil;
    switch (_searchType)
    {
        case SCSearchTypeWash:
            apiURL = SearchWashAPIURL;
            break;
        case SCSearchTypeMaintenance:
            apiURL = SearchMaintanceAPIURL;
            break;
        case SCSearchTypeRepair:
            apiURL = SearchRepairAPIURL;
            break;
        case SCSearchTypeOperate:
            apiURL = SearchOperateAPIURL;
            break;
            
        default:
            break;
    }
    [self startMerchantsRequestWithAPIURL:apiURL latitude:latitude longitude:longitude];
}

- (void)upRefreshMerchantList
{
    SCLocationManager *manager = [SCLocationManager share];
    [self startMerchantsRequestWithLatitude:manager.latitude longitude:manager.longitude];
}

- (void)startMerchantsRequestWithAPIURL:(NSString *)apiURL latitude:(NSString *)latitude longitude:(NSString *)longitude
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"limit": @(SearchLimit),
                                @"offset": @(_offset),
                            @"longtitude": longitude,
                              @"latitude": latitude,
                           @"product_tag": self.title,
                                @"radius": _distance,
                                @"majors": _majors};
    [[SCAPIRequest manager] requestGETMethodsWithAPI:apiURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *list = responseObject[@"result"][@"items"];
            if (list.count)
            {
                // 遍历请求回来的商家数据，生成SCMerchant用于商家列表显示
                [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj[@"fields"] error:nil];
                    [_merchants addObject:merchant];
                }];
                [_tableView reloadData];                             // 数据配置完成，刷新商家列表
                _offset += SearchLimit;                              // 偏移量请求参数递增
            }
            else
            {
                [self showHUDAlertToViewController:self.navigationController text:@"优质商家陆续添加中..." delay:0.5f];
                [_tableView reloadData];
            }
            _searchFilterView.hidden = NO;
            [self.tableView.footer setHidden:NO];
        }
        else
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
        [weakSelf refreshFinfish];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
        [weakSelf refreshFinfish];
    }];
}

- (void)refreshFinfish
{
    [self.tableView.footer endRefreshing];
    [self hideHUDOnViewController:self];
}

#pragma mark - SCMerchantFilterViewDelegate Methods
- (void)didSelectedFilterCondition:(id)item type:(SCFilterType)type
{
    NSString *filter = item[RequestValueKey];

    _offset = Zero;
    [_merchants removeAllObjects];
    
    // 筛选条件，选择之后触发请求
    switch (type) {
        case SCFilterTypeMajor:
            _majors = [filter isEqualToString:@"default"] ? @"" : filter;
            break;
        default:
            _distance = [filter isEqualToString:@"default"] ? @(SearchRadius).stringValue : filter;
            break;
    }
    [self refreshMerchantList];
}

@end