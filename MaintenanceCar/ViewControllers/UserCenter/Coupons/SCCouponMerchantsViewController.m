//
//  SCCouponMerchantsViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponMerchantsViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "SCLocationManager.h"
#import "SCMerchantListCell.h"
#import "SCMerchantDetailViewController.h"

@implementation SCCouponMerchantsViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[优惠券] - 商家列表"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[优惠券] - 商家列表"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
    [self loadCouponMerchantsAndLocation];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return USERCENTER_VIEW_CONTROLLER(@"SCCouponMerchantsViewController");
}

#pragma mark - Config Methods
/**
 *  初始化配置，列表设置，全局变量初始化都放在这里
 */
- (void)initConfig
{
    _merchants         = [@[] mutableCopy];             // 商家列表容器初始化
    _offset            = 0;                             // 第一次进入商家列表列表请求偏移量必须为0
    _distanceCondition = @(SearchRadius).stringValue;
}

- (void)viewConfig
{
    self.tableView.tableFooterView = [[UIView alloc] init];     // 设置footer视图，防止数据不够，显示多余的列表栏
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
    SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMerchantDetailViewController"];
    merchantDetialViewControler.merchant           = _merchants[indexPath.row];
    merchantDetialViewControler.canSelectedReserve = YES;
    [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
}

#pragma mark - Prive Mthods
- (void)readdFooter
{
    if (!self.tableView.footer)
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(pullUpRefreshRequest)];
}

- (void)removeFooter
{
    [self.tableView removeFooter];
}

- (void)loadCouponMerchantsAndLocation
{
    [self showHUDOnViewController:self];
    __weak typeof(self) weakSelf = self;
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        [weakSelf startCouponMerchantsRequestWithLatitude:latitude longitude:longitude];
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"定位失败，采用当前城市中心坐标!"];
        [weakSelf showAlertWithMessage:@"定位失败，请检查您的定位服务是否打开：设置->隐私->定位服务"];
        [weakSelf startCouponMerchantsRequestWithLatitude:latitude longitude:longitude];
    }];
}

- (void)pullUpRefreshRequest
{
    SCLocationManager *locationManager = [SCLocationManager share];
    [self startCouponMerchantsRequestWithLatitude:locationManager.latitude longitude:locationManager.longitude];
}

/**
 *  商家列表数据请求方法，参数：query, limit, offset, radius, longtitude, latitude
 */
- (void)startCouponMerchantsRequestWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"coupon_code": _couponCode,
                                       @"limit": @(SearchLimit),
                                      @"offset": @(_offset),
                                      @"radius": _distanceCondition,
                                    @"latitude": latitude,
                                  @"longtitude": longitude};
    [[SCAPIRequest manager] startCouponMerchantsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *list = [[responseObject objectForKey:@"result"] objectForKey:@"items"];
            if (list.count)
            {
                // 遍历请求回来的商家数据，生成SCMerchant用于商家列表显示
                [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj[@"fields"] error:nil];
                    [_merchants addObject:merchant];
                }];
                [weakSelf.tableView reloadData];    // 数据配置完成，刷新商家列表
                [weakSelf readdFooter];
                _offset += SearchLimit;             // 偏移量请求参数递增
            }
            else
            {
                [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"优质商家陆续添加中..." delay:0.5f];
                [weakSelf removeFooter];
            }
        }
        else
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
        [weakSelf.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.tableView.footer endRefreshing];
        [weakSelf hideHUDOnViewController:weakSelf];
    }];
}

@end
