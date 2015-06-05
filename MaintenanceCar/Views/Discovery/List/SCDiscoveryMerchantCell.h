//
//  SCDiscoveryMerchantCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"
#import "SCMerchant.h"

@interface SCDiscoveryMerchantCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *hotIcon;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailIcon;
@property (weak, nonatomic) IBOutlet     UILabel *mechantNameLabel;
@property (weak, nonatomic) IBOutlet     UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet     UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *repairTypeIcon;
@property (weak, nonatomic) IBOutlet     UILabel *repairPromptLabel;
@property (weak, nonatomic) IBOutlet UITableView *servicesView;

@end
