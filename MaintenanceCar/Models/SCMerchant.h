//
//  SCMerchant.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 商户Model
@interface SCMerchant : JSONModel

@property (nonatomic, copy)           NSString <Optional>*name;                 // 商户名称
@property (nonatomic, copy)           NSString <Optional>*company_id;           // 商户ID
@property (nonatomic, copy)           NSString <Optional>*region3;              // 区
@property (nonatomic, copy)           NSString <Optional>*latitude;             // 商户地理位置 - 纬度
@property (nonatomic, copy)           NSString <Optional>*longtitude;           // 商户地理位置 - 经度

@property (nonatomic, copy, readonly) NSString <Ignore>*distance;     // 手机当前位置与商户的距离

@end
