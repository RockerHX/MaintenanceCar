//
//  SCCarBrandCollectionViewCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCarBrandCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carIcon;          // 车辆品牌logo
@property (weak, nonatomic) IBOutlet UILabel     *carTitleLabel;    // 车辆标题显示栏

@end
