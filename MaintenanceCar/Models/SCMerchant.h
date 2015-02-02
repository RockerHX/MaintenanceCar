//
//  SCMerchant.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 商户数据Model
@interface SCMerchant : JSONModel

@property (nonatomic, copy)           NSString <Optional>*name;                 // 商户名称
@property (nonatomic, copy)           NSString <Optional>*company_id;           // 商户ID
@property (nonatomic, copy)           NSString <Optional>*region3;              // 区
@property (nonatomic, copy)           NSString <Optional>*latitude;             // 商户地理位置 - 纬度
@property (nonatomic, copy)           NSString <Optional>*longtitude;           // 商户地理位置 - 经度
@property (nonatomic, copy)           NSString <Optional>*star;                 // 商户星级数
@property (nonatomic, copy)           NSString <Optional>*tags;                 // 商户特色
@property (nonatomic, copy)           NSString <Optional>*flags;                // 商户标签

@property (nonatomic, copy)             NSString <Ignore>*openTime;             // 商户标签
@property (nonatomic, copy)             NSString <Ignore>*closeTime;            // 商户标签
@property (nonatomic, copy, readonly)   NSString <Ignore>*distance;             // 手机当前位置与商户的距离
@property (nonatomic, strong, readonly) NSArray  <Ignore>*merchantFlags;        // 商户标签集合

/**
 *  自定义初始化方法(不通过JSON数据自动解析)
 *
 *  @param merchantName 商户名称
 *  @param companyID    商户ID
 *
 *  @return 商户Model实例
 */
- (id)initWithMerchantName:(NSString *)merchantName
                 companyID:(NSString *)companyID
                  openTime:(NSString *)openTime
                 closeTime:(NSString *)closeTime;

@end
