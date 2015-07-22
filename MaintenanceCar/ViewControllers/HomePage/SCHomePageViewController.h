//
//  SCHomePageViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

typedef NS_ENUM(NSUInteger, SCHomePageServiceButtonType) {
    SCHomePageServiceButtonTypeRepair,
    SCHomePageServiceButtonTypeMaintance,
    SCHomePageServiceButtonTypeWash,
    SCHomePageServiceButtonTypeOperation
};

@class SCHomePageDetailView;

@interface SCHomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet   NSLayoutConstraint *buttonWidthConstraint;   // 按钮宽约束
@property (weak, nonatomic) IBOutlet SCHomePageDetailView *detailView;              // 首页详情View
@property (weak, nonatomic) IBOutlet             UIButton *specialButton;           // 首页第四个按钮
@property (weak, nonatomic) IBOutlet              UILabel *specialLabel;            // 首页第四个文字栏

- (IBAction)locationItemPressed;
- (IBAction)serviceButtonPressed:(UIButton *)button;
- (IBAction)showMenu;

+ (instancetype)instance;
+ (NSString *)navgationRestorationIdentifier;

@end
