//
//  SCUserInfo.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserInfo.h"
#import <UMengMessage/UMessage.h>
#import <DateTools/DateTools.h>
#import "MicroConstants.h"
#import "SCAppApiRequest.h"

static NSString *const kLoginKey = @"kLoginKey";
static NSString *const kUserIDKey = @"kUserIDKey";
static NSString *const kPhoneNumberKey = @"kPhoneNumberKey";
static NSString *const kUserTokenKey = @"kUserTokenKey";
static NSString *const kTokenRefreshDateKey = @"kTokenRefreshDateKey";
static NSString *const kOwnerNameKey = @"kOwnerNameKey";
static NSString *const kHeaderURLKey = @"kHeaderURLKey";
static NSString *const kUserCarsKey = @"kUserCarsKey";
static NSString *const kAddAliasKey = @"kAddAliasKey";
static NSString *const kReceiveMessageKey = @"kReceiveMessageKey";
static NSString *const kUserCarSelectedKey = @"kUserCarSelectedKey";

typedef void(^BLOCK)(SCUserInfo *userInfo, BOOL finish);
typedef void(^STATE_BLOCK)(SCLoginState state);

@implementation SCUserInfo {
    BLOCK       _block;
    STATE_BLOCK _stateBlock;
    
    NSMutableArray *_userCars;
    NSMutableArray *_selectedItems;
}

#pragma mark - Init Methods
- (id)init {
    self = [super init];
    if (self) {
        _userCars      = [@[] mutableCopy];
        _selectedItems = [@[] mutableCopy];
    }
    return self;
}

+ (instancetype)share {
    static SCUserInfo *userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[SCUserInfo alloc] init];
        [userInfo load];
    });
    return userInfo;
}

#pragma mark - Getter Methods
- (NSString *)userID {
    return self.loginState ? [USER_DEFAULT objectForKey:kUserIDKey] : @"";
}

- (NSString *)phoneNmber {
    return self.loginState ? [USER_DEFAULT objectForKey:kPhoneNumberKey] : @"";
}

- (NSString *)token {
    return self.loginState ? [USER_DEFAULT objectForKey:kUserTokenKey] : @"";
}

- (NSString *)ownerName {
    return self.loginState ? [USER_DEFAULT objectForKey:kOwnerNameKey] : @"";
}

- (NSString *)headURL {
    return self.loginState ? [USER_DEFAULT objectForKey:kHeaderURLKey] : @"";
}

- (SCLoginState)loginState {
    return ([[USER_DEFAULT objectForKey:kLoginKey] boolValue] && [USER_DEFAULT objectForKey:kUserIDKey] && [USER_DEFAULT objectForKey:kUserTokenKey]) ? SCLoginStateLogin : SCLoginStateLogout;
}

- (BOOL)addAliasSuccess {
    BOOL success = [[USER_DEFAULT objectForKey:kAddAliasKey] boolValue];
    return success;
}

- (void)setAddAliasSuccess:(BOOL)addAliasSuccess {
    [USER_DEFAULT setObject:@(addAliasSuccess) forKey:kAddAliasKey];
    [USER_DEFAULT synchronize];
}

- (BOOL)receiveMessage {
    BOOL receive = [[USER_DEFAULT objectForKey:kReceiveMessageKey] boolValue];
    return receive;
}

- (void)setReceiveMessage:(BOOL)receiveMessage {
    [self canReceiveMessage:receiveMessage];
    [USER_DEFAULT setObject:@(receiveMessage) forKey:kReceiveMessageKey];
    [USER_DEFAULT synchronize];
}

- (NSArray *)selectedItems {
    return _selectedItems;
}

- (NSArray *)cars {
    return self.loginState ? _userCars : nil;
}

- (NSString *)selectedUserCarID {
    NSString *carID = [USER_DEFAULT objectForKey:kUserCarSelectedKey];
    return carID ?: nil;
}

- (void)canReceiveMessage:(BOOL)can {
    if (can) {
        [UMessage addAlias:[USER_DEFAULT objectForKey:kPhoneNumberKey] type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
            if ([responseObject[@"success"] isEqualToString:@"ok"]) {
                self.addAliasSuccess = YES;
            }
        }];
    } else {
        [UMessage removeAlias:[USER_DEFAULT objectForKey:kPhoneNumberKey] type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
            if ([responseObject[@"success"] isEqualToString:@"ok"]) {
                self.addAliasSuccess = NO;
            }
        }];
    }
}

#pragma mark - Public Methods
- (void)loginSuccessWithUserData:(NSDictionary *)userData {
    [USER_DEFAULT setObject:@(YES) forKey:kLoginKey];
    [USER_DEFAULT setObject:[NSString stringWithFormat:@"%@", userData[@"user_id"]] forKey:kUserIDKey];
    [USER_DEFAULT setObject:[NSString stringWithFormat:@"%@", userData[@"phone"]] forKey:kPhoneNumberKey];
    [USER_DEFAULT setObject:[NSString stringWithFormat:@"%@", userData[@"token"]] forKey:kUserTokenKey];
    [USER_DEFAULT setObject:[NSString stringWithFormat:@"%@", userData[@"head_img_url"]] forKey:kHeaderURLKey];
    [USER_DEFAULT setObject:[NSString stringWithFormat:@"%@", userData[@"now"]] forKey:kTokenRefreshDateKey];
    [USER_DEFAULT synchronize];
    
    [self loginStateChange:SCLoginStateLogin];
}

- (void)saveOwnerName:(NSString *)name {
    [USER_DEFAULT setObject:name forKey:kOwnerNameKey];
    [USER_DEFAULT synchronize];
}

- (void)logout {
    [_userCars removeAllObjects];
    
    [USER_DEFAULT setObject:@(NO) forKey:kLoginKey];
    [USER_DEFAULT removeObjectForKey:kUserIDKey];
    [USER_DEFAULT removeObjectForKey:kPhoneNumberKey];
    [USER_DEFAULT removeObjectForKey:kUserTokenKey];
    [USER_DEFAULT removeObjectForKey:kUserCarsKey];
    [USER_DEFAULT synchronize];
    
    [self loginStateChange:SCLoginStateLogout];
}

- (BOOL)needRefreshToken {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *date = [USER_DEFAULT objectForKey:kTokenRefreshDateKey];
    NSDate *tokenDate = [formatter dateFromString:date];
    
    double hour = [tokenDate hoursEarlierThan:[NSDate date]];
    return (hour > 24);
}

- (void)refreshTokenDate {
    [USER_DEFAULT setObject:[[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:kTokenRefreshDateKey];
    [USER_DEFAULT synchronize];
}

- (void)saveUserCars:(NSArray *)userCars {
    @try {
        [USER_DEFAULT setObject:userCars forKey:kUserCarsKey];
        [USER_DEFAULT synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"Save User Cars Error:%@", exception.reason);
    }
    @finally {
        [self load];
        if (_block) _block(self, YES);
    }
}

- (void)clearUserCars:(NSArray *)userCars {
    [USER_DEFAULT removeObjectForKey:kUserCarsKey];
    [USER_DEFAULT synchronize];
    [self load];
    if (_block) _block(self, YES);
}

- (void)stateChange:(void(^)(SCLoginState state))block {
    _stateBlock = block;
}

- (void)userCarsReuqest:(void (^)(SCUserInfo *, BOOL))block {
    _block = block;
    if (self.loginState) {
        __weak typeof(self)weakSelf = self;
        NSDictionary *parameters = @{@"user_id": self.userID};
        [[SCAppApiRequest manager] startGetUserCarsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCApiRequestStatusCodeGETSuccess) {
                NSInteger statusCode = [responseObject[@"status_code"] integerValue];
                NSArray *userCars = responseObject[@"data"];
                if (statusCode == SCAppApiRequestErrorCodeNoError) {
                    [weakSelf saveUserCars:userCars];
                } else if (statusCode == SCAppApiRequestErrorCodeUserHaveNotCars) {
                    [weakSelf clearUserCars:userCars];
                } else {
                    if (_block) _block(weakSelf, NO);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (_block) _block(weakSelf, NO);
        }];
        if (_userCars.count) {
            if (_block) _block(self, YES);
        } else {
            if (_block) _block(self, NO);
        }
    } else {
        if (_block) _block(self, NO);
    }
}

- (void)load {
    NSArray *userCars = [USER_DEFAULT objectForKey:kUserCarsKey];
    if (self.loginState) {
        [_userCars removeAllObjects];
        for (NSDictionary *carData in userCars) {
            SCUserCar *userCar = [SCUserCar objectWithKeyValues:carData];
            [_userCars addObject:userCar];
        }
    }
}

- (void)addMaintenanceItem:(NSString *)item {
    [_selectedItems addObject:item];
}

- (void)removeItem:(NSString *)item {
    for (NSString *name in _selectedItems) {
        if ([name isEqualToString:item]) {
            [_selectedItems removeObject:name];
            break;
        }
    }
}

- (void)removeItems {
    [_selectedItems removeAllObjects];
}

- (void)recordSelectedUserCarID:(NSString *)userCarID {
    [USER_DEFAULT setValue:userCarID forKey:kUserCarSelectedKey];
}

#pragma mark - Private Methods
- (void)loginStateChange:(SCLoginState)state {
    self.receiveMessage = state;
    self.loginState = state;
    if (_stateBlock)
        _stateBlock(state);
}

@end
