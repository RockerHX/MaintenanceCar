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

// 用户数据Model
@interface SCUserInfo : NSObject

@property (nonatomic, copy, readonly)   NSString      *userID;          // 用户ID
@property (nonatomic, copy, readonly)   NSString      *phoneNmber;      // 用户手机号
@property (nonatomic, copy, readonly)   NSArray       *userCarIDs;      // 用户私家车的ID集合
@property (nonatomic, assign, readonly) SCLoginStatus loginStatus;      // 登陆状态

/**
 *  单例方法
 *
 *  @return 用户信息[SCUserInfo]实例
 */
+ (instancetype)share;

/**
 *  登陆成功，设置userID，phoneNmber
 *
 *  @param userData 服务返回的用户数据
 */
+ (void)loginSuccessWithUserID:(NSDictionary *)userData;

/**
 *  用户注销
 */
+ (void)logout;

/**
 *  添加私家车
 */
- (void)updateCarIDs:(NSArray *)carIDs;

@end
