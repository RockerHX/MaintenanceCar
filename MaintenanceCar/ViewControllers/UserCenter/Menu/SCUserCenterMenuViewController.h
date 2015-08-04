//
//  SCUserCenterMenuViewController.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import <REFrostedViewController/REFrostedViewController.h>
#import "SCUserView.h"

typedef NS_ENUM(NSUInteger, SCUserCenterMenuRow) {
    SCUserCenterMenuRowHomePage,
    SCUserCenterMenuRowOrder,
    SCUserCenterMenuRowCollection,
    SCUserCenterMenuRowGroupTicket,
    SCUserCenterMenuRowCoupon,
    SCUserCenterMenuRowSetting
};

@protocol SCUserCenterMenuViewControllerDelegate <NSObject>

@optional
- (void)willShowAddCarSence;
- (void)shouldShowViewControllerOnRow:(SCUserCenterMenuRow)row;

@end

@class SCUserView;

@interface SCUserCenterMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, REFrostedViewControllerDelegate, SCUserViewDelegate>

@property (weak, nonatomic) IBOutlet          id  <SCUserCenterMenuViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet  SCUserView *userView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

+ (instancetype)instance;

@end
