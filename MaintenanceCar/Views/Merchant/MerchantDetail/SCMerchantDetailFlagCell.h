//
//  SCMerchantDetailFlagCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchantFlag;

@protocol SCMerchantDetailFlagCellDelegate <NSObject>

@optional
- (void)flagPressedWithMessage:(NSString *)message;

@end

@interface SCMerchantDetailFlagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet      UIView *flagBgView;

@property (weak, nonatomic) IBOutlet UIImageView *flagIcon;
@property (weak, nonatomic) IBOutlet     UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet     UILabel *promptLabel;

@property (nonatomic, weak) IBOutlet          id  <SCMerchantDetailFlagCellDelegate>delegate;

- (void)displayCellWithMerchangFlag:(SCMerchantFlag *)flag;

@end
