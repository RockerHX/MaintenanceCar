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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.tableView reloadData];
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
        
    }
}

@end
