//
//  SCServiceMerchantListViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCServiceMerchantListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "SCMerchant.h"
#import "SCMerchantListCell.h"
#import "SCLocationManager.h"
#import "SCMerchantDetailViewController.h"
#import "SCMapViewController.h"
#import "SCMerchantFilterView.h"
#import "SCStarView.h"

@interface SCServiceMerchantListViewController () <UITableViewDelegate, UITableViewDataSource, SCMerchantFilterViewDelegate>
{
    NSMutableArray *_merchantList;
    
    NSString       *_requestQuery;
    NSString       *_distanceCondition;
    NSString       *_majorsCondition;
}

@property (nonatomic, assign) NSInteger      offset;        // 商家列表请求偏移量，用户上拉刷新的分页请求操作

@end

@implementation SCServiceMerchantListViewController

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
    
    _merchantFilterView.noBrand = _noBrand;
    if (_isOperate)
        _merchantFilterView.otherFilterButton.enabled = NO;
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

#pragma mark - Config Methods
/**
 *  初始化配置，列表设置，全局变量初始化都放在这里
 */
- (void)initConfig
{
    _offset                      = 0;                   // 第一次进入商家列表列表请求偏移量必须为0
    _distanceCondition           = @(MerchantListRadius).stringValue;
    _majorsCondition             = @"";
    
    _merchantList                = [@[] mutableCopy];   // 商家列表容器初始化
    _merchantFilterView.delegate = self;
}

- (void)viewConfig
{
    _tableView.scrollsToTop      = YES;
    _tableView.tableFooterView   = [[UIView alloc] init];       // 设置footer视图，防止数据不够，显示多余的列表栏
    
    [_merchantFilterView.otherFilterButton setTitle:self.title forState:UIControlStateNormal];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _merchantList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantListCell" forIndexPath:indexPath];
    // 刷新商家列表，设置相关数据
    [cell handelWithMerchant:_merchantList[indexPath.row]];
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 列表栏被点击，执行取消选中动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 根据选中的商家，取到其商家ID，跳转到商家页面进行详情展示
    SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMerchantDetailViewController"];
    merchantDetialViewControler.merchant = _merchantList[indexPath.row];
    [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
}

#pragma mark - Action Methods
- (IBAction)mapItemPressed:(UIBarButtonItem *)sender
{
    if (_merchantList.count)
    {
        // 地图按钮被点击，跳转到地图页面
        UINavigationController *mapNavigationController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMapViewNavigationController"];
        SCMapViewController *mapViewController = (SCMapViewController *)mapNavigationController.topViewController;
        mapViewController.merchants = _merchantList;
        mapNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mapNavigationController animated:YES completion:nil];
    }
}

- (void)setQuery:(NSString *)query
{
    _query = query;
    _requestQuery = query;
}

#pragma mark - Private Methods
- (void)refreshMerchantList
{
    [self showHUDOnViewController:self];
    
    __weak typeof(self) weakSelf = self;
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        if (_isOperate)
            [weakSelf startOperateMerchantListRequestWithLatitude:latitude longitude:longitude];
        else
            [weakSelf startMerchantListRequestWithLatitude:latitude longitude:longitude];
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        [weakSelf hideHUDOnViewController:weakSelf];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"定位失败，采用当前城市中心坐标!" delay:0.5f];
        [weakSelf startMerchantListRequestWithLatitude:latitude longitude:longitude];
        [weakSelf showAlertWithTitle:@"温馨提示" message:@"定位失败，请检查您的定位服务是否打开：设置->隐私->定位服务"];
    }];
}

- (void)upRefreshMerchantList
{
    SCLocationManager *locationManager = [SCLocationManager share];
    if (_isOperate)
        [self startOperateMerchantListRequestWithLatitude:locationManager.latitude longitude:locationManager.longitude];
    else
        [self startMerchantListRequestWithLatitude:locationManager.latitude longitude:locationManager.longitude];
}

/**
 *  商家列表数据请求方法，参数：query, limit, offset, radius, longtitude, latitude
 */
- (void)startMerchantListRequestWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"query": _requestQuery,
                                 @"limit": @(MerchantListLimit),
                                @"offset": @(_offset),
                                @"radius": _distanceCondition,
                                  @"flag": @"1",
                            @"longtitude": longitude,
                              @"latitude": latitude};
    [[SCAPIRequest manager] startMerchantListAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            [weakSelf refreshMerchantListWithListData:responseObject];
        else
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
        [weakSelf refreshFinfish];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        [weakSelf refreshFinfish];
    }];
}

- (void)startOperateMerchantListRequestWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"product_tag": _requestQuery,
                                       @"limit": @(MerchantListLimit),
                                      @"offset": @(_offset),
                                      @"radius": _distanceCondition,
                                      @"majors": _majorsCondition,
                                  @"longtitude": longitude,
                                    @"latitude": latitude};
    [[SCAPIRequest manager] startOperateMerchantListAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            [weakSelf refreshMerchantListWithListData:responseObject];
        else
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
        [weakSelf refreshFinfish];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        [weakSelf refreshFinfish];
    }];
}

- (void)refreshMerchantListWithListData:(id)listData
{
    NSArray *list = [[listData objectForKey:@"result"] objectForKey:@"items"];
    
    if (list.count)
    {
        // 遍历请求回来的商家数据，生成SCMerchant用于商家列表显示
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj[@"fields"] error:nil];
            [_merchantList addObject:merchant];
        }];
        [_tableView reloadData];                                   // 数据配置完成，刷新商家列表
        _offset += MerchantListLimit;                              // 偏移量请求参数递增
    }
    else
    {
        [self showHUDAlertToViewController:self.navigationController text:@"优质商家陆续添加中..." delay:0.5f];
        [_tableView reloadData];
    }
    _merchantFilterView.hidden = NO;
    [self.tableView.footer setHidden:NO];
}

- (void)refreshFinfish
{
    [self.tableView.footer endRefreshing];
    [self hideHUDOnViewController:self];
}

#pragma mark - SCMerchantFilterViewDelegate Methods
- (void)didSelectedFilterCondition:(id)item type:(SCFilterType)type
{
    NSString *filterName      = item[DisplayNameKey];
    NSString *filterCondition = item[RequestValueKey];

    _offset                   = 0;
    [_merchantList removeAllObjects];
    
    NSString *repairCondition = @"";
    NSString *otherCondition  = @"";
    // 筛选条件，选择之后触发请求
    switch (type) {
        case SCFilterTypeRepair:
        {
            if (!_isOperate)
            {
                if ([filterCondition isEqualToString:@"default"])
                    repairCondition = @"";
                else
                    repairCondition = [NSString stringWithFormat:@" AND majors:'%@'", filterCondition];
            }
            else
                _majorsCondition = filterCondition;
        }
            break;
        case SCFilterTypeOther:
        {
            if (![filterCondition isEqualToString:@"default"])
            {
                if ([filterCondition isEqualToString:@"tag"])
                    otherCondition = [NSString stringWithFormat:@" AND tags:'%@'", filterName];
                else
                    otherCondition = [NSString stringWithFormat:@" AND service:'%@'", filterCondition];
            }
            else
                otherCondition = @"";
        }
            break;
            
        default:
            _distanceCondition = [filterCondition isEqualToString:@"default"] ? @(MerchantListRadius).stringValue : filterCondition;
            break;
    }
    _requestQuery = [NSString stringWithFormat:@"%@%@%@", _query, repairCondition, otherCondition];
    [self refreshMerchantList];
}

@end