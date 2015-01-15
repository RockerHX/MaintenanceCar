//
//  SCCarBrandCollectionViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrandCollectionViewCell.h"

@implementation SCCarBrandCollectionViewCell

- (void)awakeFromNib
{
    // 车辆品牌logo圆角处理
    _carIcon.layer.cornerRadius = 40.0f;
}

@end
