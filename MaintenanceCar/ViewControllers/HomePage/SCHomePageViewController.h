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

@protocol SCHomePageViewControllerDelegate <NSObject>

@optional
- (void)shouldShowMenu;

@end


@class SCHomePageDetailView;

@interface SCHomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCHomePageDetailView *detailView;          // 首页详情View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationBarHeight;    // 运营位高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showShopsBarHeight;    // 查看商家栏高度约束

@property (nonatomic, weak) id  <SCHomePageViewControllerDelegate>delegate;

- (IBAction)menuButtonPressed;

+ (UINavigationController *)navigationInstance;
+ (instancetype)instance;

@end
