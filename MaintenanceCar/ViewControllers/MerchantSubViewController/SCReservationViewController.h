//
//  SCReservationViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchant;

@interface SCReservationViewController : UITableViewController

@property (nonatomic, strong)        SCMerchant  *merchant;                     // 商户信息

@property (weak, nonatomic) IBOutlet UILabel     *merchantNameLabel;            // 商户名称栏
@property (weak, nonatomic) IBOutlet UITextField *ownerNameTextField;           // 车主姓名输入栏
@property (weak, nonatomic) IBOutlet UITextField *ownerPhoneNumberTextField;    // 车主电话输入栏
@property (weak, nonatomic) IBOutlet UILabel     *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel     *dateLabel;                    // 日期显示栏
@property (weak, nonatomic) IBOutlet UILabel     *timeLabel;                    // 时间显示栏
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;              // 其他需求输入栏
@property (weak, nonatomic) IBOutlet UIButton    *reservationButton;            // 预约按钮

@end
