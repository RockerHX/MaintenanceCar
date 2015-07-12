//
//  SCDiscoveryMerchantCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"
#import "SCMerchant.h"

@class SCStarView;
@class SCShopViewModel;

@interface SCDiscoveryMerchantCell : SCTableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *canPayIcon;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailIcon;
@property (weak, nonatomic) IBOutlet     UILabel *mechantNameLabel;
@property (weak, nonatomic) IBOutlet  SCStarView *starView;
@property (weak, nonatomic) IBOutlet     UILabel *starValueLabel;
@property (weak, nonatomic) IBOutlet     UILabel *characteristicLabel;
@property (weak, nonatomic) IBOutlet     UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *repairTypeIcon;
@property (weak, nonatomic) IBOutlet     UILabel *repairPromptLabel;
@property (weak, nonatomic) IBOutlet UITableView *flagsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starViewToStarValueLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starValueLabelToCharacteristicLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *characteristicLabelToDistanceLabelConstraint;

- (void)displayCellWithShopViewModel:(SCShopViewModel *)shopViewModel;

@end
