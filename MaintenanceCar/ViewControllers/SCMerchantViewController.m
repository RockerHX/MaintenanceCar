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
#import "SCMerchantTableViewCell.h"
#import "SCLocationInfo.h"
#import "SCReservationViewController.h"
#import "SCMerchantDetailViewController.h"
#import "SCMapViewController.h"
#import "SCMerchantFilterView.h"
#import "SCReservatAlertView.h"

@interface SCMerchantViewController () <UITableViewDelegate, UITableViewDataSource, SCReservatAlertViewDelegate, SCMerchantFilterViewDelegate>
{
    NSInteger _reservationButtonIndex;
    NSMutableArray *_merchantList;
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];      // 加载响应式控件
    
    [self initConfig];
    
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新控件
    [_tableView addFooterWithCallback:^{
        [weakSelf startMerchantListRequest];
    }];
    
    // 根据定位数据经行列表请求操作
    if ([SCLocationInfo shareLocationInfo].userLocation)
    {
        [self startMerchantListRequest];
    }
    else if ([SCLocationInfo shareLocationInfo].locationFailure)
    {
        [self startMerchantListRequest];
    }
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
    SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier forIndexPath:indexPath];
    cell.reservationButton.hidden = YES;
    
    // 刷新商户列表
    SCMerchant *merchant = _merchantList[indexPath.row];
    cell.merchantNameLabel.text = merchant.name;
    cell.distanceLabel.text = merchant.distance;
    cell.reservationButton.tag = indexPath.row;
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 列表栏被点击，执行取消选中动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 根据选中的商户，取到其商户ID，跳转到商户页面进行详情展示
    SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
    merchantDetialViewControler.companyID = ((SCMerchant *)_merchantList[indexPath.row]).company_id;
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

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 监听SCLocationInfo的userLocation，来确定商户列表刷新逻辑
    if ([keyPath isEqualToString:@"userLocation"])
    {
        if ([SCLocationInfo shareLocationInfo].userLocation && change[NSKeyValueChangeNewKey])
        {
            [self startMerchantListRequest];
        }
        else if ([SCLocationInfo shareLocationInfo].locationFailure)
        {
            [self startMerchantListRequest];
        }
    }
}

#pragma mark - Private Methods
/**
 *  初始化配置，列表设置，全局变量初始化都放在这里
 */
- (void)initConfig
{
    _offset                      = 0;// 第一次进入商户列表列表请求偏移量必须为0

    _merchantFilterView.delegate = self;
    // 设置tableview的代理和数据源
    _tableView.delegate          = self;
    _tableView.dataSource        = self;
    _tableView.tableFooterView   = [[UIView alloc] init];       // 设置footer视图，防止数据不够，显示多余的列表栏

    _merchantList                = [@[] mutableCopy];           // 商户列表容器初始化
    
    // 监听SCLocationInfo单例的userLocation属性，观察定位是否成功
    [[SCLocationInfo shareLocationInfo] addObserver:self forKeyPath:@"userLocation" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  商户列表数据请求方法，参数：query, limit, offset, radius, longtitude, latitude
 */
- (void)startMerchantListRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    SCLocationInfo *locationInfo = [SCLocationInfo shareLocationInfo];
    NSDictionary *parameters     = @{@"query"     : @"default:'深圳'",
                                     @"limit"     : @(MerchantListLimit),
                                     @"offset"    : @(_offset),
                                     @"radius"    : @(MerchantListRadius),
                                     @"longtitude": locationInfo.longitude,
                                     @"latitude"  : locationInfo.latitude};
    
    [[SCAPIRequest manager] startMerchantListAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *list = [[responseObject objectForKey:@"result"] objectForKey:@"items"];
            
            // 遍历请求回来的商户数据，生成SCMerchant用于商户列表显示
            [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error       = nil;
                SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj[@"fields"] error:&error];
                [_merchantList addObject:merchant];
            }];
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:_offset ? UITableViewRowAnimationTop : UITableViewRowAnimationFade];                                   // 数据配置完成，刷新商户列表
            _offset += MerchantListLimit;                                       // 偏移量请求参数递增
        }
        else
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];              // 请求完成，移除响应式控件
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - SCReservatAlertViewDelegate Methods
- (void)selectedWithServiceItem:(SCDictionaryItem *)serviceItem
{
    // 跳转到预约页面
    @try {
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant = _merchantList[_reservationButtonIndex];
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }

}

#pragma mark - SCMerchantFilterViewDelegate Methods
- (void)filterButtonPressedWithType:(SCFilterButtonType)type
{
    // 筛选条件，选择之后触发请求
    switch (type) {
        case SCFilterButtonTypeDistanceButton:
        {
        }
            break;
        case SCFilterButtonTypeRepairTypeButton:
        {
        }
            break;
        case SCFilterButtonTypeOtherFilterButton:
        {
        }
            break;
            
        default:
            break;
    }
}

@end
