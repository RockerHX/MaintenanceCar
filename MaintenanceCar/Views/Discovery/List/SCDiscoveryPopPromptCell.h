//
//  SCDiscoveryPopPromptCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@interface SCDiscoveryPopPromptCell : SCTableViewCell
{
    CALayer *_topLeftShadowLayer;
    CALayer *_topRightShadowLayer;
}

@property (weak, nonatomic) IBOutlet     UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

@end
