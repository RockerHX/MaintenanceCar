//
//  SCGroupProductMerchantCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCGroupProductMerchantCellDelegate <NSObject>

@optional
- (void)shouldCallMerchant;

@end

@class SCStarView;
@class SCGroupProductDetail;

@interface SCGroupProductMerchantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet    UILabel *nameLabel;         // 商家名称栏 - 用于显示商家名称
@property (weak, nonatomic) IBOutlet SCStarView *starView;          // 商家星级 - 用于显示商家评分
@property (weak, nonatomic) IBOutlet    UILabel *distanceLabel;     // 商家距离栏 - 用于显示当前位置到商家的直线距离
@property (weak, nonatomic) IBOutlet    UILabel *addressLabel;      // 商家地址栏 - 用于显示显示商家地址

@property (weak, nonatomic) IBOutlet         id <SCGroupProductMerchantCellDelegate>delegate;

- (IBAction)callButtonPressed:(id)sender;

- (void)displayCellWithDetial:(SCGroupProductDetail *)detail;

@end