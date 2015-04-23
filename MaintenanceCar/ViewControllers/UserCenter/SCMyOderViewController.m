//
//  SCMyOderViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOderViewController.h"
#import "SCMyProgressOderCell.h"

@interface SCMyOderViewController () <SCMyOderCellDelegate>
{
    SCMyProgressOderCell *_myProgressOderCell;
    SCMyOderReuqest       _myOderRequest;
}

@end

@implementation SCMyOderViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 我的订单"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 我的订单"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMyOderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMyProgressOderCell" forIndexPath:indexPath];
    if (_dataList.count)
    {
        SCMyProgressOder *myProgressOder = _dataList[indexPath.row];
        [cell displayCellWithReservation:myProgressOder index:indexPath.row];
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (_dataList.count)
    {
        SCMyProgressOder *myProgressOder = _dataList[indexPath.row];
        if(!_myProgressOderCell)
            _myProgressOderCell = [tableView dequeueReusableCellWithIdentifier:@"SCMyProgressOderCell"];
        height = [_myProgressOderCell displayCellWithReservation:myProgressOder index:indexPath.row];
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Public Methods
- (void)startDropDownRefreshReuqest
{
    [super startDropDownRefreshReuqest];
    [self startOdersReuqest];
}

- (void)startPullUpRefreshRequest
{
    [super startPullUpRefreshRequest];
    [self startOdersReuqest];
}

- (void)startOdersReuqest
{
    switch (_myOderRequest)
    {
        case SCMyOderReuqestProgress:
            [self startProgressOdersRequest];
            break;
        case SCMyOderReuqestFinished:
            [self startFinishedOdersRequest];
            break;
    }
}

#pragma mark - Private Methods
/**
 *  进行中的列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startProgressOdersRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"limit": @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startMyProgressOdersAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf requestSuccessWithOperation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf requestFailureWithOperation:operation];
    }];
}

/**
 *  已完成的列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startFinishedOdersRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                   @"limit": @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startMyFinishedOdersAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf requestSuccessWithOperation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf requestFailureWithOperation:operation];
    }];
}

- (void)requestSuccessWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject
{
    if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
    {
        NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
        NSString *statusMessage = responseObject[@"status_message"];
        switch (statusCode)
        {
            case SCAPIRequestErrorCodeNoError:
            {
                // 遍历请求回来的订单数据，生成SCReservation用于订单列表显示
                [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCMyProgressOder *oder = [[SCMyProgressOder alloc] initWithDictionary:obj error:nil];
                    [_dataList addObject:oder];
                }];
                
                [self.tableView reloadData];                    // 数据配置完成，刷新商家列表
                [self readdFooter];
                self.offset += MerchantListLimit;               // 偏移量请求参数递增
            }
                break;
                
            case SCAPIRequestErrorCodeListNotFoundMore:
                [self removeFooter];
                break;
        }
        if (![statusMessage isEqualToString:@"success"])
            [self showHUDAlertToViewController:self text:statusMessage];
    }
    [self endRefresh];
}

- (void)requestFailureWithOperation:(AFHTTPRequestOperation *)operation
{
    [self hanleFailureResponseWtihOperation:operation];
    [self endRefresh];
}

#pragma mark - SCNavigationTabDelegate Methods
- (void)didSelectedItemAtIndex:(NSInteger)index
{
    _myOderRequest = index;
    [self restartDropDownRefreshRequest];
}

#pragma mark - SCMyOderCellDelegate Methods
- (void)shouldCallMerchantWithPhone:(NSString *)phone
{
    [self showAlertWithTitle:@"是否拨打商家电话？" message:phone delegate:self tag:Zero cancelButtonTitle:@"取消" otherButtonTitle:@"拨打"];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
}

@end
