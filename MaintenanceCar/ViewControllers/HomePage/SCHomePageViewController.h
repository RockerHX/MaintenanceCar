//
//  SCHomePageViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"


typedef NS_ENUM(NSUInteger, SCHomePageServiceButtonType) {
    SCHomePageServiceButtonTypeMaintenance,
    SCHomePageServiceButtonTypeWash,
    SCHomePageServiceButtonTypeRepair,
    SCHomePageServiceButtonTypeShowShops
};

@protocol SCHomePageViewControllerDelegate <NSObject>

@optional
- (void)shouldShowMenu;

@end


@class SCLoopScrollView;

@interface SCHomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet   SCLoopScrollView *operationView;         // 首页运营位
@property (weak, nonatomic) IBOutlet           UIButton *maintenanceButton;     // 保养服务按钮
@property (weak, nonatomic) IBOutlet           UIButton *washButton;            // 洗车服务按钮
@property (weak, nonatomic) IBOutlet           UIButton *repairButton;          // 修车服务按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationBarHeight;    // 运营位高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showShopsBarHeight;    // 查看商家栏高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerButtonWidth;     // 中间服务按钮宽度约束

@property (nonatomic, weak)     id  <SCHomePageViewControllerDelegate>delegate;
@property (nonatomic, assign) BOOL  shouldShowNaivgationBar;                    // 跳转下级视图控制器时是否显示导航栏

- (IBAction)menuButtonPressed;
- (IBAction)searchButtonPressed;
- (IBAction)serviceButtonPressed:(UIButton *)button;

+ (UINavigationController *)navigationInstance;
+ (instancetype)instance;

@end
