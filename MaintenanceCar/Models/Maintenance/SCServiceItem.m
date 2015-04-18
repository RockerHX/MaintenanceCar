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
- (instancetype)initWithServiceID:(NSString *)serviceID
{
    NSString *serviceName;
    switch ([serviceID integerValue])
    {
        case 1:
            serviceName = @"洗车美容";
            break;
        case 2:
            serviceName = @"保养";
            break;
        case 3:
            serviceName = @"维修";
            break;
        case 4:
            serviceName = @"团购";
            break;
        case 5:
            serviceName = @"免费检测";
            break;
    }
    return [self initWithServiceID:serviceID serviceName:serviceName];
}

- (instancetype)initWithServiceID:(NSString *)serviceID serviceName:(NSString *)serviceName
{
    self = [super init];
    if (self) {
        _service_id   = serviceID;
        _service_name = serviceName;
    }
    return self;
}

@end
