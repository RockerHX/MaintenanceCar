//
//  SCGroupTicketsViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/4.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupTicketsViewController.h"
#import "SCGroupTicketCell.h"
#import "SCGroupTicketDetailViewController.h"
#import "SCReservationViewController.h"

@interface SCGroupTicketsViewController () <SCGroupTicketCodeCellDelegate, SCReservationViewControllerDelegate>
@end

@implementation SCGroupTicketsViewController

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance {
    static UINavigationController *navigationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navigationController = [SCStoryBoardManager navigaitonControllerWithIdentifier:@"GroupTicketsNavigationController"
                                                                        storyBoardName:SCStoryBoardNameGroupTicket];
    });
    return navigationController;
}

+ (instancetype)instance {
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameGroupTicket];
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 团购券"];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 团购券"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCGroupTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupTicketCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell displayCellWithTicket:_dataList[indexPath.row] index:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SCGroupTicket *ticket = _dataList[indexPath.row];
    return ![ticket expired];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Table View Delegate Methods
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCGroupTicket *ticket = _dataList[indexPath.row];
    return [ticket expiredPrompt];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SCGroupTicket *ticket = _dataList[indexPath.row];
    SCGroupTicketDetailViewController *groupTicketDetailViewController = [SCGroupTicketDetailViewController instance];
    groupTicketDetailViewController.ticket = ticket;
    [self.navigationController pushViewController:groupTicketDetailViewController animated:YES];
}

#pragma mark - Public Methods
- (void)startDropDownRefreshReuqest {
    [super startDropDownRefreshReuqest];
    [self startGroupTicketsListRequest];
}

- (void)startPullUpRefreshRequest {
    [super startPullUpRefreshRequest];
    [self startGroupTicketsListRequest];
}

#pragma mark - Private Methods
- (void)startGroupTicketsListRequest {
    WEAK_SELF(weakSelf);
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                   @"limit": @(SearchLimit),
                                  @"offset": @(self.offset)};
    [[SCAPIRequest manager] startGroupTicketsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess) {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode) {
                case SCAPIRequestErrorCodeNoError: {
                    if (weakSelf.requestType == SCRequestRefreshTypeDropDown) {
                        [weakSelf clearListData];
                    }
                    // 遍历请求回来的订单数据，生成SCGroupTicket用于团购券列表显示
                    [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SCGroupTicket *ticket = [[SCGroupTicket alloc] initWithDictionary:obj error:nil];
                        [_dataList addObject:ticket];
                    }];
                    
                    weakSelf.offset += SearchLimit;               // 偏移量请求参数递增
                    [weakSelf.tableView reloadData];                    // 数据配置完成，刷新商家列表
                    [weakSelf addRefreshHeader];
                    [weakSelf addRefreshFooter];
                }
                    break;
                    
                case SCAPIRequestErrorCodeListNotFoundMore: {
                    [weakSelf addRefreshHeader];
                    [weakSelf removeRefreshFooter];
                }
                    break;
            }
            if (statusMessage.length) {
                [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
            }
        }
        [weakSelf endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hanleFailureResponseWtihOperation:operation];
        [weakSelf endRefresh];
    }];
}

#pragma mark - SCTicketCodeCellDelegate Methods
- (void)ticketShouldReservationWithIndex:(NSInteger)index {
    // 跳转到预约页面
    [[SCUserInfo share] removeItems];
    SCGroupTicket *ticket = _dataList[index];
    SCReservationViewController *reservationViewController = [SCReservationViewController instance];
    reservationViewController.delegate    = self;
    reservationViewController.merchant    = [[SCMerchant alloc] initWithMerchantName:ticket.company_name
                                                                           companyID:ticket.company_id];
    reservationViewController.serviceItem = [[SCServiceItem alloc] initWithServiceID:ticket.type];
    reservationViewController.groupTicket = _dataList[index];
    [self.navigationController pushViewController:reservationViewController animated:YES];
}

- (void)ticketShouldShowWithIndex:(NSInteger)index {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [NOTIFICATION_CENTER postNotificationName:kShowTicketNotification object:nil];
}

#pragma mark - SCReservationViewControllerDelegate Methods
- (void)reservationSuccess {
    [self startDropDownRefreshReuqest];
}

@end
