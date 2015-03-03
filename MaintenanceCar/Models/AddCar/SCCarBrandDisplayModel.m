//
//  SCCarBrandDisplayModel.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrandDisplayModel.h"
#import "MicroCommon.h"
#import "SCCarBrand.h"
#import "SCAPIRequest.h"

#define kCarBrandDataKey                @"kCarBrandDataKey"
#define kCarBrandDataTimeIntervalKey    @"kCarBrandDataTimeIntervalKey"

typedef void(^BLOCK)(NSDictionary *displayData, NSArray *indexTitles, BOOL finish);

static SCCarBrandDisplayModel *displayModel = nil;

@interface SCCarBrandDisplayModel ()
{
    BLOCK _block;
}

@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, assign) NSString            *dateTimeInterval;

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
    });
    return displayModel;
}

#pragma mark - Private Methods
// 生成汽车品牌模型
- (void)generateCarBrandModelWithData:(NSDictionary *)data
{
    NSMutableArray *carBrands = [@[] mutableCopy];
    for (NSString *key in [data allKeys])
    {
        NSArray *brands = data[key];
        for (NSDictionary *carData in brands)
        {
            NSError *error = nil;
            SCCarBrand *carBrand = [[SCCarBrand alloc] initWithDictionary:carData error:&error];
            if ([key isEqualToString:@"0"])
                carBrand.brand_init = @"0";
            [carBrands addObject:carBrand];
        }
    }
    [self handleDisplayData:carBrands];
}

// 处理显示数据
- (void)handleDisplayData:(NSArray *)data
{
    // 遍历所有数据
    for (SCCarBrand *carBrand in data)
        [self handelDataWithCar:carBrand];
    
    if (data.count)
    {
        _loadFinish = YES;
        [self handleIndexTitles];
        
        if (_block)
            _block(_data, _indexTitles, _loadFinish);
    }
    else
        _block(nil, nil, _loadFinish);
}

// 数据重组
- (void)handelDataWithCar:(SCCarBrand *)carBrand
{
    // 用于页面显示的数据结构转换
    @try {
        NSString *key = carBrand.brand_init;
        NSString *propertyName = [NSString stringWithFormat:@"zip%@", key];
        NSMutableArray *zip = (NSMutableArray *)[self valueForKey:propertyName];
        [zip addObject:carBrand];
        if (![_data valueForKey:key])
            [_data setObject:zip forKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"SCCarBrandDisplayModel Set Zip Data Error:%@", exception.reason);
    }
    @finally {
    }
}

// 获取汽车品牌索引
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

// 清空临时混存数据 - 内存中
- (void)clearData
{
    for (NSMutableArray *zip in [_data allKeys])
        [_data[zip] removeAllObjects];
}

#pragma mark - Getter And Setter Methods
- (NSDictionary *)displayData
{
    // 如果数据重组完成，返回重组过的数据，反之这返回nil
    return _loadFinish ? _data : nil;
}

- (NSString *)dateTimeInterval
{
    // 如果本地缓存有时间戳数据，直接返回，反之返回0作为最初时间戳
    NSString *date = [USER_DEFAULT objectForKey:kCarBrandDataTimeIntervalKey];
    if (date)
        return date;
    else
        return @"0";
}

- (void)setDateTimeInterval:(NSString *)dateTimeInterval
{
    // 通过setter方法，把得到的时间戳混存到本地
    [USER_DEFAULT setObject:dateTimeInterval forKey:kCarBrandDataTimeIntervalKey];
    [USER_DEFAULT synchronize];
}

#pragma mark - Public Methods
- (void)requestCarBrands:(void (^)(NSDictionary *, NSArray *, BOOL))finfish
{
    // 每次开始请求前把数据缓存清空
    [self clearData];
    _block = finfish;
    
    __weak typeof(self)weakSelf = self;
    // 车辆品牌显示模型初始化完毕之后先加载本地数据，再进行服务器数据同步操作
    NSDictionary *localDate = [self readLocalDataWithKey:kCarBrandDataKey];
    if (!localDate)
    {
        // 如果本地没有缓存，则用最初的时间戳请求汽车品牌数据，请求成功后先把数据缓存到本地，再进行数据结构重组，用于加车页面显示
        NSDictionary *parameters = @{@"time_flag": @"0"};
        [[SCAPIRequest manager] startUpdateCarBrandAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                // 记录时间戳
                NSString *date = responseObject[@"stamp"];
                displayModel.dateTimeInterval = date;
                // 如果服务器返回有数据则数据重组后回调，没有则直接回调
                BOOL hasData = [responseObject[@"flag"] boolValue];
                if (hasData)
                {
                    NSDictionary *data = responseObject[@"data"];
                    [weakSelf saveData:data withKey:kCarBrandDataKey];
                    [weakSelf generateCarBrandModelWithData:data];
                }
                else
                    _block(nil, nil, _loadFinish);
            }
            else
                _block(nil, nil, _loadFinish);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (_block)
                _block(nil, nil, _loadFinish);
        }];
    }
    else
    {
        // 从本地缓存读取到数据之后进行数据重组用于显示
        [self generateCarBrandModelWithData:localDate];
        
        // 用上一次请求到的时间戳进行异步请求，请求成功则更新缓存数据，反之不处理
        NSDictionary *parameters = @{@"time_flag": displayModel.dateTimeInterval};
        [[SCAPIRequest manager] startUpdateCarBrandAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                NSString *date = responseObject[@"stamp"];
                displayModel.dateTimeInterval = date;
                BOOL hasData = [responseObject[@"flag"] boolValue];
                if (hasData)
                    [weakSelf saveData:responseObject[@"data"] withKey:kCarBrandDataKey];
            }
        } failure:nil];
    }
}

@end
