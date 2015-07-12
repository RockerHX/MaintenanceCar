//
//  SCGroupTicketDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupTicketDetailViewController.h"
#import "SCGroupProductDetail.h"
#import "SCGroupTicketCodeCell.h"
#import "SCBuyGroupProductCell.h"
#import "SCGroupProductMerchantCell.h"
#import "SCGroupProductDetailCell.h"
#import "SCShowMoreCell.h"
#import "SCCommentCell.h"
#import "SCPayOrderViewController.h"
#import "SCCommentListViewController.h"
#import "SCReservationViewController.h"
#import <SCLoopScrollView/SCLoopScrollView.h>
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSInteger, SCAlertType) {
    SCAlertTyperefund,
    SCAlertTypeCall
};

@interface SCGroupTicketDetailViewController () <SCGroupTicketCodeCellDelegate, SCGroupProductMerchantCellDelegate, SCReservationViewControllerDelegate>
{
    SCGroupProductDetail *_detail;
}
@property (weak, nonatomic) SCGroupProductMerchantCell *merchantCell;
@property (weak, nonatomic)   SCGroupProductDetailCell *detailCell;
@property (weak, nonatomic)              SCCommentCell *commentCell;

@end

@implementation SCGroupTicketDetailViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 团购券详情"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 团购券详情"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
}

- (void)viewConfig
{
    BOOL hidden = ([_ticket expired] || (_ticket.state != SCGroupTicketStateUnUse));
    self.tableView.tableFooterView = hidden ? nil : _refundView;
    [self.tableView reLayoutHeaderView];
    [self startTicketDetailRequest];
}

#pragma mark - Action Methods
- (IBAction)refundButtonPressed:(id)sender
{
    [self showAlertWithTitle:@"温馨提示"
                     message:@"您确定真的要退掉这张团购券吗？"
                    delegate:self
                         tag:SCAlertTyperefund
           cancelButtonTitle:@"确定"
            otherButtonTitle:@"取消"];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _detail ? 6 : Zero;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detail ? ((section == 5) ? _detail.comments.count : 1) : Zero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_detail)
    {
        switch (indexPath.section)
        {
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupTicketCodeCell" forIndexPath:indexPath];
                (((SCGroupTicketCodeCell *)cell)).delegate = self;
                [(SCGroupTicketCodeCell *)cell displayCellWithTicket:_ticket index:Zero];
            }
                break;
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupProductMerchantCell" forIndexPath:indexPath];
                (((SCGroupProductMerchantCell *)cell)).delegate = self;
                [(SCGroupProductMerchantCell *)cell displayCellWithDetial:_detail];
            }
                break;
            case 3:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupProductDetailCell" forIndexPath:indexPath];
                [(SCGroupProductDetailCell *)cell displayCellWithDetail:_detail];
            }
                break;
            case 4:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCShowMoreCell" forIndexPath:indexPath];
                ((SCShowMoreCell *)cell).count = _detail.comments_num;
            }
                break;
            case 5:
            {
                if (_detail.comments.count)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCCommentCell" forIndexPath:indexPath];
                    [(SCCommentCell *)cell displayCellWithComment:_detail.comments[indexPath.row]];
                }
                else
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCNoneCommentCell" forIndexPath:indexPath];
            }
                break;
            
            default:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCBuyGroupProductCell" forIndexPath:indexPath];
                [(SCBuyGroupProductCell *)cell displayCellWithDetail:_detail];
            }
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ZERO_POINT;
    CGFloat separatorHeight = 1.0f;
    if (_detail)
    {
        switch (indexPath.section)
        {
            case 2:
            {
                if(!_merchantCell)
                    _merchantCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCGroupProductMerchantCell"];
                [_merchantCell displayCellWithDetial:_detail];
                height = [_merchantCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
                break;
            case 3:
            {
                if(!_detailCell)
                    _detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCGroupProductDetailCell"];
                [_detailCell displayCellWithDetail:_detail];
                height = [_detailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
                break;
            case 5:
            {
                if(!_commentCell)
                    _commentCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCCommentCell"];
                [_commentCell displayCellWithComment:_detail.comments[indexPath.row]];
                height = [_commentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
                break;
                
            default:
                return indexPath.section ? 44.0f : 70.0f;
                break;
        }
    }
    
    return height + separatorHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section)
    {
        if (IS_IPHONE_6)
            return 40.0f;
        else if (IS_IPHONE_6Plus)
            return 60.0f;
        else
            return ZERO_POINT;
    }
    if (section == 4 || section == 5)
        return ZERO_POINT;
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *text  = @"";
    switch (section)
    {
        case 1:
            text = @"团购券信息";
            break;
        case 2:
            text = @"商家详情";
            break;
        case 3:
            text = @"团购详情";
            break;
            
        default:
            return nil;
            break;
    }
    UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 30.0f)];
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, ZERO_POINT, 100.0f, 30.0f)];
    label.font      = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    label.text = text;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SCShowMoreCell class]])
    {
        SCCommentListViewController *commentListViewController = MAIN_VIEW_CONTROLLER(@"SCCommentListViewController");
        commentListViewController.companyID = _detail.company_id;
        [self.navigationController pushViewController:commentListViewController animated:YES];
    }
}

#pragma mark - Private Methods
- (void)startTicketDetailRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WEAK_SELF(weakSelf);
    NSDictionary *parameters = @{@"product_id": _ticket.product_id};
    [[SCAPIRequest manager] startMerchantGroupProductDetailAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _detail             = [[SCGroupProductDetail alloc] initWithDictionary:responseObject error:nil];
            _detail.company_id  = _ticket.company_id;
            _detail.name        = _ticket.company_name;
            
            [weakSelf dispalyDetialView];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.tableFooterView.hidden = NO;
        }
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

- (void)dispalyDetialView
{
    _ticketImagesView.images = @[[UIImage imageNamed:@"MerchantImageDefault"]];
    [_ticketImagesView show:nil finished:nil];
}

#pragma mark - SCGroupProductCellDelegate Methods
- (void)shouldShowBuyProductView
{
    SCPayOrderViewController *payOrderViewController = [SCPayOrderViewController instance];
    payOrderViewController.groupProduct = _detail;
    [self.navigationController pushViewController:payOrderViewController animated:YES];
}

#pragma mark - SCTicketCodeCellDelegate Methods
- (void)ticketShouldReservationWithIndex:(NSInteger)index
{
    // 跳转到预约页面
    @try {
        [[SCUserInfo share] removeItems];
        SCReservationViewController *reservationViewController = [SCReservationViewController instance];
        reservationViewController.delegate    = self;
        reservationViewController.merchant    = [[SCMerchant alloc] initWithMerchantName:_ticket.company_name
                                                                               companyID:_ticket.company_id];
        reservationViewController.serviceItem = [[SCServiceItem alloc] initWithServiceID:_ticket.type];
        reservationViewController.groupTicket = _ticket;
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

- (void)ticketShouldShowWithIndex:(NSInteger)index
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [NOTIFICATION_CENTER postNotificationName:kShowTicketNotification object:nil];
}

#pragma mark - SCGroupProductMerchantCell Delegate Methods
- (void)shouldCallToMerchant
{
    if (_detail.telephone.length)
    {
        NSArray *phones = [_detail.telephone componentsSeparatedByString:@" "];
        UIAlertView *alertView = nil;
        if (phones.count > 1)
        {
            alertView = [[UIAlertView alloc] initWithTitle:@"是否拨打商家电话"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:[phones firstObject], [phones lastObject], nil];
        }
        else
        {
            alertView = [[UIAlertView alloc] initWithTitle:@"是否拨打商家电话"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:[phones firstObject], nil];
        }
        alertView.tag = SCAlertTypeCall;
        [alertView show];
    }
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == SCAlertTyperefund)
    {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            WEAK_SELF(weakSelf);
            [self showHUDOnViewController:self.navigationController];
            NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"group_ticket_id": _ticket.group_ticket_id};
            [[SCAPIRequest manager] startGroupTicketRefundAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf hideHUDOnViewController:weakSelf.navigationController];
                if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
                {
                    weakSelf.tableView.tableFooterView = nil;
                    [weakSelf showHUDAlertToViewController:weakSelf.navigationController delegate:weakSelf text:@"退款成功" delay:0.5f];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf hideHUDOnViewController:weakSelf.navigationController];
                [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"退款失败，请重试或者联系客服..." delay:0.5f];
            }];
        }
    }
    else
    {
        NSArray *phones = [_detail.telephone componentsSeparatedByString:@" "];
        if (buttonIndex == 1)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [phones firstObject]]]];
        else if (buttonIndex == 2)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [phones lastObject]]]];
    }
}

@end
