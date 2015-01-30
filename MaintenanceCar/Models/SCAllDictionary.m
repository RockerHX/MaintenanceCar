//
//  SCAllDictionary.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAllDictionary.h"
#import "MicroCommon.h"
#import "SCAPIRequest.h"

#define kColorsKey              @"kColorsKey"
#define kAllDictionarykey       @"kAllDictionarykey"

static SCAllDictionary *allDictionary = nil;

@interface SCAllDictionary ()
{
    NSArray *_oderTypeItems;
    NSArray *_reservationTypeItems;
    NSArray *_questionTypeItems;
    NSArray *_reservationStatusItems;
    NSArray *_oderStatusItems;
    NSArray *_driveHabitItems;
    
    SCDictionaryType _type;
}

@end

@implementation SCAllDictionary

#pragma mark - Init Methods
+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allDictionary = [[SCAllDictionary alloc] init];
    });
    return allDictionary;
}

#pragma mark - Setter And Getter
- (NSArray *)oderTypeItems
{
    return _oderTypeItems;
}

- (NSArray *)reservationTypeItems
{
    return _reservationTypeItems;
}

- (NSArray *)questionTypeItems
{
    return _questionTypeItems;
}

- (NSArray *)reservationStatusItems
{
    return _reservationStatusItems;
}

- (NSArray *)oderStatusItems
{
    return _oderStatusItems;
}

- (NSArray *)driveHabitItems
{
    return _driveHabitItems;
}

#pragma mark - Public Methods
- (void)requestWithType:(SCDictionaryType)type finfish:(void(^)(NSArray *items))finfish
{
    _type = type;                                                           // 混存外部需要的字典类型
    NSDictionary *localData = [self readLocalDataWithKey:kAllDictionarykey];      // 获取本地字典数据
    
    // 如果本地缓存的字典数据为空，从网络请求，并保存到本地，反之则生成字典数据对象做回调
    if (!localData)
    {
        [[SCAPIRequest manager] startGetAllDictionaryAPIRequestWithParameters:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                [self saveData:responseObject withKey:kAllDictionarykey];
                NSArray *data = responseObject[[@(type) stringValue]];
                [self handleDateWithData:data finfish:finfish];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleDateWithData:nil finfish:finfish];
        }];
    }
    else
    {
        NSArray *data = localData[[@(type) stringValue]];
        [self handleDateWithData:data finfish:finfish];
    }
}

- (void)replaceSpecialDataWith:(SCSpecial *)spcial
{
    _special = spcial;
}

- (void)generateServiceItemsWtihMerchantImtes:(NSDictionary *)merchantItems;
{
    NSArray *washItmes        = merchantItems[@"1"];
    NSArray *maintenanceItmes = merchantItems[@"2"];
    NSArray *repairItems      = merchantItems[@"3"];
    
    NSMutableArray *items = [@[] mutableCopy];
    if (washItmes.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"1" serviceName:@"洗车美容"]];
    if (maintenanceItmes.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"2" serviceName:@"保养"]];
    if (repairItems.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"3" serviceName:@"维修"]];
    
    [items addObject:[[SCServiceItem alloc] initWithServiceID:@"5" serviceName:[SCAllDictionary share].special.text]];
    _serviceItems = items;
}

- (void)requestColors:(void(^)(NSDictionary *colors))finfish
{
    NSDictionary *localData = [self readLocalDataWithKey:kColorsKey];      // 获取颜色值本地缓存数据
    if (!localData)
    {
        [[SCAPIRequest manager] startFlagsColorAPIRequestWithParameters:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _colors = responseObject;
            [self saveData:responseObject withKey:kColorsKey];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            finfish(nil);
        }];
    }
    else
    {
        _colors = localData;
        finfish(localData);
    }
}

#pragma mark - Private Methods
/**
 *  保存字典数据到本地
 *
 *  @param dic 字典数据
 */
- (void)saveData:(id)data withKey:(NSString *)key
{
    [USER_DEFAULT setObject:data forKey:key];
    [USER_DEFAULT synchronize];
}

/**
 *  从本地读取字典数据
 *
 *  @return 字典数据
 */
- (id)readLocalDataWithKey:(NSString *)key
{
    id data = [USER_DEFAULT objectForKey:key];
    return data;
}

/**
 *  获取字典数据对象
 *
 *  @param data 字典数据
 *
 *  @return 字典数据对象集合
 */
- (NSArray *)getItemsWithData:(NSArray *)data
{
    if (data)
    {
        NSMutableArray *items = [@[] mutableCopy];
        for (NSDictionary *dic in data)
        {
            SCDictionaryItem *item = [[SCDictionaryItem alloc] initWithDictionary:dic error:nil];
            [items addObject:item];
        }
        return items;
    }
    return data;
}

/**
 *  处理对应的字典数据
 *
 *  @param data    字典数据集合
 *  @param finfish 数据处理后的回调block - items参数为对应请求字典类型的数据对象集合
 */
- (void)handleDateWithData:(NSArray *)data finfish:(void(^)(NSArray *data))finfish
{
    switch (_type)
    {
        case SCDictionaryTypeOderType:
        {
            _oderTypeItems = [self getItemsWithData:data];
            finfish(_oderTypeItems);
        }
            break;
        case SCDictionaryTypeReservationType:
        {
            _reservationTypeItems = [self getItemsWithData:data];
            finfish(_reservationTypeItems);
        }
            break;
        case SCDictionaryTypeQuestionType:
        {
            _questionTypeItems = [self getItemsWithData:data];
            finfish(_questionTypeItems);
        }
            break;
        case SCDictionaryTypeReservationStatus:
        {
            _reservationStatusItems = [self getItemsWithData:data];
            finfish(_reservationStatusItems);
        }
            break;
        case SCDictionaryTypeOderStatus:
        {
            _oderStatusItems = [self getItemsWithData:data];
            finfish(_oderStatusItems);
        }
            break;
            
        case SCDictionaryTypeDriveHabit:
        {
            _driveHabitItems = [self getItemsWithData:data];
            finfish(_driveHabitItems);
        }
            break;
    }
}

@end
