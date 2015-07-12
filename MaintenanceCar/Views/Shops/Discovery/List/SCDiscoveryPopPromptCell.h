//
//  SCDiscoveryPopPromptCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@interface SCDiscoveryPopPromptCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet            UILabel *promptLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *centerXConstraint;
@property (weak, nonatomic) IBOutlet        UIImageView *arrowIcon;

- (void)displayCellWithPrompt:(NSString *)prompt openUp:(BOOL)openUp canPop:(BOOL)canPop;

@end
