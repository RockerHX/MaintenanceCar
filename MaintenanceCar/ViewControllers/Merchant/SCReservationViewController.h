//
//  SCReservationViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"
#import "SCMerchant.h"

@class SCServiceItem;

@interface SCReservationViewController : UITableViewController

@property (weak, nonatomic) IBOutlet     UILabel *merchantNameLabel;            // 商家名称栏
@property (weak, nonatomic) IBOutlet UITextField *ownerNameTextField;           // 车主姓名输入栏
@property (weak, nonatomic) IBOutlet UITextField *ownerPhoneNumberTextField;    // 车主电话输入栏
@property (weak, nonatomic) IBOutlet     UILabel *carLabel;                     // 用户车辆栏
@property (weak, nonatomic) IBOutlet     UILabel *projectLabel;                 // 服务项目栏
@property (weak, nonatomic) IBOutlet     UILabel *dateLabel;                    // 日期显示栏
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;              // 其他需求输入栏
@property (weak, nonatomic) IBOutlet    UIButton *reservationButton;            // 预约按钮

@property (nonatomic, strong)      SCMerchant    *merchant;                     // 商家信息
@property (nonatomic, strong)      SCServiceItem *serviceItem;                  // 服务项目
@property (nonatomic, copy)             NSString *reservationType;
@property (nonatomic, assign)               BOOL  isGroup;

@end
