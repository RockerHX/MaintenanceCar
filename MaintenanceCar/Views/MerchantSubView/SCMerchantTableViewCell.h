//
//  SCMerchantTableViewCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMerchantTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *merchantIcon;
@property (weak, nonatomic) IBOutlet UILabel     *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *distanceLabel;

@end
