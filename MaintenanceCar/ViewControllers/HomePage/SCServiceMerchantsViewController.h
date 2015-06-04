//
//  SCServiceMerchantsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

typedef NS_ENUM(NSUInteger, SCSearchType) {
    SCSearchTypeWash,
    SCSearchTypeMaintenance,
    SCSearchTypeRepair,
    SCSearchTypeOperate
};

@class SCSearchFilterView;

@interface SCServiceMerchantsViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCSearchFilterView *searchFilterView;      // 商家列表的筛选View
@property (weak, nonatomic) IBOutlet        UITableView *tableView;             // 商家列表View

@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign)     BOOL  noBrand;

@property (nonatomic, assign) SCSearchType searchType;

// [地图]按钮触发事件
- (IBAction)mapItemPressed:(UIBarButtonItem *)sender;

+ (instancetype)instance;

@end
