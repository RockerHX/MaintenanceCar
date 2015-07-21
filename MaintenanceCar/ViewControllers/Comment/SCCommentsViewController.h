//
//  SCCommentsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/16.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCListViewController.h"

@interface SCCommentsViewController : SCListViewController

@property (nonatomic, strong) NSString *companyID;

+ (instancetype)instance;

@end
