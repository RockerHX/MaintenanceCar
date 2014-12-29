//
//  SCReservationViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCReservationViewController.h"
#import "SCMerchant.h"

typedef NS_ENUM(NSInteger, UITableViewRowIndex) {
    UITableViewRowIndexProject = 3,
    UITableViewRowIndexDate,
    UITableViewRowIndexTime
};

@interface SCReservationViewController () <UITextFieldDelegate, UITextViewDelegate>

- (IBAction)reservationButtonPressed:(UIButton *)sender;

@end

@implementation SCReservationViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 开启cell高度预估，自动适配cell高度
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 设置商户名称显示
    _merchantNameLabel.text = _merchant.detail.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击[项目][日期][时间]栏触发选择动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case UITableViewRowIndexProject:
        {
        }
            break;
        case UITableViewRowIndexDate:
        {
        }
            break;
        case UITableViewRowIndexTime:
        {
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Button Action Methods
- (IBAction)reservationButtonPressed:(UIButton *)sender
{
}

#pragma mark - Text Field Delegate Methods
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 在车主姓名栏点击[下一项]跳到车主电话栏，车主电话栏和备注栏点击[完成]收起键盘
    if (textField == _ownerNameTextField)
    {
        [_ownerPhoneNumberTextField becomeFirstResponder];
        return NO;
    }
    else
    {
        [textField resignFirstResponder];
        return YES;
    }
}

@end
