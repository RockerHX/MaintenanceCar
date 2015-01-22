//
//  SCMileageView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMileageView : UIView

@property (weak, nonatomic) IBOutlet UILabel *bitsLabel;                // 个位栏
@property (weak, nonatomic) IBOutlet UILabel *tenLabel;                 // 十位栏
@property (weak, nonatomic) IBOutlet UILabel *hundredLabel;             // 百位栏
@property (weak, nonatomic) IBOutlet UILabel *thousandLabel;            // 千位栏
@property (weak, nonatomic) IBOutlet UILabel *tenThousandLabel;         // 万位栏
@property (weak, nonatomic) IBOutlet UILabel *hundredThousandLabel;     // 十万位栏

@property (nonatomic, copy) NSString *mileage;                          // 里程数据

@end
