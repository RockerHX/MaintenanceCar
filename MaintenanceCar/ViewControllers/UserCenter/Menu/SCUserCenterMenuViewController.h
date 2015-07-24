//
//  SCUserCenterMenuViewController.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCUserCenterMenuRow) {
    SCUserCenterMenuRowHomePage,
    SCUserCenterMenuRowOrder,
    SCUserCenterMenuRowGroupBuy,
    SCUserCenterMenuRowCollection,
    SCUserCenterMenuRowCoupon,
    SCUserCenterMenuRowSetting
};

@protocol SCUserCenterMenuViewControllerDelegate <NSObject>

@optional
- (void)shouldShowViewControllerOnRow:(SCUserCenterMenuRow)row;

@end

@class SCUserView;
@interface SCUserCenterMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet          id  <SCUserCenterMenuViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet  SCUserView *userView;
@property (weak, nonatomic) IBOutlet UITableView *userCarView;
@property (weak, nonatomic) IBOutlet UITableView *userCenterView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCarHeightConstraint;

+ (instancetype)instance;

@end
