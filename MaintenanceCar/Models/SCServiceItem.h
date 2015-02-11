//
//  SCServiceItem.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCServiceItem : JSONModel

@property (nonatomic, copy) NSString <Optional>*service_id;     // 服务项目ID
@property (nonatomic, copy) NSString <Optional>*service_name;   // 服务项目名字
@property (nonatomic, copy) NSString <Optional>*memo;           // 可选字段

- (id)initWithServiceID:(NSString *)serviceID serviceName:(NSString *)serviceName;

@end
