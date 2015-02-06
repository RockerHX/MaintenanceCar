//
//  SCMerchantViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "MJRefresh.h"
#import "SCAPIRequest.h"
#import "SCMerchant.h"
#import "SCMerchantListCell.h"
#import "SCLocationManager.h"
#import "SCMerchantDetailViewController.h"
#import "SCMapViewController.h"
#import "SCMerchantFilterView.h"
#import "SCStarView.h"
#import "SCAllDictionary.h"

@interface SCMerchantViewController () <UITableViewDelegate, UITableViewDataSource, SCMerchantFilterViewDelegate>
{
    NSMutableArray *_merchantList;
    
    NSString       *_query;
    NSString       *_distanceCondition;
}

@property (nonatomic, assign) NSInteger      offset;        // 商户列表请求偏移量，用户上拉刷新的分页请求操作

@end

@implementation SCMerchantViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商户] - 列表"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商户] - 列表"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
    
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新控件
    [_tableView addFooterWithCallback:^{
        [weakSelf upRefreshMerchantList];
    }];
    
    [self refreshMerchantList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _merchantList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantListCell" forIndexPath:indexPath];
    // 刷新商户列表，设置相关数据
    [cell handelWithMerchant:_merchantList[indexPath.row]];
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 列表栏被点击，执行取消选中动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 根据选中的商户，取到其商户ID，跳转到商户页面进行详情展示
    SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMerchantDetailViewController"];
    merchantDetialViewControler.merchant = _merchantList[indexPath.row];
    [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
}

#pragma mark - Action Methods
- (IBAction)mapItemPressed:(UIBarButtonItem *)sender
{
    // 地图按钮被点击，跳转到地图页面
    UINavigationController *mapNavigationController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMapViewNavigationController"];
    SCMapViewController *mapViewController = (SCMapViewController *)mapNavigationController.topViewController;
    mapViewController.merchants = _merchantList;
    mapNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mapNavigationController animated:YES completion:nil];
}

#pragma mark - Private Methods
/**
 *  初始化配置，列表设置，全局变量初始化都放在这里
 */
- (void)initConfig
{
    _query             = DefaultQuery;
    _offset            = 0;                     // 第一次进入商户列表列表请求偏移量必须为0
    _distanceCondition = MerchantListRadius;

    _merchantList      = [@[] mutableCopy];     // 商户列表容器初始化
}

- (void)viewConfig
{
    _merchantFilterView.delegate = self;
    _tableView.scrollsToTop      = YES;
    _tableView.tableFooterView   = [[UIView alloc] init];       // 设置footer视图，防止数据不够，显示多余的列表栏
}

- (void)refreshMerchantList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];      // 加载响应式控件
    
    __weak typeof(self) weakSelf = self;
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        [weakSelf startMerchantListRequestWithLatitude:latitude longitude:longitude];
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"定位失败，采用当前城市中心坐标", 0.5f);
        [weakSelf startMerchantListRequestWithLatitude:latitude longitude:longitude];
    }];
}

- (void)upRefreshMerchantList
{
    SCLocationManager *locationManager = [SCLocationManager share];
    [self startMerchantListRequestWithLatitude:locationManager.latitude longitude:locationManager.longitude];
}

/**
 *  商户列表数据请求方法，参数：query, limit, offset, radius, longtitude, latitude
 */
- (void)startMerchantListRequestWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"query"     : _query,
                                 @"limit"     : @(MerchantListLimit),
                                 @"offset"    : @(_offset),
                                 @"radius"    : _distanceCondition,
                                 @"latitude"  : latitude,
                                 @"longtitude": longitude};
    [[SCAPIRequest manager] startMerchantListAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *list = [[responseObject objectForKey:@"result"] objectForKey:@"items"];
            
            if (list.count)
            {
                // 遍历请求回来的商户数据，生成SCMerchant用于商户列表显示
                [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj[@"fields"] error:nil];
                    [_merchantList addObject:merchant];
                }];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:_offset ? UITableViewRowAnimationTop : UITableViewRowAnimationFade];                                   // 数据配置完成，刷新商户列表
                _offset += MerchantListLimit;                                       // 偏移量请求参数递增
            }
            else
            {
                ShowPromptHUDWithText(weakSelf.navigationController.view, _offset ? @"只有这么多了亲！" : @"没有更多了亲", 0.5f);
                [_tableView reloadData];
            }
        }
        else
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];              // 请求完成，移除响应式控件
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - SCMerchantFilterViewDelegate Methods
- (void)didSelectedFilterCondition:(id)item type:(SCFilterType)type
{
    NSString *filterName      = item[DisplayNameKey];
    NSString *filterCondition = item[RequestValueKey];
    
    _offset            = 0;
    [_merchantList removeAllObjects];
    
    SCAllDictionary *allDictionary = [SCAllDictionary share];
    // 筛选条件，选择之后触发请求
    switch (type) {
        case SCFilterTypeRepair:
        {
            if ([filterCondition isEqualToString:@"default"])
                allDictionary.repairCondition = @"";
            else
                allDictionary.repairCondition = [NSString stringWithFormat:@" AND majors:'%@' AND flags:'综'", filterCondition];
        }
            break;
        case SCFilterTypeOther:
        {
            if (![filterCondition isEqualToString:@"default"])
            {
                if ([filterCondition isEqualToString:@"tag"])
                    allDictionary.otherCondition = [NSString stringWithFormat:@" AND tags:'%@'", filterName];
                else
                    allDictionary.otherCondition = [NSString stringWithFormat:@" AND service:'%@'", filterCondition];
            }
            else
                allDictionary.otherCondition = @"";
        }
            break;
            
        default:
            _distanceCondition = filterCondition;
            break;
    }
    _query = [NSString stringWithFormat:@"%@%@%@", DefaultQuery, allDictionary.repairCondition, allDictionary.otherCondition];
    [self refreshMerchantList];
}

@end
