//
//  SCMyReservationTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyReservationTableViewController.h"
#import "MicroCommon.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"
#import "SCReservation.h"
#import "SCReservationTableViewCell.h"

@interface SCMyReservationTableViewController ()

@end

@implementation SCMyReservationTableViewController

#pragma mark - View Controller Life Cycle
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
    SCReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReservationCellReuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    SCReservation *reservation = _dataList[indexPath.row];
    cell.merchantNameLabel.text = reservation.create_time;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _deleteDataCache = _dataList[indexPath.row];
        [_dataList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self startCancelReservationRequestWithIndex:indexPath.row];
    }
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        UINavigationController *addCarViewNavigationControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCAddCarViewNavigationController"];
        [self presentViewController:addCarViewNavigationControler animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        SCException(@"SCMyReservationTableViewController Go to the SCAddCarViewNavigationControler exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Private Methods
- (void)startDownRefreshReuqest
{
    [super startDownRefreshReuqest];
    
    self.offset = Zero;
    self.requestType = SCFavoriteListRequestTypeDown;
    [self startReservationListRequest];
}

- (void)startUpRefreshRequest
{
    [super startUpRefreshRequest];
    
    self.requestType = SCFavoriteListRequestTypeUp;
    [self startReservationListRequest];
}

#pragma mark - Private Methods
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
    [[SCAPIRequest manager] startGetMyReservationAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            
            SCLog(@"Collection Merchent List Request Data:%@", responseObject);
            // 遍历请求回来的商户数据，生成SCMerchant用于商户列表显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error       = nil;
                SCReservation *reservation = [[SCReservation alloc] initWithDictionary:obj error:&error];
                SCFailure(@"weather model parse error:%@", error);
                [_dataList addObject:reservation];
            }];
            
            [weakSelf hiddenHUD];
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:weakSelf.offset ? UITableViewRowAnimationTop : UITableViewRowAnimationFade];                                   // 数据配置完成，刷新商户列表
            weakSelf.offset += MerchantListLimit;                               // 偏移量请求参数递增
        }
        else
        {
            SCFailure(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
            ShowPromptHUDWithText(weakSelf.navigationController.view, responseObject[@"error"], 1.0f);
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCFailure(@"Get merchant list request error:%@", error);
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"网络错误，请重试！", 1.0f);
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
    [[SCAPIRequest manager] startUpdateReservationAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

@end
