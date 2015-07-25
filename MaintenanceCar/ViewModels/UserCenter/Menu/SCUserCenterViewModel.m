//
//  SCUserCenterViewModel.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterViewModel.h"
#import "SCFileManager.h"
#import "SCUserInfo.h"

static NSString *prompt = @"请登录";

@implementation SCUserCenterViewModel

#pragma mark - Init Methods
+ (instancetype)instance {
    SCUserCenterViewModel *model = [[SCUserCenterViewModel alloc] init];
    return model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

#pragma mark - Config Methods
- (void)initConfig {
    _placeHolderHeader = @"UC-HeaderIcon";
    __weak __typeof(self)weakSelf = self;
    [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
        NSArray *cars = userInfo.cars;
        NSMutableArray *items = @[].mutableCopy;
        for (SCUserCar *car in cars) {
            SCUserCenterMenuItem *item = [[SCUserCenterMenuItem alloc] initWithCar:car];
            [items addObject:item];
        }
        _userCarItems = [weakSelf appendAddCarItem:items];
        weakSelf.needRefresh = YES;
    }];
    
    NSMutableArray *items = @[].mutableCopy;
    NSArray *userCenterItems = [self loadUserCenterItems];
    for (NSDictionary *dic in userCenterItems) {
        SCUserCenterMenuItem *item = [[SCUserCenterMenuItem alloc] initWithDictionary:dic localData:YES];
        [items addObject:item];
    }
    _userCenterItems = [NSArray arrayWithArray:items];
}

#pragma mark - Setter And Getter
- (NSString *)prompt {
    SCUserInfo *userInfo = [SCUserInfo share];
    return userInfo.loginState ? userInfo.phoneNmber : prompt;
}

#pragma mark - Private Methods
- (NSArray *)loadUserCenterItems {
    return [NSArray arrayWithContentsOfFile:[NSFileManager pathForResource:@"UserCenterData" ofType:@"plist"]];
}

- (NSArray *)appendAddCarItem:(NSMutableArray *)items {
    SCUserCenterMenuItem *item = [[SCUserCenterMenuItem alloc] initWithDictionary:@{@"Icon": @"UC-AddCarIcon", @"Title": @"点击添加车辆"}
                                                                        localData:YES];
    item.last = YES;
    [items addObject:item];
    return [NSArray arrayWithArray:items];
}

@end
