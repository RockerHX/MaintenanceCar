//
//  SCHomePageDetailView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHomePageDetailView : UIView

@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;                // 车辆名称

- (IBAction)preCarButtonPressed:(UIButton *)sender;
- (IBAction)nextButtonPressed:(UIButton *)sender;

@end
