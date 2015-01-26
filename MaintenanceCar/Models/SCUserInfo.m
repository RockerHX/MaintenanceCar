//
//  SCUserInfo.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserInfo.h"
#import "MicroCommon.h"
#import "SCAPIRequest.h"
#import "UMessage.h"

#define kLoginKey               @"kLoginKey"
#define kUserIDKey              @"kUserIDKey"
#define kPhoneNumberKey         @"kPhoneNumberKey"
#define kUserCarsKey            @"kUserCarsKey"
#define kAddAliasKey            @"kAddAliasKey"
#define kReceiveMessageKey      @"kReceiveMessageKey"

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

- (BOOL)receiveMessage
{
    BOOL receive = [[USER_DEFAULT objectForKey:kReceiveMessageKey] boolValue];
    return receive;
}

- (void)setReceiveMessage:(BOOL)receiveMessage
{
    [self canReceiveMessage:receiveMessage];
    [USER_DEFAULT setObject:@(receiveMessage) forKey:kReceiveMessageKey];
    [USER_DEFAULT synchronize];
}

- (NSArray *)selectedItems
{
    return _selectedItems;
}

- (NSArray *)cars
{
    return self.loginStatus ? _userCars : nil;
}

- (void)canReceiveMessage:(BOOL)can
{
    if (can)
    {
        [UMessage addAlias:[USER_DEFAULT objectForKey:kPhoneNumberKey] type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
            if ([responseObject[@"success"] isEqualToString:@"ok"])
                self.addAliasSuccess = YES;
        }];
    }
    else
    {
        [UMessage removeAlias:[USER_DEFAULT objectForKey:kPhoneNumberKey] type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
            if ([responseObject[@"success"] isEqualToString:@"ok"])
                self.addAliasSuccess = NO;
        }];
    }
}

#pragma mark - Public Methods
- (void)loginSuccessWithUserID:(NSDictionary *)userData
{
    [USER_DEFAULT setObject:@(YES) forKey:kLoginKey];
    [USER_DEFAULT setObject:userData[@"user_id"] forKey:kUserIDKey];
    [USER_DEFAULT setObject:userData[@"phone"] forKey:kPhoneNumberKey];
    [USER_DEFAULT synchronize];
    
    self.receiveMessage = YES;
}

- (void)logout
{
    [_userCars removeAllObjects];
    
    self.receiveMessage = NO;
    [USER_DEFAULT setObject:@(NO) forKey:kLoginKey];
    [USER_DEFAULT removeObjectForKey:kUserIDKey];
    [USER_DEFAULT removeObjectForKey:kPhoneNumberKey];
    [USER_DEFAULT synchronize];
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
        [self load];
        
        if (_block)
            _block(YES);
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
            _block(NO);
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
    else
    {
        _firstCar = nil;
        _currentCar = nil;
    }
}

- (void)refresh
{
    _currentCar = _firstCar;
}

- (void)addMaintenanceItem:(NSString *)item
{
    [_selectedItems addObject:item];
}

- (void)removeItem:(NSString *)item
{
    for (NSString *name in _selectedItems)
    {
        if ([name isEqualToString:item])
        {
            [_selectedItems removeObject:name];
            break;
        }
    }
}

- (void)removeItems
{
    [_selectedItems removeAllObjects];
}

@end
