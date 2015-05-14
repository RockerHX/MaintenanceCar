//
//  SCCouponsViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponsViewController.h"
#import "SCCouponCell.h"

@interface SCCouponsViewController ()

@end

@implementation SCCouponsViewController
{
    SCCouponCell *_couponCell;
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 优惠券"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 优惠券"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Action Methods
- (IBAction)ruleButtonPressed
{
    
}

- (IBAction)showInvalidCoupons
{
    
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCell" forIndexPath:indexPath];
    
//    NSArray *dataList = [self dataList];
//    if (dataList.count)
//        [cell displayCellWithOder:dataList[indexPath.row] index:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 139;//ZERO_POINT;
//    NSArray *dataList = [self dataList];
//    if (dataList.count)
//    {
//        if(!_myOderCell)
//            _myOderCell = [tableView dequeueReusableCellWithIdentifier:@"SCMyOderCell"];
//        height = [_myOderCell displayCellWithOder:dataList[indexPath.row] index:indexPath.row];
//    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    SCMyOderDetailViewController *myOderDetailViewController = USERCENTER_VIEW_CONTROLLER(@"SCMyOderDetailViewController");
//    myOderDetailViewController.delegate  = self;
//    myOderDetailViewController.reserveID = ((SCMyOder *)[self dataList][indexPath.row]).reserveID;
//    [self.navigationController pushViewController:myOderDetailViewController animated:YES];
}

@end
