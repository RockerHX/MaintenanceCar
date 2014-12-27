//
//  SCMerchantDetail.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 商户详情Model
@interface SCMerchantDetail : JSONModel

@property (nonatomic, copy) NSString *address;              // 商户地址
@property (nonatomic, copy) NSString *checked;              //
@property (nonatomic, copy) NSString *code;                 // 许可证号
@property (nonatomic, copy) NSString *company_id;           // 商户ID
@property (nonatomic, copy) NSString *contacts;             // 联系人
@property (nonatomic, copy) NSString *contacts_mobile;      // 联系人电话
@property (nonatomic, copy) NSString *coop;                 //
@property (nonatomic, copy) NSString *create_time;          // 商户创建时间
@property (nonatomic, copy) NSString *email;                // 联系邮箱
@property (nonatomic, copy) NSString *index_name;           //
@property (nonatomic, copy) NSString *latitude;             // 商户地理位置 - 纬度
@property (nonatomic, copy) NSString *longtitude;           // 商户地理位置 - 经度
@property (nonatomic, copy) NSString *memo;                 // 商户备注
@property (nonatomic, copy) NSString *name;                 // 商户名称
@property (nonatomic, copy) NSString *reg_id;               //
@property (nonatomic, copy) NSString *region1;              // 省
@property (nonatomic, copy) NSString *region2;              // 市
@property (nonatomic, copy) NSString *region3;              // 区
@property (nonatomic, copy) NSString *region4;              // 街道
@property (nonatomic, copy) NSString *region5;              //
@property (nonatomic, copy) NSString *service;              // 服务内容
@property (nonatomic, copy) NSString *short_name;           // 简称
@property (nonatomic, copy) NSString *status;               // 营业状态：1营业，2注销
@property (nonatomic, copy) NSString *telephone;            // 联系电话
@property (nonatomic, copy) NSString *update_time;          // 商户信息更新时间
@property (nonatomic, copy) NSString *xkdate;               // 许可使时期
@property (nonatomic, copy) NSString *zige;                 //

@end
