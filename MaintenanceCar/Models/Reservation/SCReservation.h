//
//  SCReservation.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 预约数据Model
@interface SCReservation : JSONModel

@property (nonatomic, copy) NSString <Optional>*reserve_id;             // 预约ID
@property (nonatomic, copy) NSString <Optional>*user_id;                // 用户ID
@property (nonatomic, copy) NSString <Optional>*company_id;             // 商家ID
@property (nonatomic, copy) NSString <Optional>*user_car_id;            // 预约车辆ID
@property (nonatomic, copy) NSString <Optional>*order_id;               // 订单ID
@property (nonatomic, copy) NSString <Optional>*type;                   // 预约类型
@property (nonatomic, copy) NSString <Optional>*reserve_name;           // 预约人名字
@property (nonatomic, copy) NSString <Optional>*reserve_phone;          // 预约手机号
@property (nonatomic, copy) NSString <Optional>*reserve_time;           // 预约时间
@property (nonatomic, copy) NSString <Optional>*content;                // 预约备注
@property (nonatomic, copy) NSString <Optional>*status;                 // 预约状态：
@property (nonatomic, copy) NSString <Optional>*in_time;                //
@property (nonatomic, copy) NSString <Optional>*create_time;            // 预约创建时间
@property (nonatomic, copy) NSString <Optional>*update_time;            // 预约信息更新时间
@property (nonatomic, copy) NSString <Optional>*name;                   // 商家名字

@end
