//
//  SCMerchantDetailFlagCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMerchantDetailFlagCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic, weak)          UIColor *color;

@end
