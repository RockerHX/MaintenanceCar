//
//  SCBuyGroupProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"

@class SCGroupProductDetail;

@protocol SCBuyGroupProductCellDelegate <NSObject>

@optional
- (void)shouldShowBuyProductView;

@end

@interface SCBuyGroupProductCell : SCGroupProductCell

@property (weak, nonatomic) IBOutlet UIButton *bugProductButton;

@property (nonatomic, weak)       IBOutlet id <SCBuyGroupProductCellDelegate>delegate;

- (IBAction)bugProductButtonPressed:(id)sender;

- (void)displayCellWithDetail:(SCGroupProductDetail *)detail;

@end
