//
//  SCOderDetailPayCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@class SCOderDetail;

@protocol SCOderDetailPayCellDelegate <NSObject>

@optional
- (void)userWantToPayForOder;

@end

@interface SCOderDetailPayCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet      id  <SCOderDetailPayCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (IBAction)payOderButtonPressed;

- (void)displayCellWithDetail:(SCOderDetail *)detail;

@end
