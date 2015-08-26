//
//  SCAllDictionary.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAllDictionary.h"
#import "SCObjectCategory.h"
#import "SCAppApiRequest.h"
#import "SCUserCar.h"

#define fColorExplainFileName           @"ColorExplain.dat"
#define fAllDictionaryFileName          @"AllDictionary.dat"

static SCAllDictionary *allDictionary = nil;

@implementation SCAllDictionary {
    SCDictionaryType _type;
}

#pragma mark - Init Methods
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allDictionary = [[SCAllDictionary alloc] init];
    });
    return allDictionary;
}

#pragma mark - Public Methods
- (void)requestWithType:(SCDictionaryType)type finfish:(void(^)(NSArray *items))finfish {
    _type = type;                                                                           // 缓存外部需要的字典类型
    NSDictionary *localData = [self readLocalDataWithFileName:fAllDictionaryFileName];      // 获取本地字典数据
    
    __weak typeof(self)weakSelf = self;
    // 如果本地缓存的字典数据为空，从网络请求，并保存到本地，反之则生成字典数据对象做回调，并异步更新数据
    if (!localData) {
        [[SCAppApiRequest manager] startGetAllDictionaryAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCApiRequestStatusCodeGETSuccess) {
                // 先处理数据，再保存，最后回调
                [weakSelf saveData:responseObject fileName:fAllDictionaryFileName];
                NSArray *data = responseObject[[@(type) stringValue]];
                [weakSelf handleDateWithData:data finfish:finfish];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleDateWithData:nil finfish:finfish];
        }];
    } else {
        // 先处理数据，再异步更新，最后回调
        NSArray *data = localData[[@(type) stringValue]];
        
        [[SCAppApiRequest manager] startGetAllDictionaryAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCApiRequestStatusCodeGETSuccess)
                [weakSelf saveData:responseObject fileName:fAllDictionaryFileName];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        [self handleDateWithData:data finfish:finfish];
    }
}

- (void)requestColorsExplain:(void(^)(NSDictionary *colors, NSDictionary *explains, NSDictionary *details))finfish {
    NSDictionary *localData = [self readLocalDataWithFileName:fColorExplainFileName];      // 获取颜色值本地缓存数据
    
    __weak typeof(self)weakSelf = self;
    // 如果本地缓存的商家Flags数据为空，从网络请求，并保存到本地，反之则生成数据对象做回调，并异步更新数据
    if (!localData) {
        [[SCAppApiRequest manager] startFlagsColorAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCApiRequestStatusCodeGETSuccess)
            {
                // 先处理数据，再保存，最后回调
                [weakSelf hanleMerchantFlagsData:responseObject];
                [weakSelf saveData:responseObject fileName:fColorExplainFileName];
                finfish(weakSelf.colors, weakSelf.explains, weakSelf.details);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            finfish(nil, nil, nil);
        }];
    } else {
        // 先处理数据，再异步更新，最后回调
        [weakSelf hanleMerchantFlagsData:localData];
        
        [[SCAppApiRequest manager] startFlagsColorAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf saveData:responseObject fileName:fColorExplainFileName];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        finfish(weakSelf.colors, weakSelf.explains, weakSelf.details);
    }
}

- (NSString *)imageNameOfFlag:(NSString *)flag {
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:[NSFileManager pathForResource:@"FlagsKV" ofType:@"plist"]];
    return data[flag];
}

#pragma mark - Private Methods
/**
 *  获取字典数据对象
 *
 *  @param data 字典数据
 *
 *  @return 字典数据对象集合
 */
- (NSArray *)getItemsWithData:(NSArray *)data {
    if (data) {
        NSMutableArray *items = [@[] mutableCopy];
        for (NSDictionary *dic in data) {
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
- (void)handleDateWithData:(NSArray *)data finfish:(void(^)(NSArray *data))finfish {
    switch (_type) {
        case SCDictionaryTypeOrderType: {
            _orderTypeItems = [self getItemsWithData:data];
            finfish(_orderTypeItems);
            break;
        }
        case SCDictionaryTypeReservationType: {
            _reservationTypeItems = [self getItemsWithData:data];
            finfish(_reservationTypeItems);
            break;
        }
        case SCDictionaryTypeQuestionType: {
            _questionTypeItems = [self getItemsWithData:data];
            finfish(_questionTypeItems);
            break;
        }
        case SCDictionaryTypeReservationStatus: {
            _reservationStatusItems = [self getItemsWithData:data];
            finfish(_reservationStatusItems);
            break;
        }
        case SCDictionaryTypeOrderStatus: {
            _orderStatusItems = [self getItemsWithData:data];
            finfish(_orderStatusItems);
            break;
        }
        case SCDictionaryTypeDriveHabit: {
            _driveHabitItems = [self getItemsWithData:data];
            finfish(_driveHabitItems);
            break;
        }
    }
}

/**
 *  把获取到的商家Flags数据赋值
 *
 *  @param data 商家Flags数据
 */
- (void)hanleMerchantFlagsData:(NSDictionary *)data {
    _colors   = data[@"color"];
    _explains = data[@"explain"];
    _details  = data[@"detail"];
}

@end
