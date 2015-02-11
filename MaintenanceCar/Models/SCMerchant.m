//
//  SCMerchant.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchant.h"
#import "SCLocationManager.h"
#import "SCServiceItem.h"
#import "SCAllDictionary.h"

@implementation SCMerchant

#pragma mark - Init Methods
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        if (_flags)
            _merchantFlags = [_flags componentsSeparatedByString:@","];
        [self generateServiceItemsWtihMerchantImtes:_service_items inspectFree:[_inspect_free boolValue]];
    }
    return self;
}

#pragma mark - Public Methods
- (id)initWithMerchantName:(NSString *)merchantName
                 companyID:(NSString *)companyID
{
    self = [super init];
    if (self)
    {
        // 通过自定义方法初始化方法
        _name       = merchantName;
        _company_id = companyID;
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (NSString *)distance
{
    // 本地处理位置距离
    return [[SCLocationManager share] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

#pragma mark - Private Methods
- (void)generateServiceItemsWtihMerchantImtes:(NSDictionary *)merchantItems inspectFree:(BOOL)free;
{
    // 先分别取出服务项目
    NSArray *washItmes        = merchantItems[@"1"];
    NSArray *maintenanceItmes = merchantItems[@"2"];
    NSArray *repairItems      = merchantItems[@"3"];
    
    // 生成一个空的可变数组，根据服务项目的有无动态添加数据
    NSMutableArray *items = [@[] mutableCopy];
    if (washItmes.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"1" serviceName:@"洗车美容"]];
    if (maintenanceItmes.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"2" serviceName:@"保养"]];
    if (repairItems.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"3" serviceName:@"维修"]];
    
    SCAllDictionary *allDictionary = [SCAllDictionary share];
    // 最后动态添加服务器获取到的第四个按钮数据
    if (allDictionary.special && free)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"5" serviceName:allDictionary.special.text]];
    _serviceItems = items;
}

@end
