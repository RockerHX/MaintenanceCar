//
//  SCUserInfo.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserInfo.h"
#import "MicroCommon.h"
#import "SCUerCar.h"
#import "SCAPIRequest.h"
#import "UMessage.h"

#define kLoginKey               @"kLoginKey"
#define kUserIDKey              @"kUserIDKey"
#define kPhoneNumberKey         @"kPhoneNumberKey"
#define kUserCarsKey            @"kUserCarsKey"
#define kAddAliasKey            @"kAddAliasKey"

typedef void(^BLOCK)(BOOL finish);

static SCUserInfo *userInfo = nil;

@interface SCUserInfo ()
{
    NSMutableArray *_userCars;
    NSMutableArray *_selectedItems;
    
    BLOCK          _block;
}

@end

@implementation SCUserInfo

#pragma mark - Init Methods
- (id)init
{
    self = [super init];
    if (self) {
        _userCars      = [@[] mutableCopy];
        _selectedItems = [@[] mutableCopy];
        [self addObserver:self forKeyPath:@"carsLoadFinish" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[SCUserInfo alloc] init];
        [userInfo load];
    });
    return userInfo;
}

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"carsLoadFinish"])
    {
        BOOL loadFinish = [change[NSKeyValueChangeNewKey] boolValue];
        if (loadFinish && _block)
            _block(loadFinish);
    }
}

#pragma mark - Getter Methods
- (NSString *)userID
{
    return self.loginStatus ? [USER_DEFAULT objectForKey:kUserIDKey] : @"";
}

- (NSString *)phoneNmber
{
    return self.loginStatus ? [USER_DEFAULT objectForKey:kPhoneNumberKey] : nil;
}

- (SCLoginStatus)loginStatus
{
    return ([[USER_DEFAULT objectForKey:kLoginKey] boolValue] && [USER_DEFAULT objectForKey:kUserIDKey]) ? SCLoginStatusLogin : SCLoginStatusLogout;
}

- (BOOL)addAliasSuccess
{
    BOOL success = [[USER_DEFAULT objectForKey:kAddAliasKey] boolValue];
    return success;
}

- (void)setAddAliasSuccess:(BOOL)addAliasSuccess
{
    [USER_DEFAULT setObject:@(addAliasSuccess) forKey:kAddAliasKey];
    [USER_DEFAULT synchronize];
}

- (NSArray *)selectedItems
{
    return _selectedItems;
}

#pragma mark - Public Methods
+ (void)loginSuccessWithUserID:(NSDictionary *)userData
{
    [USER_DEFAULT setObject:@(YES) forKey:kLoginKey];
    [USER_DEFAULT setObject:userData[@"user_id"] forKey:kUserIDKey];
    [USER_DEFAULT setObject:userData[@"phone"] forKey:kPhoneNumberKey];
    [USER_DEFAULT synchronize];
}

+ (void)logout
{
    [UMessage removeAlias:[USER_DEFAULT objectForKey:kPhoneNumberKey] type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
        if ([responseObject[@"success"] isEqualToString:@"ok"])
            [SCUserInfo share].addAliasSuccess = NO;
    }];
    [USER_DEFAULT setObject:@(NO) forKey:kLoginKey];
    [USER_DEFAULT removeObjectForKey:kUserIDKey];
    [USER_DEFAULT removeObjectForKey:kPhoneNumberKey];
    [USER_DEFAULT synchronize];
}

- (void)addCar:(SCUerCar *)car
{
    for (SCUerCar *userCar in _userCars)
    {
        if ([userCar.user_car_id isEqualToString:car.user_car_id])
        {
            userCar.user_car_id        = car.user_car_id;
            userCar.car_id             = car.car_id;
            userCar.model_id           = car.model_id;
            userCar.plate              = car.plate;
            userCar.buy_car_year       = car.buy_car_year;
            userCar.buy_car_month      = car.buy_car_month;
            userCar.run_distance       = car.run_distance;
            userCar.run_distance_stamp = car.run_distance_stamp;
            userCar.memo               = car.memo;
        }
        else
            [_userCars addObject:car];
    }
}

- (void)saveUserCarsWithData:(NSArray *)userCars
{
    @try {
        [USER_DEFAULT setObject:userCars forKey:kUserCarsKey];
        [USER_DEFAULT synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"Save User Cars Error:%@", exception.reason);
    }
    @finally {
        _carsLoadFinish = YES;
        [self setValue:@(YES) forKey:@"carsLoadFinish"];
        [self load];
    }
}

- (void)userCarsReuqest:(void (^)(BOOL))block
{
    _block = block;
    __weak typeof(self) weakSelf = self;
    if (self.loginStatus)
    {
        NSDictionary *parameters = @{@"user_id": self.userID};
        [[SCAPIRequest manager] startGetUserCarsAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                [weakSelf saveUserCarsWithData:responseObject];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}

- (void)load
{
    NSArray *userCars = [USER_DEFAULT objectForKey:kUserCarsKey];
    if (self.loginStatus && userCars.count)
    {
        [_userCars removeAllObjects];
        for (NSDictionary *carData in userCars)
        {
            SCUerCar *userCar = [[SCUerCar alloc] initWithDictionary:carData error:nil];
            [_userCars addObject:userCar];
        }
        _firstCar = _userCars[Zero];
    }
    _cars = _userCars;
}

- (void)refresh
{
    _currentCar = _firstCar;
}

- (void)addMaintenanceItem:(NSString *)item
{
    [_selectedItems addObject:item];
}

- (void)removeItemAtIndex:(NSInteger)index
{
    [_selectedItems removeObjectAtIndex:index];
}

- (void)removeItems
{
    [_selectedItems removeAllObjects];
}

@end
