//
//  SCUserCenterCell.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCUserCenterMenuItem;

@interface SCUserCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet     UILabel *titleLabel;

- (void)displayCellWithItem:(SCUserCenterMenuItem *)item;

@end
