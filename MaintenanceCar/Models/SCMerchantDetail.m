//
//  SCMerchantDetail.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetail.h"
#import "SCLocationInfo.h"
#import "SCAllDictionary.h"

@implementation SCMerchantDetail

#pragma mark - Setter And Getter Methods
- (NSString *)distance
{
    // 本地处理位置距离
    return [[SCLocationInfo shareLocationInfo] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

- (void)setService_items:(NSDictionary<Optional> *)service_items
{
    _service_items = service_items;
    [[SCAllDictionary share] generateServiceItemsWtihMerchantImtes:service_items];
}

@end
