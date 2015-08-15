//
//  SCOrderDetail.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderBase.h"

@interface SCOrderDetailProgress : NSObject

@property (nonatomic, copy)   NSString *date;      // 进度时间
@property (nonatomic, copy)   NSString *name;      // 进度名称
@property (nonatomic, assign) NSInteger flag;

@end


@class SCCoupon;

@interface SCOrderDetail : SCOrderBase

@property (nonatomic, copy)   NSString *orderDate;         // 订单时间
@property (nonatomic, copy)   NSString *arriveDate;        // 到达时间
@property (nonatomic, copy)   NSString *reserveUser;       // 预约名称
@property (nonatomic, copy)   NSString *reservePhone;      // 预约电话
@property (nonatomic, copy)   NSString *price;             // 预估价格
@property (nonatomic, copy)   NSString *pricePrompt;       // 估价提示
@property (nonatomic, strong) SCCoupon *coupon;            // 团购券
@property (nonatomic, copy)   NSString *remark;            // 备注
@property (nonatomic, copy)   NSString *payPrice;          // 支付价格
@property (nonatomic, assign)     BOOL  canCancel;         // 是否取消
@property (nonatomic, assign)     BOOL  canPay;            // 能否买单
@property (nonatomic, assign)     BOOL  isPay;             // 是否支付

@property (nonatomic, strong) NSArray *processes;          // 订单进度数据

@end
