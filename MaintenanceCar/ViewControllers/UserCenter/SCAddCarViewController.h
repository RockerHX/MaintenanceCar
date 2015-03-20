//
//  SCAddCarViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@class SCCarBrandView;
@class SCCarModelView;

@interface SCAddCarViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCCarBrandView *carBrandView;      // 车辆品牌View
@property (weak, nonatomic) IBOutlet SCCarModelView *carModelView;      // 车辆车型View

// [添加车辆]按钮触发事件
- (IBAction)addCarButtonPressed:(UIBarButtonItem *)sender;
// [取消添加]按钮触发事件
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

@end
