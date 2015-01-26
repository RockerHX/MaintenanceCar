//
//  SCMerchantTableViewCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCStarView;
@class SCMerchant;

@interface SCMerchantTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView                 *merchantIcon;          // 商户图标
@property (weak, nonatomic) IBOutlet UILabel                     *merchantNameLabel;     // 商户名称栏 - 用于显示商户名称
@property (weak, nonatomic) IBOutlet UILabel                     *distanceLabel;         // 商户距离栏 - 用于显示当前位置到商户的直线距离
@property (weak, nonatomic) IBOutlet UILabel                     *zigeLable;             // 商户特点 - [一][二][三]类厂
@property (weak, nonatomic) IBOutlet UILabel                     *honestLabel;           // 商户特点 - [诚]
@property (weak, nonatomic) IBOutlet UILabel                     *majorTypeLabel;        // 商户特点 - [专]
@property (weak, nonatomic) IBOutlet UILabel                     *specialLabel;          // 商户特点栏 - 用于显示显示商户距离、价格、评价、服务等特点
@property (weak, nonatomic) IBOutlet SCStarView                  *starView;              // 商户星级

@property (weak, nonatomic) IBOutlet UIButton                    *reservationButton;     // 预约按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint          *buttonWidth;           // [预约]按钮宽度约束

@property (nonatomic, weak)          NSDictionary                *colors;                // 颜色值集合

/**
 *  [预约]按钮点击事件方法
 *
 *  @param sender 被点击的按钮实例
 */
- (IBAction)reservationButtonPressed:(UIButton *)sender;

- (void)handelWithMerchant:(SCMerchant *)merchant indexPath:(NSIndexPath *)indexPath;

@end
