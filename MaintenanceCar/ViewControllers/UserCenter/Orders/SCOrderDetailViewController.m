//
//  SCOrderDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderDetailViewController.h"
#import "SCOrderDetailSummaryCell.h"
#import "SCOrderDetailPayCell.h"
#import "SCOrderDetailPromptCell.h"
#import "SCOrderDetailProgressCell.h"
#import "SCMoreMenu.h"
#import "SCPayOrderViewController.h"

typedef NS_ENUM(NSUInteger, SCOrderDetailAlertType) {
    SCOrderAlertDetailTypeCallMerchant,
    SCOrderAlertDetailTypeCancelOrder
};

typedef NS_ENUM(NSUInteger, SCOrderDetailMenuType) {
    SCOrderDetailMenuTypeCancelReservetion
};

@interface SCOrderDetailViewController () <SCOrderDetailSummaryCellDelegate, SCOrderDetailPayCellDelegate, SCPayOrderViewControllerDelegate>
@end

@implementation SCOrderDetailViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 订单详情"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 订单详情"];
    
    if (_needRefresh)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(shouldRefresh)])
            [_delegate shouldRefresh];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Config Methods
- (void)viewConfig
{
    [super viewConfig];
    
    UIView *footer         = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 40.0f)];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _detail ? 2 : Zero;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detail ? (section ? _detail.processes.count + 1 : (_detail.canPay ? 2 : 1)) : Zero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_detail)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                if (!indexPath.row)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCOrderDetailSummaryCell" forIndexPath:indexPath];
                    [(SCOrderDetailSummaryCell *)cell displayCellWithDetail:_detail];
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCOrderDetailPayCell" forIndexPath:indexPath];
                    [(SCOrderDetailPayCell *)cell displayCellWithDetail:_detail];
                }
            }
                break;
            case 1:
            {
                if (indexPath.row)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCOrderDetailProgressCell" forIndexPath:indexPath];
                    [(SCOrderDetailProgressCell *)cell displayCellWithDetail:_detail index:(indexPath.row-1)];
                }
                else
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCOrderDetailPromptCell" forIndexPath:indexPath];
            }
                break;
        }
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 10.0f;
    if (_detail)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                if (!indexPath.row)
                {
                    height += [tableView fd_heightForCellWithIdentifier:@"SCOrderDetailSummaryCell" cacheByIndexPath:indexPath configuration:^(SCOrderDetailSummaryCell *cell) {
                        [cell displayCellWithDetail:_detail];
                    }];
                }
                else
                {
                    height += [tableView fd_heightForCellWithIdentifier:@"SCOrderDetailPayCell" cacheByIndexPath:indexPath configuration:^(SCOrderDetailPayCell *cell) {
                        [cell displayCellWithDetail:_detail];
                    }];
                }
            }
                break;
            case 1:
            {
                if (indexPath.row)
                {
                    height += [tableView fd_heightForCellWithIdentifier:@"SCOrderDetailProgressCell" cacheByIndexPath:indexPath configuration:^(SCOrderDetailProgressCell *cell) {
                        [cell displayCellWithDetail:_detail index:(indexPath.row-1)];
                    }];
                }
                else
                    height = 44.0f;
            }
                break;
        }
    }
    
    return height;
}

#pragma mark - Public Methods
- (void)startDropDownRefreshReuqest
{
    [super startDropDownRefreshReuqest];
    [self startOrderDetailRequest];
}

#pragma mark - Private Methods
/**
 *  订单详情数据请求方法，必选参数：user_id，reserve_id
 */
- (void)startOrderDetailRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                              @"reserve_id": _reserveID};
    [[SCAPIRequest manager] startOrderDetailAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode)
            {
                case SCAPIRequestErrorCodeNoError:
                {
                    _detail = [[SCOrderDetail alloc] initWithDictionary:responseObject[@"data"] error:nil];
                    [weakSelf displayDetailViewController];
                }
                    break;
            }
            if (statusMessage.length)
                [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
        }
        [weakSelf endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hanleFailureResponseWtihOperation:operation];
        [weakSelf endRefresh];
    }];
}

- (void)displayDetailViewController
{
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = _detail.canCancel ? [self rightBarButtonItem] : nil;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MoreIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showCancelAlert)];
    return item;
}

- (void)showCancelAlert
{
    __weak typeof(self)weakSelf = self;
    SCMoreMenu *moreMenu = [[SCMoreMenu alloc] initWithTitles:@[@"取消订单"] images:nil];
    [moreMenu show:^(NSInteger selectedIndex) {
        switch (selectedIndex)
        {
            case SCOrderDetailMenuTypeCancelReservetion:
                [weakSelf showAlertWithTitle:@"您确定要取消此订单吗？" message:nil delegate:self tag:SCOrderAlertDetailTypeCancelOrder cancelButtonTitle:@"否" otherButtonTitle:@"是"];
                break;
        }
    }];
}

/**
 *  取消订单请求方法，必选参数：company_id，user_id，reserve_id，status
 */
- (void)startCancelOrderRequest
{
    [self showHUDOnViewController:self.navigationController];
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"user_id": [SCUserInfo share].userID,
                             @"company_id": _detail.companyID,
                             @"reserve_id": _detail.reserveID,
                                 @"status": @"4"};
    [[SCAPIRequest manager] startUpdateReservationAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf.navigationController];
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode)
            {
                case SCAPIRequestErrorCodeNoError:
                {
                    _needRefresh = YES;
                    [weakSelf.tableView.header beginRefreshing];
                }
                    break;
            }
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:statusMessage];
        }
        else
            [weakSelf showHUDAlertToViewController:weakSelf text:DataError];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideHUDOnViewController:weakSelf.navigationController];
        [weakSelf hanleFailureResponseWtihOperation:operation];
    }];
}

#pragma mark - SCOrderDetailSummaryCellDelegate Methods
- (void)shouldCallMerchantWithPhone:(NSString *)phone
{
    [self showAlertWithTitle:@"是否拨打商家电话？" message:phone delegate:self tag:Zero cancelButtonTitle:@"取消" otherButtonTitle:@"拨打"];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        switch (alertView.tag)
        {
            case SCOrderAlertDetailTypeCallMerchant:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
                break;
            case SCOrderAlertDetailTypeCancelOrder:
                [self startCancelOrderRequest];
                break;
            case SCViewControllerAlertTypeNeedLogin:
                [self checkShouldLogin];
                break;
        }
    }
}

#pragma mark - SCOrderDetailPayCellDelegate Methods
- (void)userWantToPayForOrder
{
    SCPayOrderViewController *payOrderViewController = [SCPayOrderViewController instance];
    payOrderViewController.orderDetail  = _detail;
    [self.navigationController pushViewController:payOrderViewController animated:YES];
}

#pragma mark - SCPayOrderViewControllerDelegate Methods
- (void)orderPaySucceed
{
    [self.tableView.header beginRefreshing];
}

@end
