//
//  SCGroupProductDetailCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"

@protocol SCGroupProductCellDetailDelegate <NSObject>

@optional
- (void)shouldShowBuyProductView;

@end

@interface SCGroupProductDetailCell : SCGroupProductCell

@property (nonatomic, weak)      IBOutlet id <SCGroupProductCellDetailDelegate>delegate;

- (IBAction)bugProductButtonPressed:(id)sender;

@end
