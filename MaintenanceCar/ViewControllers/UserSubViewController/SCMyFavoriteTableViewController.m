//
//  SCMyFavoriteTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyFavoriteTableViewController.h"
#import "SCMerchant.h"
#import "SCMerchantTableViewCell.h"
#import "SCMerchantDetailViewController.h"
#import "SCReservatAlertView.h"
#import "SCReservationViewController.h"

@interface SCMyFavoriteTableViewController () <SCReservatAlertViewDelegate>
{
    NSInteger _index;
}

@end

@implementation SCMyFavoriteTableViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 我的收藏"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 我的收藏"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 绑定kMerchantListReservationNotification通知，此通知的用途见定义文档
    [NOTIFICATION_CENTER addObserver:self selector:@selector(reservationButtonPressed:) name:kMaintenanceReservationNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchant *merchant = _dataList[indexPath.row];
    SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier forIndexPath:indexPath];
    cell.reservationButton.tag    = indexPath.row;
    cell.reservationButton.hidden = !merchant.serviceItems.count;
    
    // 刷新商家列表，设置相关数据
    [cell handelWithMerchant:merchant];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;     // 允许列表编辑
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果用户经行删除或者滑动删除操作，设置数据缓存，并进行相关删除操作请求，同步服务器数据
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _deleteDataCache = _dataList[indexPath.row];        // 设置数据缓存
        [_dataList removeObjectAtIndex:indexPath.row];      // 清楚数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];   // 列表中删除相关数据行
        [self startCancelCollectionMerchantRequestWithIndex:indexPath.row];                             // 同步服务器
    }
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 跳转到预约页面
    @try {
        SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
        merchantDetialViewControler.merchant = (SCMerchant *)_dataList[indexPath.row];
        [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMyFavoriteTableViewController Go to the SCMerchantDetailViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Public Methods
/**
 *  下拉刷新，请求最新数据
 */
- (void)startDownRefreshReuqest
{
    [super startDownRefreshReuqest];
    
    // 刷新前把数据偏移量offset设置为0，设置刷新类型，以便请求最新数据
    self.offset = Zero;
    self.requestType = SCFavoriteListRequestTypeDown;
    [self startMerchantCollectionListRequest];
}

/**
 *  上拉刷新，加载更多数据
 */
- (void)startUpRefreshRequest
{
    [super startUpRefreshRequest];
    
    // 设置刷新类型
    self.requestType = SCFavoriteListRequestTypeUp;
    [self startMerchantCollectionListRequest];
}

#pragma mark - Private Methods
/**
 *  收藏列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startMerchantCollectionListRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"limit"  : @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startGetCollectionMerchantAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            // 如果是下拉刷新数据，先清空列表，在做数据处理
            if (weakSelf.requestType == SCFavoriteListRequestTypeDown)
            {
                [weakSelf clearListData];
            }
            
            // 遍历请求回来的商家数据，生成SCMerchant用于商家列表显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error       = nil;
                SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj error:&error];
                [_dataList addObject:merchant];
            }];
            
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];             // 请求完成，移除响应式控件
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:weakSelf.offset ? UITableViewRowAnimationTop : UITableViewRowAnimationFade];                                                           // 数据配置完成，刷新商家列表
            weakSelf.offset += MerchantListLimit;                                                       // 偏移量请求参数递增
        }
        else
        {
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
            ShowPromptHUDWithText(weakSelf.navigationController.view, responseObject[@"error"], 1.0f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        if (operation.response)
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"您还没有收藏过任何店铺噢！", 1.0f);
        else
            ShowPromptHUDWithText(weakSelf.navigationController.view, NetWorkError, 1.0f);
    }];
}

/**
 *  取消收藏商家请求方法，必选参数：company_id，user_id
 */
- (void)startCancelCollectionMerchantRequestWithIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"company_id": ((SCMerchant *)_deleteDataCache).company_id,
                                   @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startCancelCollectionAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 根据返回结果进行相应提示
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"删除成功", 1.0f);
        }
        else
        {
            [weakSelf deleteFailureAtIndex:index];
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"删除失败，请重试", 1.0f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf deleteFailureAtIndex:index];
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"删除失败，请检查网络", 1.0f);
    }];
}

/**
 *  商家列表预约按钮点击触发事件通知方法
 *
 *  @param notification 接受传递的参数
 */
- (void)reservationButtonPressed:(NSNotification *)notification
{
    _index = [notification.object integerValue];
    SCReservatAlertView *reservatAlertView = [[SCReservatAlertView alloc] initWithDelegate:self animation:SCAlertAnimationEnlarge];
    [reservatAlertView show];
}

#pragma mark - SCReservatAlertViewDelegate Methods
- (void)selectedWithServiceItem:(SCServiceItem *)serviceItem
{
    // 跳转到预约页面
    @try {
        SCMerchant *merchant = _dataList[_index];
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant = [[SCMerchant alloc] initWithMerchantName:merchant.name
                                                                            companyID:merchant.company_id];
        reservationViewController.serviceItem = serviceItem;
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
