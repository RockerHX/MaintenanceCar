//
//  SCMerchantDetailCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMerchantDetail.h"

@class SCStarView;

@protocol SCMerchantDetailCellDelegate <NSObject>

@optional
- (void)shouldReservation;

@end

@interface SCMerchantDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet          UILabel *merchantNameLabel;    // 商家名称栏 - 用于显示商家名称
@property (weak, nonatomic) IBOutlet          UILabel *distanceLabel;        // 商家距离栏 - 用于显示当前位置到商家的直线距离
@property (weak, nonatomic) IBOutlet UICollectionView *flagView;             // 商家标签栏 - 用于显示商家标签
@property (weak, nonatomic) IBOutlet         UIButton *reservationButton;    // 预约按钮
@property (weak, nonatomic) IBOutlet       SCStarView *starView;             // 商家星级 - 用于显示商家评分

@property (nonatomic, weak)                        id  <SCMerchantDetailCellDelegate>delegate;
@property (nonatomic, assign)               NSInteger  index;

- (void)displayCellWithSummary:(SCMerchantSummary *)detailSummary;

/**
 *  [预约]按钮点击事件方法
 *
 *  @param sender 被点击的按钮实例
 */
- (IBAction)reservationButtonPressed:(UIButton *)sender;

@end
