//
//  SCMerchantTableViewCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantCell.h"

@interface SCMerchantTableViewCell : SCMerchantCell

@property (weak, nonatomic) IBOutlet           UIButton *reservationButton; // 预约按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;       // [预约]按钮宽度约束

/**
 *  [预约]按钮点击事件方法
 *
 *  @param sender 被点击的按钮实例
 */
- (IBAction)reservationButtonPressed:(UIButton *)sender;

@end
