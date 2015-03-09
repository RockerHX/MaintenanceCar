//
//  SCMyReservationTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyReservationTableViewController.h"
#import "SCReservation.h"
#import "SCReservationCell.h"
#import "SCWebViewController.h"
#import "SCMerchant.h"
#import "SCMerchantDetailViewController.h"

@interface SCMyReservationTableViewController ()

@end

@implementation SCMyReservationTableViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 我的预约"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 我的预约"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView removeFooter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCReservationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCReservationCell" forIndexPath:indexPath];
    
    // Configure the cell...
    SCReservation *reservation         = _dataList[indexPath.row];
    cell.merchantNameLabel.text        = reservation.name;
    cell.reservationTypeLabel.text     = reservation.type;
    cell.reservationDateLabel.text     = reservation.reserve_time;
    cell.maintenanceScheduleLabel.text = [self handleMaintenanceSchedule:reservation.status];
    cell.showMoreLabel.text            = [self handleShowMore:reservation.type] ? @"查看进度" : @"";
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果用户经行删除或者滑动删除操作，设置数据缓存，并进行相关删除操作请求，同步服务器数据
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _deleteDataCache = _dataList[indexPath.row];        // 设置数据缓存
        [_dataList removeObjectAtIndex:indexPath.row];      // 清楚数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];   // 列表中删除相关数据行
        [self startCancelReservationRequestWithIndex:indexPath.row];                             // 同步服务器
    }
}

#pragma mark - Table View Delegate Methods
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消预约";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SCReservation *reservation         = _dataList[indexPath.row];
    if ([self handleShowMore:reservation.type])
    {
        // 列表被点击跳转到商家详情
        @try {
            SCWebViewController *webViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCWebViewController"];
            webViewController.title = @"检测结果";
            webViewController.loadURL = [NSString stringWithFormat:@"%@/%@/%@", InspectionURL, [SCUserInfo share].userID, reservation.user_car_id];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCMyReservationTableViewController Go to the SCWebViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
    else
    {
        // 跳转到预约页面
        @try {
            SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
            merchantDetialViewControler.merchant = [[SCMerchant alloc] initWithMerchantName:reservation.name companyID:reservation.company_id];
            [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCMyFavoriteTableViewController Go to the SCMerchantDetailViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
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
    [self startReservationListRequest];
}

/**
 *  上拉刷新，加载更多数据
 */
- (void)startUpRefreshRequest
{
    [super startUpRefreshRequest];
    
    // 设置刷新类型
    self.requestType = SCFavoriteListRequestTypeUp;
    [self startReservationListRequest];
}

#pragma mark - Private Methods
- (NSString *)handleMaintenanceSchedule:(NSString *)status
{
    if ([status isEqualToString:@"0"])
        return @"提交预约";
    else if ([status isEqualToString:@"1"])
        return @"接受预约";
    else if ([status isEqualToString:@"2"])
        return @"拒绝预约";
    else if ([status isEqualToString:@"3"])
        return @"预约完成";
    else if ([status isEqualToString:@"4"])
        return @"取消预约";
    else
        return @"未知状态";
}

- (BOOL)handleShowMore:(NSString *)status
{
    if ([status isEqualToString:@"免费检测"])
        return YES;
    else
        return NO;
}

/**
 *  预约列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startReservationListRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"limit"  : @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startGetMyReservationAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            // 如果是下拉刷新数据，先清空列表，在做数据处理
            if (weakSelf.requestType == SCFavoriteListRequestTypeDown)
                [weakSelf clearListData];
            
            // 遍历请求回来的商家数据，生成SCMerchant用于商家列表显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCReservation *reservation = [[SCReservation alloc] initWithDictionary:obj error:nil];
                [_dataList addObject:reservation];
            }];
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:weakSelf.offset ? UITableViewRowAnimationTop : UITableViewRowAnimationFade];                                   // 数据配置完成，刷新商家列表
            weakSelf.offset += MerchantListLimit;                               // 偏移量请求参数递增
        }
        else
        {
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
            ShowPromptHUDWithText(weakSelf.navigationController.view, responseObject[@"error"], 0.5f);
        }
        [weakSelf hiddenHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf hiddenHUD];
        if (operation.response.statusCode == SCAPIRequestStatusCodeNotFound)
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"您还没有下过任何订单噢！", 0.5f);
        else
            ShowPromptHUDWithText(weakSelf.navigationController.view, NetWorkError, 0.5f);
    }];
}

/**
 *  取消预约请求方法，必选参数：company_id，user_id，reserve_id，status
 */
- (void)startCancelReservationRequestWithIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"user_id": [SCUserInfo share].userID,
                             @"company_id": ((SCReservation *)_deleteDataCache).company_id,
                             @"reserve_id": ((SCReservation *)_deleteDataCache).reserve_id,
                                 @"status": @"4"};
    [[SCAPIRequest manager] startUpdateReservationAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 根据返回结果进行相应提示
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            SCReservation *reservation = _dataList[index];
            reservation.status         = @"4";
            [weakSelf deleteFailureAtIndex:index];
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消预约成功", 0.5f);
        }
        else
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消预约失败，请重试", 0.5f);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf deleteFailureAtIndex:index];
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消失败，请检查网络", 0.5f);
    }];
}

@end
