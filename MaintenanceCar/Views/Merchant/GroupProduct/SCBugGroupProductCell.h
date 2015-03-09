//
//  SCBugGroupProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"

@class SCGroupProductDetail;
@class SCCouponDetail;

@protocol SCBugGroupProductCellDelegate <NSObject>

@optional
- (void)shouldShowBuyProductView;

@end

@interface SCBugGroupProductCell : SCGroupProductCell

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic, weak)      IBOutlet id <SCBugGroupProductCellDelegate>delegate;

- (IBAction)bugProductButtonPressed:(id)sender;

- (void)displayCellWithProductDetial:(SCGroupProductDetail *)detail;
- (void)displayCellWithCouponDetial:(SCCouponDetail *)detail;

@end
