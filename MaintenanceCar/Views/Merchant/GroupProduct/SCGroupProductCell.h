//
//  SCGroupProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGroupProduct;

@interface SCGroupProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

- (void)displayCellWithProduct:(SCGroupProduct *)product;

@end
