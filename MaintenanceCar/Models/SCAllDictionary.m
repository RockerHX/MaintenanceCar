//
//  SCAllDictionary.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAllDictionary.h"
#import "MicroCommon.h"
#import "SCDictionaryItem.h"
#import "SCAPIRequest.h"

#define kAllDictionary          @"kAllDictionary"

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
    _type = type;                                   // 混存外部需要的字典类型
    NSDictionary *dic = [self readDictionary];      // 获取本地字典数据
    
    // 如果本地缓存的字典数据为空，从网络请求，并保存到本地，反之则生成字典数据对象做回调
    if (!dic)
    {
        [[SCAPIRequest manager] startGetAllDictionaryAPIRequestWithParameters:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                [self saveDictionary:responseObject];
                NSArray *data = responseObject[[@(type) stringValue]];
                [self handleDateWithData:data finfish:finfish];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleDateWithData:nil finfish:finfish];
        }];
    }
    else
    {
        NSArray *data = dic[[@(type) stringValue]];
        [self handleDateWithData:data finfish:finfish];
    }
}

#pragma mark - Private Methods
/**
 *  保存字典数据到本地
 *
 *  @param dic 字典数据
 */
- (void)saveDictionary:(NSDictionary *)dic
{
    [USER_DEFAULT setObject:dic forKey:kAllDictionary];
    [USER_DEFAULT synchronize];
}

/**
 *  从本地读取字典数据
 *
 *  @return 字典数据
 */
- (NSDictionary *)readDictionary
{
    NSDictionary *dic = [USER_DEFAULT objectForKey:kAllDictionary];
    return dic;
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
