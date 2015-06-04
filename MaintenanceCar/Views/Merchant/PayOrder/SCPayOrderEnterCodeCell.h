//
//  SCPayOrderEnterCodeCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@protocol SCPayOrderEnterCodeCellDelegate <NSObject>

@optional
- (void)shouldEnterCouponCode;

@end

@interface SCPayOrderEnterCodeCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet       id  <SCPayOrderEnterCodeCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *enterCodeButton;

- (IBAction)enterCodeButtonPressed;
- (void)displayCellWithPaySucceed:(BOOL)paySucceed;

@end
