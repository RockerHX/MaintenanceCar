//
//  SCGroupProductDetailCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGroupProductDetail;

@interface SCGroupProductDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)displayCellWithDetail:(SCGroupProductDetail *)detail;

@end
