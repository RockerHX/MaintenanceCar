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
#define kUserID                 @"kUserID"

static SCUserInfo *userInfo = nil;

@implementation SCUserInfo

#pragma mark - Init Methods
#pragma mark -
+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[SCUserInfo alloc] init];
    });
    return userInfo;
}

#pragma mark - Getter Methods
#pragma mark -
- (NSString *)userID
{
    return self.isLogin ? [USER_DEFAULT objectForKey:kUserID] : nil;
}

- (SCLoginStatus)isLogin
{
    return ([[USER_DEFAULT objectForKey:kLoginKey] boolValue] && [USER_DEFAULT objectForKey:kUserID]) ? SCLoginStatusLogin : SCLoginStatusLogout;
}

#pragma mark - Public Methods
#pragma mark -
- (void)loginSuccessWithUserID:(NSString *)userID
{
    [USER_DEFAULT setObject:@(YES) forKey:kLoginKey];
    [USER_DEFAULT setObject:userID forKey:kUserID];
    [USER_DEFAULT synchronize];
}

- (void)logout
{
    [USER_DEFAULT setObject:@(NO) forKey:kLoginKey];
    [USER_DEFAULT removeObjectForKey:kUserID];
    [USER_DEFAULT synchronize];
}

@end
