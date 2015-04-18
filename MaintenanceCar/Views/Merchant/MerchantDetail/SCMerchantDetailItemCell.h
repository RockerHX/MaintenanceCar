//
//  SCMerchantDetailItemCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchantInfoItem;

@interface SCMerchantDetailItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet     UILabel *contentLabel;

- (void)displayCellWithItem:(SCMerchantInfoItem *)infoItem;

@end
