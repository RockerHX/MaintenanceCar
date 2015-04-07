//
//  SCChangeMaintenanceDataViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCUserCar;
@class SCCarDriveHabitsView;

@protocol SCChangeMaintenanceDataViewControllerDelegate <NSObject>

@optional
- (void)dataSaveSuccess;

@end

@interface SCChangeMaintenanceDataViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel              *userCarLabel;            // 车辆名字栏
@property (weak, nonatomic) IBOutlet UITextField          *mileageTextField;        // 里程输入栏
@property (weak, nonatomic) IBOutlet UILabel              *buyCarDateLabel;         // 购买时间栏
@property (weak, nonatomic) IBOutlet SCCarDriveHabitsView *carDriveHabitsView;      // 驾驶习惯View

@property (nonatomic, weak)          id                   <SCChangeMaintenanceDataViewControllerDelegate>delegate;
@property (nonatomic, weak)          SCUserCar            *car;

- (IBAction)deleteCarButtonPressed;

// 车辆登记日期按钮触发事件
- (IBAction)buyCarDateButtonPressed;

@end
