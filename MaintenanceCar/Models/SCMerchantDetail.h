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

@property (nonatomic, copy) NSString <Optional>*address;              // 商户地址
@property (nonatomic, copy) NSString <Optional>*code;                 // 许可证号
@property (nonatomic, copy) NSString <Optional>*company_id;           // 商户ID
@property (nonatomic, copy) NSString <Optional>*contacts;             // 联系人
@property (nonatomic, copy) NSString <Optional>*contacts_mobile;      // 联系人电话
@property (nonatomic, copy) NSString <Optional>*create_time;          // 商户创建时间
@property (nonatomic, copy) NSString <Optional>*email;                // 联系邮箱
@property (nonatomic, copy) NSString <Optional>*latitude;             // 商户地理位置 - 纬度
@property (nonatomic, copy) NSString <Optional>*longtitude;           // 商户地理位置 - 经度
@property (nonatomic, copy) NSString <Optional>*memo;                 // 商户备注
@property (nonatomic, copy) NSString <Optional>*name;                 // 商户名称
@property (nonatomic, copy) NSString <Optional>*region1;              // 省
@property (nonatomic, copy) NSString <Optional>*region2;              // 市
@property (nonatomic, copy) NSString <Optional>*region3;              // 区
@property (nonatomic, copy) NSString <Optional>*region4;              // 街道
@property (nonatomic, copy) NSString <Optional>*region5;              //
@property (nonatomic, copy) NSString <Optional>*service;              // 服务内容
@property (nonatomic, copy) NSString <Optional>*short_name;           // 简称
@property (nonatomic, copy) NSString <Optional>*status;               // 营业状态：1营业，2注销
@property (nonatomic, copy) NSString <Optional>*telephone;            // 联系电话
@property (nonatomic, copy) NSString <Optional>*update_time;          // 商户信息更新时间
@property (nonatomic, copy) NSString <Optional>*xkdate;               // 许可使时期
@property (nonatomic, copy) NSString <Optional>*zige;                 //

@property (nonatomic, strong) NSDictionary <Optional>*service_items;  // 服务项目
@property (nonatomic, assign) BOOL                   collected;       // 收藏状态

@property (nonatomic, copy, readonly) NSString <Ignore>*distance;     // 手机当前位置与商户的距离

@end
