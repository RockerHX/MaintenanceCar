//
//  SCAllDictionary.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAllDictionary.h"
#import "SCObjectCategory.h"
#import "SCAPIRequest.h"
#import "SCUserCar.h"


#define FilterConditionsResourceName    @"FilterConditions"
#define FilterConditionsResourceType    @"plist"

#define DistanceConditionKey            @"DistanceCondition"
#define RepairConditionKey              @"RepairCondition"
#define OtherConditionKey               @"OtherCondition"

#define fColorExplainFileName           @"ColorExplain.dat"
#define fAllDictionaryFileName          @"AllDictionary.dat"

static SCAllDictionary *allDictionary = nil;

@interface SCAllDictionary ()
{
    SCDictionaryType _type;
    
    NSDictionary *_filterConditions;
}

@end

@implementation SCAllDictionary

#pragma mark - Init Methods
- (id)init
{
    self = [super init];
    if (self) {
        
        // 初始化筛选数据
        NSDictionary *localData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:FilterConditionsResourceName ofType:FilterConditionsResourceType]];
        
        NSMutableDictionary *filterConditions = [localData mutableCopy];
        NSMutableArray *repairConditions = [NSMutableArray arrayWithArray:localData[RepairConditionKey]];
        NSMutableArray *otherConditions = [NSMutableArray arrayWithArray:localData[OtherConditionKey]];
        
        [filterConditions setObject:repairConditions forKey:RepairConditionKey];
        [filterConditions setObject:otherConditions forKey:OtherConditionKey];
        _filterConditions = filterConditions;
        
        _repairCondition = @"";
        _otherCondition  = @"";
    }
    return self;
}

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allDictionary = [[SCAllDictionary alloc] init];
    });
    return allDictionary;
}

#pragma mark - Setter And Getter
- (NSArray *)distanceConditions
{
    return _filterConditions[DistanceConditionKey];
}

- (NSArray *)repairConditions
{
    return _filterConditions[RepairConditionKey];
}

- (NSArray *)otherConditions
{
    return _filterConditions[OtherConditionKey];
}

#pragma mark - Public Methods
- (void)requestWithType:(SCDictionaryType)type finfish:(void(^)(NSArray *items))finfish
{
    _type = type;                                                               // 混存外部需要的字典类型
    NSDictionary *localData = [self readLocalDataWithFileName:fAllDictionaryFileName];    // 获取本地字典数据
    
    __weak typeof(self)weakSelf = self;
    // 如果本地缓存的字典数据为空，从网络请求，并保存到本地，反之则生成字典数据对象做回调，并异步更新数据
    if (!localData)
    {
        [[SCAPIRequest manager] startGetAllDictionaryAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                // 先处理数据，再保存，最后回调
                [weakSelf saveData:responseObject fileName:fAllDictionaryFileName];
                NSArray *data = responseObject[[@(type) stringValue]];
                [weakSelf handleDateWithData:data finfish:finfish];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleDateWithData:nil finfish:finfish];
        }];
    }
    else
    {
        // 先处理数据，再异步更新，最后回调
        NSArray *data = localData[[@(type) stringValue]];
        
        [[SCAPIRequest manager] startGetAllDictionaryAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
                [weakSelf saveData:responseObject fileName:fAllDictionaryFileName];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        [self handleDateWithData:data finfish:finfish];
    }
}

- (void)requestColorsExplain:(void(^)(NSDictionary *colors, NSDictionary *explain, NSDictionary *detail))finfish
{
    NSDictionary *localData = [self readLocalDataWithFileName:fColorExplainFileName];      // 获取颜色值本地缓存数据
    
    __weak typeof(self)weakSelf = self;
    // 如果本地缓存的商家Flags数据为空，从网络请求，并保存到本地，反之则生成数据对象做回调，并异步更新数据
    if (!localData)
    {
        [[SCAPIRequest manager] startFlagsColorAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                // 先处理数据，再保存，最后回调
                [weakSelf hanleMerchantFlagsData:responseObject];
                [weakSelf saveData:responseObject fileName:fColorExplainFileName];
                finfish(weakSelf.colors, weakSelf.explain, weakSelf.detail);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            finfish(nil, nil, nil);
        }];
    }
    else
    {
        // 先处理数据，再异步更新，最后回调
        [weakSelf hanleMerchantFlagsData:localData];
        
        [[SCAPIRequest manager] startFlagsColorAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf saveData:responseObject fileName:fColorExplainFileName];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        finfish(weakSelf.colors, weakSelf.explain, weakSelf.detail);
    }
}

- (void)replaceSpecialDataWith:(SCSpecial *)special
{
    _special = special;
    NSMutableArray *otherConditions = _filterConditions[OtherConditionKey];
    @try {
        if (otherConditions.count >= 5)
            [otherConditions removeObjectAtIndex:4];
        [otherConditions insertObject:@{@"DisplayName": special.text, @"RequestValue": @"检"} atIndex:4];
    }
    @catch (NSException *exception) {
        NSLog(@"OtherConditions Add Condition Error:%@", exception.reason);
    }
    @finally {
        [[SCAPIRequest manager] startMerchantTagsAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (NSDictionary *data in responseObject)
                [otherConditions addObject:@{@"DisplayName": data[@"tag_name"], @"RequestValue": @"tag"}];
        } failure:nil];
    }
}

- (void)generateServiceItemsWtihMerchantImtes:(NSDictionary *)merchantItems inspectFree:(BOOL)free;
{
    // 先分别取出服务项目
    NSArray *washItmes        = merchantItems[@"1"];
    NSArray *maintenanceItmes = merchantItems[@"2"];
    NSArray *repairItems      = merchantItems[@"3"];
    
    // 生成一个空的可变数组，根据服务项目的有无动态添加数据
    NSMutableArray *items = [@[] mutableCopy];
    if (washItmes.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"1" serviceName:@"洗车美容"]];
    if (maintenanceItmes.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"2" serviceName:@"保养"]];
    if (repairItems.count)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"3" serviceName:@"维修"]];
    
    // 最后动态添加服务器获取到的第四个按钮数据
    if (_special && free)
        [items addObject:[[SCServiceItem alloc] initWithServiceID:@"5" serviceName:_special.text]];
    _serviceItems = items;
}

- (void)hanleRepairConditions:(NSArray *)userCars
{
    // 先获取专修筛选数据
    NSMutableArray *repairConditions = _filterConditions[RepairConditionKey];
    // 获取专修筛选的第一个数据之后把数组清空，再添第一个预约项
    id defaultCondition = [repairConditions firstObject];
    [repairConditions removeAllObjects];
    if (defaultCondition)
        [repairConditions addObject:defaultCondition];
    // 根据用户汽车品牌动态添加专修筛选数据
    NSMutableSet *carSets = [NSMutableSet set];
    for (SCUserCar *userCar in userCars)
        [carSets addObject:userCar.brand_name];
    for (NSString *brandName in carSets)
    {
        NSString *displayName = [@"专修" stringByAppendingString:brandName];
        [repairConditions addObject:@{@"DisplayName": displayName, @"RequestValue": brandName}];
    }
}

#pragma mark - Private Methods
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

/**
 *  把获取到的商家Flags数据赋值
 *
 *  @param data 商家Flags数据
 */
- (void)hanleMerchantFlagsData:(NSDictionary *)data
{
    _colors = data[@"color"];
    _explain = data[@"explain"];
    _detail = data[@"detail"];
}

@end
