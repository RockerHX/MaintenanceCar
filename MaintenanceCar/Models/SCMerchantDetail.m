//
//  SCMerchantDetail.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetail.h"
#import "SCLocationManager.h"
#import "SCAllDictionary.h"

@implementation SCMerchantDetail

#pragma mark - Init Methods
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        if (_flags)
            _merchantFlags = [_flags componentsSeparatedByString:@","];
        [[SCAllDictionary share] generateServiceItemsWtihMerchantImtes:_service_items inspectFree:[_inspect_free boolValue]];
        
        if (!_time_open)
            _time_open = @"";
        if (!_time_closed)
            _time_closed = @"";
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (NSString *)distance
{
    // 本地处理位置距离
    return [[SCLocationManager share] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
