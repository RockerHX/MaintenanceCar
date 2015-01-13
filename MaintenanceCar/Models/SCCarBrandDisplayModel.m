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
#import "SCCarManagedObject.h"
#import "SCCar.h"

static SCCarBrandDisplayModel *displayModel = nil;

@interface SCCarBrandDisplayModel ()

@property (nonatomic, strong) NSMutableArray      *localData;
@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, strong) NSMutableArray      *zipTop;
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
+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        displayModel           = [[SCCarBrandDisplayModel alloc] init];
        displayModel.localData = [@[] mutableCopy];
        displayModel.data      = [@{} mutableCopy];
        displayModel.zipTop    = [@[] mutableCopy];
        displayModel.zipA      = [@[] mutableCopy];
        displayModel.zipB      = [@[] mutableCopy];
        displayModel.zipC      = [@[] mutableCopy];
        displayModel.zipD      = [@[] mutableCopy];
        displayModel.zipE      = [@[] mutableCopy];
        displayModel.zipF      = [@[] mutableCopy];
        displayModel.zipG      = [@[] mutableCopy];
        displayModel.zipH      = [@[] mutableCopy];
        displayModel.zipI      = [@[] mutableCopy];
        displayModel.zipJ      = [@[] mutableCopy];
        displayModel.zipK      = [@[] mutableCopy];
        displayModel.zipL      = [@[] mutableCopy];
        displayModel.zipM      = [@[] mutableCopy];
        displayModel.zipN      = [@[] mutableCopy];
        displayModel.zipO      = [@[] mutableCopy];
        displayModel.zipP      = [@[] mutableCopy];
        displayModel.zipQ      = [@[] mutableCopy];
        displayModel.zipR      = [@[] mutableCopy];
        displayModel.zipS      = [@[] mutableCopy];
        displayModel.zipT      = [@[] mutableCopy];
        displayModel.zipU      = [@[] mutableCopy];
        displayModel.zipV      = [@[] mutableCopy];
        displayModel.zipW      = [@[] mutableCopy];
        displayModel.zipX      = [@[] mutableCopy];
        displayModel.zipY      = [@[] mutableCopy];
        displayModel.zipZ      = [@[] mutableCopy];
    });
    return displayModel;
}

#pragma mark - Private Methods
- (void)handleDisplayDataWith:(SCCar *)car
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            NSString *key = car.brand_init;
            NSString *propertyName = [NSString stringWithFormat:@"zip%@", key];
            NSMutableArray *zip = (NSMutableArray *)[weakSelf valueForKey:propertyName];
            [zip addObject:car];
            if (![weakSelf.data valueForKey:key])
            {
                [weakSelf.data setObject:zip forKey:key];
            }
            SCLog(@"%@", propertyName);
        }
        @catch (NSException *exception) {
            SCException(@"SCCarBrandDisplayModel Set Zip Data Error:%@", exception.reason);
        }
        @finally {
        }
    });
}

#pragma mark - Getter And Setter Methods
- (NSDictionary *)displayData
{
    return _data;
}

#pragma mark - Public Methods
- (void)addObject:(id)object
{
    [self handleDisplayDataWith:object];
}

- (void)loadLocalData
{
    SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
    coreDataManager.entityName         = @"Car";
    coreDataManager.momdName           = @"MaintenanceCar";
    coreDataManager.sqliteName         = @"MaintenanceCar.sqlite";
    NSArray *localManageData = coreDataManager.fetchedObjects;
    for (SCCarManagedObject *object in localManageData)
    {
        SCCar *car = [[SCCar alloc] init];
        car.brand_id    = object.brandID;
        car.brand_name  = object.brandName;
        car.series_id   = object.seriesID;
        car.series_name = object.seriesName;
        car.brand_init  = object.brandInit;
        car.img_name    = object.imgName;
        car.brand_owner = object.brandOwner;
        car.hit_count   = object.hitCount;
        car.status      = object.status;
        car.create_time = object.createTime;
        [_localData addObject:car];
    }
    
    for (SCCar *car in _localData)
    {
        [self addObject:car];
    }
    
}

@end
