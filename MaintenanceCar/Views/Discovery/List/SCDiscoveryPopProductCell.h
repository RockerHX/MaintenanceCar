//
//  SCDiscoveryPopProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@interface SCDiscoveryPopProductCell : SCTableViewCell
{
    CAGradientLayer *_shadowLayer;
}

@property (weak, nonatomic) IBOutlet UIImageView *hotIcon;
@property (weak, nonatomic) IBOutlet     UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet     UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet     UILabel *discountPriceLabel;

- (void)displayCellWithProducts:(NSArray *)products index:(NSInteger)index;

@end
