//
//  SCServerResponse.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCServerResponse.h"

@implementation SCServerResponse

- (instancetype)initWithResponseObject:(id)responseObject
{
    self = [super init];
    if (self)
    {
        _statusCode = [responseObject[@"status_code"] integerValue];
        _prompt = responseObject[@"status_message"];
    }
    return self;
}

@end
