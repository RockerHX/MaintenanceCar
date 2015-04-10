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
        [[SCAllDictionary share] generateServiceItemsWtihMerchantImtes:_service_items inspectFree:[_inspect_free boolValue]];
        
        _serverItemsPrompt = [self generateServicePrompt:_service_items];
        _merchantImages    = [self handleMerchantImages];
        _serviceItems      = [self handleServiceItmes];
        
        if (!_time_open)
            _time_open = @"";
        if (!_time_closed)
            _time_closed = @"";
        
        [self handleProducts:_products];
        
        _summary       = [[SCMerchantSummary alloc] initWithMerchantDetail:self];
        if (_products.count)
            _group     = [[SCMerchantGroup alloc] initWithMerchantDetail:self];
        _info          = [[SCMerchantInfo alloc] initWithMerchantDetail:self];
        _commentMore = [[SCCommentMore alloc] initWithMerchantDetail:self];
        _commentGroup  = [[SCCommentGroup alloc] initWithMerchantDetail:self];
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (NSArray<Ignore> *)cellDisplayData
{
    NSMutableArray *data = [@[] mutableCopy];
    if (_summary)
        [data addObject:_summary];
    if (_group)
        [data addObject:_group];
    if (_info)
        [data addObject:_info];
    if (_commentMore)
        [data addObject:_commentMore];
    if (_commentGroup)
        [data addObject:_commentGroup];
    
    return data;
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

- (NSArray *)handleMerchantImages
{
    NSMutableArray *images = [NSMutableArray arrayWithArray:_images];
    if (images.count)
    {
        for (NSDictionary *pic in images)
        {
            if (pic[@"pic_type"])
            {
                [images removeObject:pic];
                [images insertObject:pic atIndex:0];
                break;
            }
        }
    }
    else
        [images addObject:[@{} mutableCopy]];
    
    return images;
}

- (NSDictionary *)handleServiceItmes
{
    NSMutableDictionary *serviceItems = [@{} mutableCopy];
    NSDictionary *washItem        = _service_items[@"1"];
    NSDictionary *maintenanceItem = _service_items[@"2"];
    NSDictionary *repairItem      = _service_items[@"3"];
    
    if (washItem.count)
        [serviceItems setObject:washItem forKey:@"1"];
    if (maintenanceItem.count)
        [serviceItems setObject:maintenanceItem forKey:@"2"];
    if (repairItem.count)
        [serviceItems setObject:repairItem forKey:@"3"];
    if (_inspect_free)
        [serviceItems setObject:@[@"免费检测"] forKey:@"4"];
    
    return serviceItems;
}

- (void)handleProducts:(NSArray *)products
{
    [products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SCGroupProduct *product = obj;
        product.companyID       = _company_id;
        product.merchantName    = _name;
        product.now             = _now;
    }];
}

#pragma mark - Setter And Getter Methods
- (NSString *)distance
{
    // 本地处理位置距离
    return [[SCLocationManager share] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
