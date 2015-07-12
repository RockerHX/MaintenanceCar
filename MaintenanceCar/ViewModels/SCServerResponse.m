//
//  SCServerResponse.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCServerResponse.h"

@implementation SCServerResponse

#pragma mark - Init Methods
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _statusCode = -1;
    }
    return self;
}

#pragma mark - Public Methods
- (void)parseResponseObject:(id)responseObject
{
    _statusCode = [responseObject[@"status_code"] integerValue];
    _prompt = responseObject[@"status_message"];
}

@end
