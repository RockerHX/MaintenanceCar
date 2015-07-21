//
//  SCCouponDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponDetailViewController.h"
#import "SCCouponCell.h"
#import "SCCouponDetailShowMoreMerchantsCell.h"
#import "SCCouponDetailRuleCell.h"
#import "SCOperationViewController.h"

typedef NS_ENUM(NSUInteger, SCCouponDetailRow) {
    SCCouponDetailRowCoupon,
    SCCouponDetailRowShowMoreMerchants,
    SCCouponDetailRowRule,
};

@implementation SCCouponDetailViewController
{
    SCCouponCell           *_couponCell;
    SCCouponDetailRuleCell *_ruleCell;
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[优惠券] - 详情"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[优惠券] - 详情"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameCoupon];
}

#pragma mark - Table View Data Source Methods
static NSInteger rowNumber = 3;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _coupon ? rowNumber : Zero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_coupon)
    {
        switch (indexPath.row)
        {
            case SCCouponDetailRowCoupon:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCell" forIndexPath:indexPath];
                ((SCCouponCell *)cell).canNotUse = _couponCanNotUse;
                [(SCCouponCell *)cell displayCellWithCoupon:_coupon];
            }
                break;
            case SCCouponDetailRowRule:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponDetailRuleCell" forIndexPath:indexPath];
                [(SCCouponCell *)cell displayCellWithCoupon:_coupon];
            }
                break;
                
            default:
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponDetailShowMoreMerchantsCell" forIndexPath:indexPath];
                break;
        }
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = Zero;
    if (_coupon)
    {
        switch (indexPath.row)
        {
            case SCCouponDetailRowCoupon:
            {
                if(!_couponCell)
                    _couponCell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCell"];
                height = [_couponCell displayCellWithCoupon:_coupon];
            }
                break;
            case SCCouponDetailRowRule:
            {
                if(!_ruleCell)
                    _ruleCell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponDetailRuleCell"];
                height = [_ruleCell displayCellWithCoupon:_coupon];
            }
                break;
                
            default:
                height = 60.0f;
                break;
        }
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == SCCouponDetailRowShowMoreMerchants)
    {
        SCOperationViewController *viewController = [SCOperationViewController instance];
        viewController.title = @"优惠券商家";
        [viewController setRequestParameter:@"service" value:@"coupon"];
        [viewController setRequestParameter:@"coupon_code" value:_coupon.code];
        [viewController setRequestParameter:@"return_only_matched" value:@"1"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
