//
//  SCUserInfo.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserCar.h"

typedef NS_ENUM(BOOL, SCLoginStatus) {
    SCLoginStatusLogin  = YES,
    SCLoginStatusLogout = NO
};

// 用户数据Model
@interface SCUserInfo : NSObject

@property (nonatomic, copy, readonly)   NSString      *userID;          // 用户ID
@property (nonatomic, copy, readonly)   NSString      *phoneNmber;      // 用户手机号
@property (nonatomic, copy, readonly)   NSString      *token;           // 用户令牌
@property (nonatomic, copy, readonly)   NSString      *serverDate;      // 服务器时间
@property (nonatomic, copy, readonly)   NSArray       *cars;            // 用户私家车集合
@property (nonatomic, assign, readonly) SCLoginStatus loginStatus;      // 登录状态

@property (nonatomic, assign)           BOOL          addAliasSuccess;  // 推送Alias添加成功
@property (nonatomic, assign)           BOOL          receiveMessage;   // 接受消息

@property (nonatomic, strong, readonly) NSArray       *selectedItems;   // 已选保养项目

/**
 *  单例方法
 *
 *  @return 用户信息[SCUserInfo]实例
 */
+ (instancetype)share;

/**
 *  登录成功，设置userID，phoneNmber
 *
 *  @param userData 服务返回的用户数据
 */
- (void)loginSuccessWithUserData:(NSDictionary *)userData;

/**
 *  用户注销
 */
- (void)logout;

- (void)userCarsReuqest:(void(^)(SCUserInfo *userInfo, BOOL finish))block;

- (void)addMaintenanceItem:(NSString *)item;
- (void)removeItem:(NSString *)item;
- (void)removeItems;

@end
