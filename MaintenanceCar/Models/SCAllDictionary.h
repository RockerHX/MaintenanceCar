//
//  SCAllDictionary.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCDictionaryItem.h"
#import "SCServiceItem.h"
#import "SCSpecial.h"

typedef NS_ENUM(NSInteger, SCDictionaryType) {
    SCDictionaryTypeOderType = 1,                       // 订单类型
    SCDictionaryTypeReservationType,                    // 预约类型
    SCDictionaryTypeQuestionType,                       // 问题类型
    SCDictionaryTypeReservationStatus,                  // 预约状态
    SCDictionaryTypeOderStatus,                         // 订单状态
    SCDictionaryTypeDriveHabit,                         // 驾驶习惯
};

@interface SCAllDictionary : NSObject

@property (nonatomic, strong, readonly) NSArray   *oderTypeItems;             // 订单类型字典
@property (nonatomic, strong, readonly) NSArray   *reservationTypeItems;      // 预约类型字典
@property (nonatomic, strong, readonly) NSArray   *questionTypeItems;         // 问题类型字典
@property (nonatomic, strong, readonly) NSArray   *reservationStatusItems;    // 预约状态字典
@property (nonatomic, strong, readonly) NSArray   *oderStatusItems;           // 订单状态字典
@property (nonatomic, strong, readonly) NSArray   *driveHabitItems;           // 驾驶习惯字典

@property (nonatomic, strong, readonly) NSArray   *serviceItems;              // 服务项目

@property (nonatomic, strong, readonly) SCSpecial *special;                   // 自定义数据

/**
 *  SCAllDictionary单例方法
 *
 *  @return SCAllDictionary实例对象
 */
+ (instancetype)share;

/**
 *  字典数据请求方法
 *
 *  @param type    请求的字典类型
 *  @param finfish 数据处理后的回调block - items参数为对应请求字典类型的数据对象集合
 */
- (void)requestWithType:(SCDictionaryType)type finfish:(void(^)(NSArray *items))finfish;

- (void)replaceSpecialDataWith:(SCSpecial *)spcial;

- (void)generateServiceItemsWtihMerchantImtes:(NSDictionary *)merchantItems;

@end
