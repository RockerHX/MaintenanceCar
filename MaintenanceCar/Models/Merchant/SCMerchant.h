//
//  SCMerchant.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 商家数据Model
@interface SCMerchant : JSONModel

@property (nonatomic, strong)       NSString <Optional>*name;                 // 商家名称
@property (nonatomic, strong)       NSString <Optional>*company_id;           // 商家ID
@property (nonatomic, strong)       NSString <Optional>*latitude;             // 商家地理位置 - 纬度
@property (nonatomic, strong)       NSString <Optional>*longtitude;            // 商家地理位置 - 经度
@property (nonatomic, strong)       NSString <Optional>*star;                 // 商家星级数
@property (nonatomic, strong)       NSString <Optional>*tags;                 // 商家特色
@property (nonatomic, strong)       NSString <Optional>*flags;                // 商家标签
@property (nonatomic, strong)       NSString <Optional>*inspect_free;         // 能否免费检测

@property (nonatomic, strong) NSDictionary <Optional>*service_items;        // 服务项目

@property (nonatomic, strong, readonly) NSString <Ignore>*distance;         // 手机当前位置与商家的距离
@property (nonatomic, strong, readonly)  NSArray <Ignore>*serviceItems;     // 服务项目
@property (nonatomic, strong, readonly)  NSArray <Ignore>*merchantFlags;    // 商家标签集合

/**
 *  自定义初始化方法(不通过JSON数据自动解析)
 *
 *  @param merchantName 商家名称
 *  @param companyID    商家ID
 *
 *  @return 商家Model实例
 */
- (id)initWithMerchantName:(NSString *)merchantName
                 companyID:(NSString *)companyID;

@end
