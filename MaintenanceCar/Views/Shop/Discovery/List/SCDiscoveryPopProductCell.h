//
//  SCDiscoveryPopProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@class SCShopProduct;

@interface SCDiscoveryPopProductCell : SCTableViewCell {
    NSArray *_firstCellShadowPathPoints;
    NSArray *_otherCellShadowPathPoints;
    
    CAGradientLayer *_shadowLayer;
}

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet     UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet     UILabel *discountPriceLabel;

- (void)displayCellWithProduct:(SCShopProduct *)product index:(NSInteger)index;

@end
