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
        
        _serverItemsPrompt = [self generateServicePrompt:_service_items];
        
        if (!_time_open)
            _time_open = @"";
        if (!_time_closed)
            _time_closed = @"";
    }
    return self;
}
#pragma mark - Private Methods
- (NSString *)generateServicePrompt:(NSDictionary *)items
{
    // 先分别取出服务项目
    NSArray *washItmes        = items[@"1"];
    NSArray *maintenanceItmes = items[@"2"];
    NSArray *repairItems      = items[@"3"];
    
    NSString *prompt  = @"";
    if (washItmes.count)
    {
        __block NSString *string = @"洗车:";
        [washItmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            string = [string stringByAppendingString:idx ? [NSString stringWithFormat:@"，%@", obj] : obj];
        }];
        
        if (maintenanceItmes.count || repairItems.count)
            prompt = [prompt stringByAppendingFormat:@"%@\n", string];
        else
            prompt = [prompt stringByAppendingFormat:@"%@", string];
    }
    
    if (maintenanceItmes.count)
    {
        __block NSString *string = @"养车:";
        [maintenanceItmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            string = [string stringByAppendingString:idx ? [NSString stringWithFormat:@"，%@", obj] : obj];
        }];
        
        if (repairItems.count)
            prompt = [prompt stringByAppendingFormat:@"%@\n", string];
        else
            prompt = [prompt stringByAppendingFormat:@"%@", string];
    }
    
    if (repairItems.count)
    {
        __block NSString *string = @"修车:";
        [repairItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            string = [string stringByAppendingString:idx ? [NSString stringWithFormat:@"，%@", obj] : obj];
        }];
        prompt = [prompt stringByAppendingFormat:@"%@", string];
    }
    return prompt;
}

#pragma mark - Setter And Getter Methods
- (NSString *)distance
{
    // 本地处理位置距离
    return [[SCLocationManager share] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
