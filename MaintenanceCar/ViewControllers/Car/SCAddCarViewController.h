//
//  SCAddCarViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import "SCCar.h"

@class SCCarBrandView;
@class SCCarModelView;

@protocol SCAddCarViewControllerDelegate <NSObject>

@optional
/**
 *  用户添加车辆成功
 *
 *  @param userCarID 用户ID
 */
- (void)addCarSuccess:(SCCar *)car;

@end

@interface SCAddCarViewController : UIViewController

@property (nonatomic, weak)          id             <SCAddCarViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet SCCarBrandView *carBrandView;      // 车辆品牌View
@property (weak, nonatomic) IBOutlet SCCarModelView *carModelView;      // 车辆车型View

// [添加车辆]按钮触发事件
- (IBAction)addCarButtonPressed:(UIBarButtonItem *)sender;
// [取消添加]按钮触发事件
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

+ (UINavigationController *)navigationInstance;
+ (instancetype)instance;

@end
