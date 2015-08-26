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

#pragma Class Methods

+ (instancetype)objectWithKeyValues:(id)keyValues {
    SCMerchantDetail *detail = [super objectWithKeyValues:keyValues];
    [detail initConfig];
    return detail;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"companyID": @"company_id",
              @"timeOpen": @"time_open",
            @"timeClosed": @"time_closed",
           @"haveComment": @"have_comment",
         @"commentsCount": @"comments_num",
          @"serviceItems": @"service_items",
        @"normalProducts": @"normal_products"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"products": @"SCGroupProduct",
       @"normalProducts": @"SCQuotedPrice",
             @"comments": @"SCComment"};
}

#pragma mark - Init Methods
- (void)initConfig {
    [self generateServiceItemsWtihMerchantImtes:_serviceItems];
    _serverItemsPrompt  = [self generateServicePrompt:_serviceItems];
    _merchantImages     = [self handleMerchantImages];
    _diplayDerviceItems = [self handleServiceItmes];
    
    if (!_timeOpen) {
        _timeOpen = @"";
    }
    if (!_timeClosed) {
        _timeClosed = @"";
    }
    
    [self handleProducts:_products];
    
    _summary = [[SCMerchantSummary alloc] initWithMerchantDetail:self];
    if (_products.count) {
        _productGroup = [[SCMerchantProductGroup alloc] initWithMerchantDetail:self];
    }
    if (_normalProducts.count) {
        _quotedPriceGroup = [[SCQuotedPriceGroup alloc] initWithMerchantDetail:self];
    }
    _info = [[SCMerchantInfo alloc] initWithMerchantDetail:self];
    _commentMore = [[SCCommentMore alloc] initWithMerchantDetail:self];
    _commentGroup = [[SCCommentGroup alloc] initWithMerchantDetail:self];
}

#pragma mark - Setter And Getter Methods
- (NSArray<Ignore> *)cellDisplayData {
    NSMutableArray *data = [@[] mutableCopy];
    if (_summary) {
        [data addObject:_summary];
    }
    if (_productGroup) {
        [data addObject:_productGroup];
    }
    if (_quotedPriceGroup) {
        [data addObject:_quotedPriceGroup];
    }
    if (_info) {
        [data addObject:_info];
    }
    if (_commentMore) {
        [data addObject:_commentMore];
    }
    if (_commentGroup) {
        [data addObject:_commentGroup];
    }
    return data;
}

#pragma mark - Private Methods
- (void)generateServiceItemsWtihMerchantImtes:(NSDictionary *)merchantItems {
    // 先分别取出服务项目
    NSArray *washItmes        = merchantItems[@"1"];
    NSArray *maintenanceItmes = merchantItems[@"2"];
    NSArray *repairItems      = merchantItems[@"3"];
    
    // 生成一个空的可变数组，根据服务项目的有无动态添加数据
    NSMutableArray *items = [@[] mutableCopy];
    if (washItmes.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"1"]];
    if (maintenanceItmes.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"2"]];
    if (repairItems.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"3"]];
    
    _reservationItems = [NSArray arrayWithArray:items];
}

- (NSString *)generateServicePrompt:(NSDictionary *)items {
    // 先分别取出服务项目
    NSArray *washItmes        = items[@"1"];
    NSArray *maintenanceItmes = items[@"2"];
    NSArray *repairItems      = items[@"3"];
    
    NSString *prompt  = @"";
    if (washItmes.count) {
        __block NSString *string = @"洗车:";
        [washItmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            string = [string stringByAppendingString:idx ? [NSString stringWithFormat:@"，%@", obj] : obj];
        }];
        
        if (maintenanceItmes.count || repairItems.count) {
            prompt = [prompt stringByAppendingFormat:@"%@\n", string];
        } else {
            prompt = [prompt stringByAppendingFormat:@"%@", string];
        }
    }
    
    if (maintenanceItmes.count) {
        __block NSString *string = @"养车:";
        [maintenanceItmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            string = [string stringByAppendingString:idx ? [NSString stringWithFormat:@"，%@", obj] : obj];
        }];
        
        if (repairItems.count) {
            prompt = [prompt stringByAppendingFormat:@"%@\n", string];
        } else {
            prompt = [prompt stringByAppendingFormat:@"%@", string];
        }
    }
    
    if (repairItems.count) {
        __block NSString *string = @"修车:";
        [repairItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            string = [string stringByAppendingString:idx ? [NSString stringWithFormat:@"，%@", obj] : obj];
        }];
        prompt = [prompt stringByAppendingFormat:@"%@", string];
    }
    return prompt;
}

- (NSArray *)handleMerchantImages {
    NSMutableArray *images = [NSMutableArray arrayWithArray:_images];
    if (images.count) {
        for (NSDictionary *pic in images) {
            if (pic[@"pic_type"]) {
                [images removeObject:pic];
                [images insertObject:pic atIndex:0];
                break;
            }
        }
    } else {
        [images addObject:[@{} mutableCopy]];
    }
    return images;
}

- (NSDictionary *)handleServiceItmes {
    NSMutableDictionary *serviceItems = [@{} mutableCopy];
    NSDictionary *washItem        = _serviceItems[@"1"];
    NSDictionary *maintenanceItem = _serviceItems[@"2"];
    NSDictionary *repairItem      = _serviceItems[@"3"];
    
    if (washItem.count) {
        [serviceItems setObject:washItem forKey:@"1"];
    }
    if (maintenanceItem.count) {
        [serviceItems setObject:maintenanceItem forKey:@"2"];
    }
    if (repairItem.count) {
        [serviceItems setObject:repairItem forKey:@"3"];
    }
    
    return serviceItems;
}

- (void)handleProducts:(NSArray *)products {
    [products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SCGroupProduct *product = obj;
        product.company_id = _companyID;
        product.name       = _name;
        product.now        = _now;
    }];
}

#pragma mark - Setter And Getter Methods
- (NSString *)distance {
    // 本地处理位置距离
    return [[SCLocationManager share] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
