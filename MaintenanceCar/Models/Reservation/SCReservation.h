//
//  SCReservation.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"
#import "SCComment.h"

typedef NS_ENUM(NSInteger, SCOderType) {
    SCOderTypeNormal,
    SCOderTypeUnAppraisal,
    SCOderTypeUnAppraisalCheck,
    SCOderTypeAppraised,
    SCOderTypeAppraisedCheck
};

typedef NS_ENUM(NSInteger, SCOderStatus) {
    SCOderStatusMerchantConfirming,
    SCOderStatusServationSuccess,
    SCOderStatusMerchantUnAccepted,
    SCOderStatusInProgress,
    SCOderStatusServationCancel,
    SCOderStatusCompleted,
    SCOderStatusExpired
};

// 预约数据Model
@interface SCReservation : JSONModel

@property (nonatomic, copy)  NSString <Optional>*reserve_id;            // 预约ID
@property (nonatomic, copy)  NSString <Optional>*user_id;               // 用户ID
@property (nonatomic, copy)  NSString <Optional>*company_id;            // 商家ID
@property (nonatomic, copy)  NSString <Optional>*user_car_id;           // 预约车辆ID
@property (nonatomic, copy)  NSString <Optional>*order_id;              // 订单ID
@property (nonatomic, copy)  NSString <Optional>*type;                  // 预约类型
@property (nonatomic, copy)  NSString <Optional>*reserve_name;          // 预约人名字
@property (nonatomic, copy)  NSString <Optional>*reserve_phone;         // 预约手机号
@property (nonatomic, copy)  NSString <Optional>*create_time;           // 预约创建时间
@property (nonatomic, copy)  NSString <Optional>*reserve_time;          // 预约时间
@property (nonatomic, copy)  NSString <Optional>*content;               // 预约备注
@property (nonatomic, copy)  NSString <Optional>*status;                // 预约状态：
@property (nonatomic, copy)  NSString <Optional>*name;                  // 商家名字
@property (nonatomic, copy)  NSString <Optional>*company_name;          // 商家名字
@property (nonatomic, copy)  NSString <Optional>*car_model_name;        // 用户预约车辆名称
@property (nonatomic, copy)  NSString <Optional>*update_time;           // 用户预约更新时间
@property (nonatomic, copy) SCComment <Optional>*comment;               // 评价详情

@property (nonatomic, assign, readonly) SCOderStatus oderStatus;
@property (nonatomic, copy, readonly)      NSString *getCarDays;

- (BOOL)canUnReservation;
- (BOOL)canShowResult;
- (BOOL)isAppraised;
- (SCOderType)oderType;

@end
