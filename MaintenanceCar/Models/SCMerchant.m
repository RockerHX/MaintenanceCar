//
//  SCMerchant.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchant.h"
#import "MicroCommon.h"

@interface SCMerchant ()
{
    double _serverDistance;     // 根据自己位置从服务器请求回来到商户的距离
}

@end

@implementation SCMerchant

#pragma mark - Private Methods
#pragma mark -
/**
 *  得到用于APP上显示的实际距离（实际距离小于1000米时显示单位为米M，精确度为10米；大于1000米是显示单位为千米KM）
 *
 *  @param serverDistance 从服务器上请求得到的距离
 *
 *  @return 用于APP显示的距离
 */
- (NSString *)displayDistanceWithServerDistance:(double)serverDistance
{
    NSString *displayDistance = @"";
    if (serverDistance < 1.0f)
    {
        NSInteger distance = [[NSString stringWithFormat:@"%.2f", serverDistance] doubleValue] * 1000;
        displayDistance = [NSString stringWithFormat:@"%ldm", (long)distance];
    }
    else
    {
        displayDistance = [NSString stringWithFormat:@"%.1fkm", serverDistance];
    }
    return displayDistance;
}

#pragma mark - Getter Methods
#pragma mark -
- (NSString *)distance
{
    @try {
        _serverDistance = [_sortExprValues[0] doubleValue];
        SCLog(@"%@", _sortExprValues[0]);
    }
    @catch (NSException *exception) {
        _serverDistance = 0.0f;
        SCException(@"SCMerchant object get serverDistance exception reason:%@", exception.reason);
    }
    @finally {
        SCLog(@"%f", _serverDistance);
    }
    return [self displayDistanceWithServerDistance:_serverDistance];
}

- (SCMerchantDetail *)detail
{
    return _fields;
}

@end
