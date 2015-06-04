//
//  SCReservation.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"
#import "SCComment.h"

typedef NS_ENUM(NSInteger, SCOrderType) {
    SCOrderTypeNormal,
    SCOrderTypeUnAppraisal,
    SCOrderTypeUnAppraisalCheck,
    SCOrderTypeAppraised,
    SCOrderTypeAppraisedCheck
};

typedef NS_ENUM(NSInteger, SCOrderStatus) {
    SCOrderStatusMerchantConfirming,
    SCOrderStatusServationSuccess,
    SCOrderStatusMerchantUnAccepted,
    SCOrderStatusInProgress,
    SCOrderStatusServationCancel,
    SCOrderStatusCompleted,
    SCOrderStatusExpired
};

// 预约数据Model
@interface SCReservation : JSONModel

@property (nonatomic, strong)  NSString <Optional>*reserve_id;            // 预约ID
@property (nonatomic, strong)  NSString <Optional>*user_id;               // 用户ID
@property (nonatomic, strong)  NSString <Optional>*company_id;            // 商家ID
@property (nonatomic, strong)  NSString <Optional>*user_car_id;           // 预约车辆ID
@property (nonatomic, strong)  NSString <Optional>*order_id;              // 订单ID
@property (nonatomic, strong)  NSString <Optional>*type;                  // 预约类型
@property (nonatomic, strong)  NSString <Optional>*reserve_name;          // 预约人名字
@property (nonatomic, strong)  NSString <Optional>*reserve_phone;         // 预约手机号
@property (nonatomic, strong)  NSString <Optional>*create_time;           // 预约创建时间
@property (nonatomic, strong)  NSString <Optional>*reserve_time;          // 预约时间
@property (nonatomic, strong)  NSString <Optional>*content;               // 预约备注
@property (nonatomic, strong)  NSString <Optional>*status;                // 预约状态：
@property (nonatomic, strong)  NSString <Optional>*name;                  // 商家名字
@property (nonatomic, strong)  NSString <Optional>*company_name;          // 商家名字
@property (nonatomic, strong)  NSString <Optional>*car_model_name;        // 用户预约车辆名称
@property (nonatomic, strong)  NSString <Optional>*update_time;           // 用户预约更新时间
@property (nonatomic, strong) SCComment <Optional>*comment;               // 评价详情

@property (nonatomic, assign, readonly) SCOrderStatus  orderStatus;
@property (nonatomic, strong, readonly)      NSString *getCarDays;

- (BOOL)canUnReservation;
- (BOOL)canShowResult;
- (BOOL)isAppraised;
- (SCOrderType)orderType;

@end
