//
//  SCMileageView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMileageView : UIView

@property (weak, nonatomic) IBOutlet UILabel *bitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenLabel;
@property (weak, nonatomic) IBOutlet UILabel *hundredLabel;
@property (weak, nonatomic) IBOutlet UILabel *thousandLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenThousandLabel;
@property (weak, nonatomic) IBOutlet UILabel *hundredThousandLabel;

@property (nonatomic, copy) NSString *mileage;

@end
