//
//  SCUserInfo.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserInfo.h"
#import "MicroCommon.h"

#define kLoginKey               @"kLoginKey"
#define kUserIDKey              @"kUserIDKey"
#define kPhoneNumberKey         @"kPhoneNumberKey"

static SCUserInfo *userInfo = nil;

@interface SCUserInfo ()
{
    NSArray *_carIDs;
}

@end

@implementation SCUserInfo

#pragma mark - Init Methods
+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[SCUserInfo alloc] init];
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

- (NSArray *)userCarIDs
{
    return _carIDs;
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
    [USER_DEFAULT setObject:@(NO) forKey:kLoginKey];
    [USER_DEFAULT removeObjectForKey:kUserIDKey];
    [USER_DEFAULT removeObjectForKey:kPhoneNumberKey];
    [USER_DEFAULT synchronize];
}

- (void)updateCarIDs:(NSArray *)carIDs
{
    _carIDs = carIDs;
}

@end
