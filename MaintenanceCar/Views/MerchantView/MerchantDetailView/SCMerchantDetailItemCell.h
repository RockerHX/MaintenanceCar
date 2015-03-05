//
//  SCMerchantDetailItemCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchantDetail;

@interface SCMerchantDetailItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet     UILabel *nameLabel;

- (void)displayCellWithIndex:(NSIndexPath *)indexPath detail:(SCMerchantDetail *)detail;

@end
