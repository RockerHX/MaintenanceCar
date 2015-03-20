//
//  SCCouponDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponDetailViewController.h"
#import "SCCoupon.h"
#import "SCGroupProductDetail.h"
#import "SCCouponCell.h"
#import "SCBuyGroupProductCell.h"
#import "SCGroupProductMerchantCell.h"
#import "SCGroupProductDetailCell.h"
#import "SCShowMoreCell.h"
#import "SCCommentCell.h"
#import "SCBuyGroupProductViewController.h"
#import "SCCommentListViewController.h"
#import "SCReservationViewController.h"
#import "SCMerchant.h"
#import <SCLoopScrollView/SCLoopScrollView.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

typedef NS_ENUM(NSInteger, SCAlertType) {
    SCAlertTyperefund,
    SCAlertTypeCall
};

@interface SCCouponDetailViewController () <SCCouponCodeCellDelegate, SCGroupProductMerchantCellDelegate, UIAlertViewDelegate>
{
    SCGroupProductDetail *_detail;
}
@property (weak, nonatomic) SCGroupProductMerchantCell *merchantCell;
@property (weak, nonatomic)   SCGroupProductDetailCell *detailCell;
@property (weak, nonatomic)              SCCommentCell *commentCell;

@end

@implementation SCCouponDetailViewController

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
    self.tableView.tableFooterView.hidden = YES;
}

- (void)viewConfig
{
    self.tableView.tableFooterView = [_coupon expired] ? nil : _refundView;
    [self.tableView reLayoutHeaderView];
    [self startCouponDetailRequest];
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
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCodeCell" forIndexPath:indexPath];
                (((SCCouponCell *)cell)).delegate = self;
                [(SCCouponCell *)cell displayCellWithCoupon:_coupon];
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
    CGFloat height = DOT_COORDINATE;
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
            return DOT_COORDINATE;
    }
    if (section == 4 || section == 5)
        return DOT_COORDINATE;
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
    UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 30.0f)];
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, DOT_COORDINATE, 100.0f, 30.0f)];
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
        @try {
            SCCommentListViewController *commentListViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCCommentListViewController"];
            commentListViewController.companyID = _detail.companyID;
            commentListViewController.showTrashItem = NO;
            [self.navigationController pushViewController:commentListViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCCouponDetailViewController Go to the SCCommentListViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
}

#pragma mark - Private Methods
- (void)startCouponDetailRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakSelf = self;
    NSDictionary *parameters = @{@"product_id": _coupon.product_id};
    [[SCAPIRequest manager] startMerchantGroupProductDetailAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _detail              = [[SCGroupProductDetail alloc] initWithDictionary:responseObject error:nil];
            _detail.companyID    = _coupon.company_id;
            _detail.merchantName = _coupon.company_name;
            _detail.serviceDate  = _coupon.now;
            
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
    NSMutableArray *items = [@[] mutableCopy];
    UIImageView *carView  = [[UIImageView alloc] init];
    [carView setImageWithURL:[NSURL URLWithString:_detail.img1]
            placeholderImage:[UIImage imageNamed:@"MerchantImageDefault"]];
    [items addObject:carView];
    _couponImagesView.items = items;
    [_couponImagesView begin:nil finished:nil];
}

#pragma mark - SCGroupProductCellDelegate Methods
- (void)shouldShowBuyProductView
{
    @try {
        SCBuyGroupProductViewController *buyGroupProductViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCBuyGroupProductViewController"];
        buyGroupProductViewController.groupProductDetail = _detail;
        [self.navigationController pushViewController:buyGroupProductViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCCouponDetailViewController Go to the SCGroupProductViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - SCCouponCodeCell Delegate Methods
- (void)couponShouldReservationWithIndex:(NSInteger)index
{
    // 跳转到预约页面
    @try {
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.isGroup                      = YES;
        reservationViewController.merchant                     = [[SCMerchant alloc] initWithMerchantName:_coupon.company_name
                                                                                                companyID:_coupon.company_id];
        reservationViewController.reservationType              = _coupon.type;
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCCouponDetailViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
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
            [self showHUDOnViewController:self.navigationController];
            __weak typeof(self)weakSelf = self;
            NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                         @"group_ticket_id": _coupon.group_ticket_id};
            [[SCAPIRequest manager] startCouponRefundAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf hideHUDOnViewController:weakSelf.navigationController];
                if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
                    [weakSelf showHUDAlertToViewController:weakSelf.navigationController delegate:weakSelf text:@"退款成功" delay:0.5f];
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
