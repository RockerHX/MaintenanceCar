//
//  SCBugGroupProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"

@class SCGroupProductDetail;

@protocol SCBugGroupProductCellDelegate <NSObject>

@optional
- (void)shouldShowBuyProductView;

@end

@interface SCBugGroupProductCell : SCGroupProductCell

@property (nonatomic, weak)      IBOutlet id <SCBugGroupProductCellDelegate>delegate;

- (IBAction)bugProductButtonPressed:(id)sender;

- (void)displayCellWithGroupProductDetail:(SCGroupProductDetail *)detail;

@end
