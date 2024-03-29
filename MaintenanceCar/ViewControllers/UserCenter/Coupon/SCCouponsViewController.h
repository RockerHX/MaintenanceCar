//
//  SCCouponsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@protocol SCCouponsViewControllerDelegate <NSObject>

@optional
- (void)shouldShowMenu;
- (void)shouldSupportPanGesture:(BOOL)support;
- (void)userAddCouponSuccess;

@end

@interface SCCouponsViewController : UIViewController

@property (weak, nonatomic) IBOutlet      UIView *headerView;
@property (weak, nonatomic) IBOutlet      UIView *enterCodeBGView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet    UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id  <SCCouponsViewControllerDelegate>delegate;
@property (nonatomic, assign) BOOL payEnter;

- (IBAction)menuButtonPressed;
- (IBAction)exchangeButtonPressed;
- (IBAction)ruleButtonPressed;
- (IBAction)showInvalidCoupons;

+ (UINavigationController *)navigationInstance;
+ (instancetype)instance;

@end
