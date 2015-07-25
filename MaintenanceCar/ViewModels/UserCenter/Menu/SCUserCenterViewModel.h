//
//  SCUserCenterViewModel.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterMenuItem.h"

@interface SCUserCenterViewModel : NSObject

+ (instancetype)instance;

@property (nonatomic, assign)              BOOL  needRefresh;
@property (nonatomic, strong, readonly)   NSURL *headerURL;
@property (nonatomic, copy, readonly)  NSString *placeHolderHeader;
@property (nonatomic, copy, readonly)  NSString *prompt;
@property (nonatomic, strong, readonly) NSArray *userCarItems;
@property (nonatomic, strong, readonly) NSArray *userCenterItems;

@end
