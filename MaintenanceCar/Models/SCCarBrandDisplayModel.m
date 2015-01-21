//
//  SCCarBrandDisplayModel.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrandDisplayModel.h"
#import "MicroCommon.h"
#import "SCCoreDataManager.h"
#import "SCCarBrandManagedObject.h"
#import "SCCarBrand.h"
#import "SCAPIRequest.h"

#define CarBrandDataTimeIntervalKey         @"CarBrandDataTimeIntervalKey"

static SCCarBrandDisplayModel *displayModel = nil;

@interface SCCarBrandDisplayModel ()

@property (nonatomic, strong) NSMutableArray      *localData;
@property (nonatomic, strong) NSMutableArray      *serverData;
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, assign) NSString            *dateTimeInterval;

@property (nonatomic, assign) BOOL                localLoadFininsh;
@property (nonatomic, assign) BOOL                serverLoadFininsh;

@property (nonatomic, strong) NSMutableArray      *zip0;
@property (nonatomic, strong) NSMutableArray      *zipA;
@property (nonatomic, strong) NSMutableArray      *zipB;
@property (nonatomic, strong) NSMutableArray      *zipC;
@property (nonatomic, strong) NSMutableArray      *zipD;
@property (nonatomic, strong) NSMutableArray      *zipE;
@property (nonatomic, strong) NSMutableArray      *zipF;
@property (nonatomic, strong) NSMutableArray      *zipG;
@property (nonatomic, strong) NSMutableArray      *zipH;
@property (nonatomic, strong) NSMutableArray      *zipI;
@property (nonatomic, strong) NSMutableArray      *zipJ;
@property (nonatomic, strong) NSMutableArray      *zipK;
@property (nonatomic, strong) NSMutableArray      *zipL;
@property (nonatomic, strong) NSMutableArray      *zipM;
@property (nonatomic, strong) NSMutableArray      *zipN;
@property (nonatomic, strong) NSMutableArray      *zipO;
@property (nonatomic, strong) NSMutableArray      *zipP;
@property (nonatomic, strong) NSMutableArray      *zipQ;
@property (nonatomic, strong) NSMutableArray      *zipR;
@property (nonatomic, strong) NSMutableArray      *zipS;
@property (nonatomic, strong) NSMutableArray      *zipT;
@property (nonatomic, strong) NSMutableArray      *zipU;
@property (nonatomic, strong) NSMutableArray      *zipV;
@property (nonatomic, strong) NSMutableArray      *zipW;
@property (nonatomic, strong) NSMutableArray      *zipX;
@property (nonatomic, strong) NSMutableArray      *zipY;
@property (nonatomic, strong) NSMutableArray      *zipZ;

@end

@implementation SCCarBrandDisplayModel

#pragma mark - Init Methods
- (id)init
{
    self = [super init];
    if (self) {
        _loadFinish = NO;
        _localData  = [@[] mutableCopy];
        _serverData = [@[] mutableCopy];
        _data       = [@{} mutableCopy];
        _zip0       = [@[] mutableCopy];
        _zipA       = [@[] mutableCopy];
        _zipB       = [@[] mutableCopy];
        _zipC       = [@[] mutableCopy];
        _zipD       = [@[] mutableCopy];
        _zipE       = [@[] mutableCopy];
        _zipF       = [@[] mutableCopy];
        _zipG       = [@[] mutableCopy];
        _zipH       = [@[] mutableCopy];
        _zipI       = [@[] mutableCopy];
        _zipJ       = [@[] mutableCopy];
        _zipK       = [@[] mutableCopy];
        _zipL       = [@[] mutableCopy];
        _zipM       = [@[] mutableCopy];
        _zipN       = [@[] mutableCopy];
        _zipO       = [@[] mutableCopy];
        _zipP       = [@[] mutableCopy];
        _zipQ       = [@[] mutableCopy];
        _zipR       = [@[] mutableCopy];
        _zipS       = [@[] mutableCopy];
        _zipT       = [@[] mutableCopy];
        _zipU       = [@[] mutableCopy];
        _zipV       = [@[] mutableCopy];
        _zipW       = [@[] mutableCopy];
        _zipX       = [@[] mutableCopy];
        _zipY       = [@[] mutableCopy];
        _zipZ       = [@[] mutableCopy];
    }
    return self;
}

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        displayModel = [[SCCarBrandDisplayModel alloc] init];
        
        // 车辆品牌显示模型初始化完毕之后先加载本地数据，在进行服务器数据同步操作
        [displayModel loadLocalData];
        NSDictionary *parameters = @{@"time_flag": displayModel.dateTimeInterval};
        [[SCAPIRequest manager] startUpdateCarBrandAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                NSString *date = responseObject[@"stamp"];
                displayModel.dateTimeInterval = date;
                BOOL hasData = [responseObject[@"flag"] boolValue];
                if (hasData)
                {
                    NSDictionary *data = responseObject[@"data"];
                    // 遍历从服务器同步到的数据，异步检查数据是否存在以及更新
                    for (NSString *key in [data allKeys])
                    {
                        NSArray *brands = data[key];
                        for (NSDictionary *carData in brands)
                        {
                            NSError *error = nil;
                            SCCarBrand *carBrand = [[SCCarBrand alloc] initWithDictionary:carData error:&error];
                            if ([key isEqualToString:@"0"])
                                carBrand.brand_init = @"0";
                            if ([carBrand save])
                                [displayModel addObject:carBrand];
                        }
                    }
                }
                
                // 检查并添加完毕之后进行通知
                [displayModel addFinish];
            }
        } failure:nil];
    });
    return displayModel;
}

#pragma mark - Private Methods
- (void)handleDisplayData:(NSArray *)data
{
    // 获取一个全局队列并且创建一个用于异步处理数据的组
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    // 遍历所有数据
    __weak typeof(self) weakSelf = self;
    for (SCCarBrand *carBrand in data)
    {
        // 异步处理数据，将数据添加到对应数据结构中
        dispatch_group_async(group, queue, ^{
            [weakSelf handelDataWithCar:carBrand];
        });
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);      // 异步等待，防止异步线程冲突
    }
    
    // 所有异步操作完毕的回调，进行最后的数据处理，设置数据加载结束标识并且处理索引标题集合
    dispatch_group_notify(group, queue, ^{
        
        if (_localData.count || _serverData.count)
        {
            _loadFinish = YES;
            
            [weakSelf handleIndexTitles];
            [self setValue:@(YES) forKey:@"loadFinish"];
        }
    });
}

- (void)handleIndexTitles
{
    @try {
        // 获取可显示的汽车品牌数据首字母，进行升序
        _indexTitles = _loadFinish ? [[_data allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }] : nil;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
    }
}

- (void)handelDataWithCar:(SCCarBrand *)carBrand
{
    // 用于页面显示的数据结构转换
    @try {
        NSString *key = carBrand.brand_init;
        NSString *propertyName = [NSString stringWithFormat:@"zip%@", key];
        NSMutableArray *zip = (NSMutableArray *)[self valueForKey:propertyName];
        [zip addObject:carBrand];
        if (![_data valueForKey:key])
        {
            [_data setObject:zip forKey:key];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SCCarBrandDisplayModel Set Zip Data Error:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Getter And Setter Methods
- (NSDictionary *)displayData
{
    return _loadFinish ? _data : nil;
}

- (NSString *)dateTimeInterval
{
    NSString *date = [USER_DEFAULT objectForKey:CarBrandDataTimeIntervalKey];
    if (date)
        return date;
    else
        return @"0";
}

- (void)setDateTimeInterval:(NSString *)dateTimeInterval
{
    [USER_DEFAULT setObject:dateTimeInterval forKey:CarBrandDataTimeIntervalKey];
    [USER_DEFAULT synchronize];
}

#pragma mark - Public Methods
- (void)addObject:(id)object
{
    [_serverData addObject:object];
}

- (void)loadLocalData
{
    // 加载车辆品牌本地数据
    SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
    coreDataManager.entityName         = @"CarBrand";
    coreDataManager.momdName           = @"MaintenanceCar";
    coreDataManager.sqliteName         = @"MaintenanceCar.sqlite";
    NSArray *localManageData = coreDataManager.fetchedObjects;
    for (SCCarBrandManagedObject *object in localManageData)
    {
        SCCarBrand *carBrand = [[SCCarBrand alloc] init];
        carBrand.brand_id    = object.brandID;
        carBrand.brand_name  = object.brandName;
        carBrand.brand_init  = object.brandInit;
        carBrand.img_name    = object.imgName;
        [_localData addObject:carBrand];
    }
    // 加载完毕进行数据结构转换
    [self handleDisplayData:_localData];
}

- (void)addFinish
{
    // 服务器数据添加完毕进行数据结构转换
    [self handleDisplayData:_serverData];
}

@end
