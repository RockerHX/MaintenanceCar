//
//  SCServiceItem.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCServiceItem.h"

@implementation SCServiceItem

#pragma mark - Setter And Getter Methods
- (void)setMemo:(NSString<Optional> *)memo
{
    if (memo)
        _memo = [NSString stringWithFormat:@"(%@)", memo];
    else
        _memo = @"";
}

#pragma mark - Public Methods
- (id)initWithServiceID:(NSString *)serviceID serviceName:(NSString *)serviceName
{
    self = [super init];
    if (self) {
        _service_id   = serviceID;
        _service_name = serviceName;
    }
    return self;
}

@end
