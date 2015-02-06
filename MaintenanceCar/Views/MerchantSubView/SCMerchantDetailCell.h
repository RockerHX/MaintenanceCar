//
//  SCMerchantDetailCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMerchantDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet          UILabel *merchantNameLabel;    // 商户名称栏 - 用于显示商户名称
@property (weak, nonatomic) IBOutlet          UILabel *distanceLabel;        // 商户距离栏 - 用于显示当前位置到商户的直线距离
@property (weak, nonatomic) IBOutlet UICollectionView *flagView;             // 商户标签栏 - 用于显示商户标签
@property (weak, nonatomic) IBOutlet         UIButton *reservationButton;    // 预约按钮

@property (nonatomic, copy)                  NSString *majors;               // 专修品牌

- (void)hanleMerchantFlags:(NSArray *)merchantFlags;

/**
 *  [预约]按钮点击事件方法
 *
 *  @param sender 被点击的按钮实例
 */
- (IBAction)reservationButtonPressed:(UIButton *)sender;

@end
