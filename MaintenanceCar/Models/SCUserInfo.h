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

@class SCUerCar;

// 用户数据Model
@interface SCUserInfo : NSObject

@property (nonatomic, copy, readonly)   NSString      *userID;          // 用户ID
@property (nonatomic, copy, readonly)   NSString      *phoneNmber;      // 用户手机号
@property (nonatomic, copy, readonly)   NSArray       *cars;            // 用户私家车集合
@property (nonatomic, assign, readonly) SCLoginStatus loginStatus;      // 登陆状态

@property (nonatomic, strong, readonly) SCUerCar      *firstCar;        // 第一辆车
@property (nonatomic, strong)           SCUerCar      *currentCar;      // 当前车辆

@property (nonatomic, assign, readonly) BOOL          carsLoadFinish;   // 车辆加载结束标识
@property (nonatomic, assign)           BOOL          addAliasSuccess;  // 推送Alias添加成功

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
- (void)addCar:(SCUerCar *)car;

/**
 *  缓存用户车辆数据，直接本地覆盖
 *
 *  @param userCars 用户车辆数据
 */
- (void)saveUserCarsWithData:(NSArray *)userCars;

- (void)userCarsReuqest:(void(^)(BOOL finish))block;

- (void)load;
- (void)refresh;

@end
