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
@property (nonatomic, copy) NSString <Optional>*company_id;           // 商户ID
@property (nonatomic, copy) NSString <Optional>*latitude;             // 商户地理位置 - 纬度
@property (nonatomic, copy) NSString <Optional>*longtitude;           // 商户地理位置 - 经度
@property (nonatomic, copy) NSString <Optional>*memo;                 // 商户备注
@property (nonatomic, copy) NSString <Optional>*name;                 // 商户名称
@property (nonatomic, copy) NSString <Optional>*service;              // 服务内容
@property (nonatomic, copy) NSString <Optional>*short_name;           // 简称
@property (nonatomic, copy) NSString <Optional>*telephone;            // 联系电话
@property (nonatomic, copy) NSString <Optional>*flags;                // 商户标签
@property (nonatomic, copy) NSString <Optional>*tags;                 // 商户特色
@property (nonatomic, copy) NSString <Optional>*inspect_free;         // 能否免费检测
@property (nonatomic, copy) NSString <Optional>*time_open;            // 商户营业时间
@property (nonatomic, copy) NSString <Optional>*time_closed;          // 商户打样时间
@property (nonatomic, copy) NSString <Optional>*majors;               // 专修品牌

@property (nonatomic, strong) NSDictionary <Optional>*service_items;  // 服务项目
@property (nonatomic, assign) BOOL                   collected;       // 收藏状态

@property (nonatomic, copy, readonly)   NSString <Ignore>*distance;             // 手机当前位置与商户的距离
@property (nonatomic, copy, readonly)   NSString <Ignore>*serverItemsPrompt;    // 商户服务描述
@property (nonatomic, strong, readonly)  NSArray <Ignore>*merchantFlags;        // 商户标签集合


@end
