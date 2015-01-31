//
//  SCMapMerchantInfoView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/7.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCMapMerchantInfoViewDelegate <NSObject>

@optional
// [商户简介]栏被点击，需要跳转到商户详情页面
- (void)shouldShowMerchantDetail;

@end

@class SCMerchant;
@class SCStarView;

@interface SCMapMerchantInfoView : UIView

@property (nonatomic, weak) id                   <SCMapMerchantInfoViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView      *merchantIcon;        // 商户图标
@property (weak, nonatomic) IBOutlet UILabel          *merchantNameLabel;   // 商户名称栏 - 用于显示商户名称
@property (weak, nonatomic) IBOutlet UILabel          *distanceLabel;       // 商户距离栏 - 用于显示当前位置到商户的直线距离
@property (weak, nonatomic) IBOutlet UICollectionView *flagView;            // 商户标签栏 - 用于显示商户标签
@property (weak, nonatomic) IBOutlet SCStarView       *starView;            // 商户星级 - 用于显示商户评分
@property (weak, nonatomic) IBOutlet UILabel          *specialLabel;        // 商户特点栏 - 用于显示显示商户距离、价格、评价、服务等特点

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagViewWidthConstraint;   // 商户标签栏宽度

- (void)handelWithMerchant:(SCMerchant *)merchant;

@end
