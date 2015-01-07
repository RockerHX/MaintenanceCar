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

@interface SCMerchantViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSInteger _reservationButtonIndex;
    NSMutableArray *_merchantList;
}

@property (nonatomic, assign) NSInteger      offset;        // 商户列表请求偏移量，用户上拉刷新的分页请求操作

@end

@implementation SCMerchantViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商户] - 商户列表"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商户] - 商户列表"];
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
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _merchantList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier forIndexPath:indexPath];
    
    // 刷新商户列表
    SCMerchant *merchant = _merchantList[indexPath.row];
    cell.merchantNameLabel.text = merchant.name;
    cell.distanceLabel.text = merchant.distance;
    cell.reservationButton.tag = indexPath.row;
    
    return cell;
}

#pragma mark - Table View Delegate Methods
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
    merchantDetialViewControler.companyID = ((SCMerchant *)_merchantList[indexPath.row]).company_id;
    [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
}

#pragma mark - Action Methods
#pragma mark -
- (IBAction)mapItemPressed:(UIBarButtonItem *)sender
{
    UINavigationController *mapNavigationController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMapViewNavigationController"];
    SCMapViewController *mapViewController = (SCMapViewController *)mapNavigationController.topViewController;
    mapViewController.merchants = _merchantList;
    mapNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mapNavigationController animated:YES completion:nil];
}

#pragma mark - KVO Methods
#pragma makr -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
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
#pragma mark -
/**
 *  初始化配置，列表设置，全局变量初始化都放在这里
 */
- (void)initConfig
{
    _offset               = 0;              // 第一次进入商户列表列表请求偏移量必须为0

    // 设置tableview的代理和数据源
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _merchantList = [@[] mutableCopy];      // 商户列表容器初始化
    
    // 绑定kMerchantListReservationNotification通知，此通知的用途见定义文档
    [NOTIFICATION_CENTER addObserver:self selector:@selector(reservationButtonPressed:) name:kMerchantListReservationNotification object:nil];
    
    // 监听SCLocationInfo单例的userLocation属性，观察定位是否成功
    [[SCLocationInfo shareLocationInfo] addObserver:self forKeyPath:@"userLocation" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  商户列表预约按钮点击触发事件通知方法
 *
 *  @param notification 接受传递的参数
 */
- (void)reservationButtonPressed:(NSNotification *)notification
{
    _reservationButtonIndex = [notification.object integerValue];       // 设置index，用于在_merchantList里取出SCMerchant对象设置到SCReservationViewController
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"预约"
                                                        message:@"请选择您预约的项目"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"1元洗车", @"2元贴膜", @"3元打蜡", @"其他项目", nil];
    [alertView show];
}

/**
 *  商户列表数据请求方法
 */
- (void)startMerchantListRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    SCLocationInfo *locationInfo = [SCLocationInfo shareLocationInfo];
    NSDictionary *parameters     = @{@"word"      : locationInfo.city,
                                     @"limit"     : @(MerchantListLimit),
                                     @"offset"    : @(_offset),
                                     @"radius"    : @(MerchantListRadius),
                                     @"longtitude": locationInfo.longitude,
                                     @"latitude"  : locationInfo.latitude};
    
    [[SCAPIRequest manager] startMerchantListAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            SCLog(@"merchent list request data:%@", responseObject);
            NSArray *list = [[responseObject objectForKey:@"result"] objectForKey:@"items"];
            
            // 遍历请求回来的商户数据，生成SCMerchant用于商户列表显示
            [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error       = nil;
                SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj[@"fields"] error:&error];
                SCFailure(@"weather model parse error:%@", error);
                [_merchantList addObject:merchant];
            }];
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];              // 请求完成，移除响应式控件
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:_offset ? UITableViewRowAnimationTop : UITableViewRowAnimationFade];                                   // 数据配置完成，刷新商户列表
            _offset += MerchantListLimit;                                       // 偏移量请求参数递增
        }
        else
        {
            SCFailure(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCFailure(@"Get merchant list request error:%@", error);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - Alert View Delegate Methods
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        // 跳转到预约页面
        @try {
            SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
            reservationViewController.merchant = _merchantList[_reservationButtonIndex];
            [self.navigationController pushViewController:reservationViewController animated:YES];
        }
        @catch (NSException *exception) {
            SCException(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
}

@end
