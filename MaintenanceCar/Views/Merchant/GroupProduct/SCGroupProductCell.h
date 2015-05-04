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
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftParenthesis;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightParenthesis;
@property (weak, nonatomic) IBOutlet  UIView *grayLine;

- (void)displayCellWithProduct:(SCGroupProduct *)product;

@end
