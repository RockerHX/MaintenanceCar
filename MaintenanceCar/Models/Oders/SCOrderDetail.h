//
//  SCOrderDetail.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderBase.h"

@protocol SCOrderDetailProgress
@end

@interface SCOrderDetailProgress : JSONModel

@property (nonatomic, strong) NSString *date;      // 进度时间
@property (nonatomic, strong) NSString *name;      // 进度名称
@property (nonatomic, assign) NSInteger flag;

@end

@interface SCOrderDetail : SCOrderBase

@property (nonatomic, strong) NSString *orderDate;         // 订单时间
@property (nonatomic, strong) NSString *arriveDate;        // 到达时间
@property (nonatomic, strong) NSString *reserveUser;       // 预约名称
@property (nonatomic, strong) NSString *reservePhone;      // 预约电话
@property (nonatomic, strong) NSString *price;             // 预估价格
@property (nonatomic, strong) NSString *remark;            // 备注
@property (nonatomic, assign)     BOOL  canCancel;         // 是否取消

@property (nonatomic, strong) NSArray <SCOrderDetailProgress>*processes;

@end
