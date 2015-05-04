//
//  SCBuyGroupProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"
#import "SCGroupProductDetail.h"
#import "SCQuotedPrice.h"

@protocol SCBuyGroupProductCellDelegate <NSObject>

@optional
- (void)shouldShowBuyProductView;
- (void)shouldReserveProduct;

@end

@interface SCBuyGroupProductCell : SCGroupProductCell

@property (weak, nonatomic) IBOutlet UIButton *bugProductButton;

@property (nonatomic, weak)       IBOutlet id <SCBuyGroupProductCellDelegate>delegate;

- (IBAction)bugProductButtonPressed:(id)sender;

- (void)displayCellWithDetail:(SCGroupProductDetail *)detail;
- (void)displayCellWithPrice:(SCQuotedPrice *)price;

@end
