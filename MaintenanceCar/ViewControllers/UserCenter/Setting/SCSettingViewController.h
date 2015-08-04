//
//  SCSettingViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@protocol SCSettingViewControllerDelegate <NSObject>

@optional
- (void)shouldShowMenu;
- (void)shouldSupportPanGesture:(BOOL)support;

@end

@interface SCSettingViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *appMessageSwitch;        // 消息开关
@property (weak, nonatomic) IBOutlet UIView   *logoutView;              // 注销View
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;            // 注销Button

@property (nonatomic, weak) id  <SCSettingViewControllerDelegate>delegate;

- (IBAction)menuButtonPressed;
- (IBAction)logoutButtonPressed;

+ (UINavigationController *)navigationInstance;

@end
