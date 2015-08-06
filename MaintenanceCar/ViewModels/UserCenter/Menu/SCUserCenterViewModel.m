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
#import "MicroConstants.h"

static const NSInteger ItemSections = 2;

static NSString *const Prompt = @"请登录";
static NSString *const AddCarPrompt = @"添加爱车";

static NSString *const UserCenterItemsFileName = @"UserCenterData";
static NSString *const UserCenterItemsFileType = @"plist";

static NSString *const PlaceHolderHeaderImageName = @"UC-HeaderIcon";
static NSString *const AddCarIconImageName = @"UC-AddCarIcon";

static NSString *const AddCarIconKey = @"Icon";
static NSString *const AddCarIconValue = @"Title";

static NSString *const kUserCarSelectedKey = @"kUserCarSelectedKey";


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
    _itemSections = ItemSections;
    _placeHolderHeader = PlaceHolderHeaderImageName;
    
    _userCarItems = @[[self addcarItem]];
    [self reloadCars];
    
    NSMutableArray *items = @[].mutableCopy;
    NSArray *userCenterItems = [self loadUserCenterItems];
    for (NSDictionary *dic in userCenterItems) {
        SCUserCenterMenuItem *item = [[SCUserCenterMenuItem alloc] initWithDictionary:dic localData:YES];
        [items addObject:item];
    }
    _selectedItems = [NSArray arrayWithArray:items];
}

#pragma mark - Setter And Getter
- (NSString *)selectedUserCarID {
    NSString *carID = [USER_DEFAULT objectForKey:kUserCarSelectedKey];
    SCUserCenterMenuItem *firstItem = (_userCarItems.count > 1) ? [_userCarItems firstObject] : nil;
    return carID ?: firstItem.userCar.userCarID;
}

- (NSString *)prompt {
    SCUserInfo *userInfo = [SCUserInfo share];
    return userInfo.loginState ? userInfo.phoneNmber : Prompt;
}

#pragma mark - Public Methods
- (void)reloadCars {
    __weak __typeof(self)weakSelf = self;
    [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
        NSArray *cars = userInfo.cars;
        NSMutableArray *items = @[].mutableCopy;
        for (SCUserCar *car in cars) {
            SCUserCenterMenuItem *item = [[SCUserCenterMenuItem alloc] initWithCar:car];
            [items addObject:item];
        }
        [items addObject:[weakSelf addcarItem]];
        _userCarItems = [NSArray arrayWithArray:items];
        weakSelf.needRefresh = YES;
    }];
}

- (void)recordUserCarSelected:(NSInteger)index {
    NSString *userCarID = ((SCUserCenterMenuItem *)_userCarItems[index]).userCar.userCarID;
    [USER_DEFAULT setValue:userCarID forKey:kUserCarSelectedKey];
}

#pragma mark - Private Methods
- (NSArray *)loadUserCenterItems {
    return [NSArray arrayWithContentsOfFile:[NSFileManager pathForResource:UserCenterItemsFileName ofType:UserCenterItemsFileType]];
}

- (SCUserCenterMenuItem *)addcarItem {
    SCUserCenterMenuItem *item = [[SCUserCenterMenuItem alloc] initWithDictionary:@{AddCarIconKey: AddCarIconImageName, AddCarIconValue: AddCarPrompt}
                                                                        localData:YES];
    item.last = YES;
    return item;
}

@end
