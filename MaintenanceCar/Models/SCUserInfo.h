//
//  SCUserInfo.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(BOOL, SCLoginStatus) {
    SCLoginStatusLogin  = YES,
    SCLoginStatusLogout = NO
};

@interface SCUserInfo : NSObject

@property (nonatomic, copy, readonly)   NSString      *userID;          // 用户ID
@property (nonatomic, assign, readonly) SCLoginStatus loginStatus;      // 登陆状态

/**
 *  单例方法
 *
 *  @return 用户信息[SCUserInfo]实例
 */
+ (instancetype)share;

/**
 *  登陆成功，设置userID
 *
 *  @param userID 用户ID[userID]
 */
- (void)loginSuccessWithUserID:(NSString *)userID;

/**
 *  用户注销
 */
- (void)logout;

@end
