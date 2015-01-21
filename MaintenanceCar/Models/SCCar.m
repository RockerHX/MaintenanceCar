//
//  SCCar.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCar.h"
#import "MicroCommon.h"
#import "SCCoreDataManager.h"
#import "SCCarManagedObject.h"

@implementation SCCar

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        // 设置CoreData数据信息
        [self setCoreData];
    }
    return self;
}

/**
 *  设置CoreData数据信息
 */
- (SCCoreDataManager *)setCoreData
{
    SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
    coreDataManager.entityName         = @"Car";
    coreDataManager.momdName           = @"MaintenanceCar";
    coreDataManager.sqliteName         = @"MaintenanceCar.sqlite";
    return coreDataManager;
}

#pragma mark - Public Methods
- (void)save
{
    @try {
        // 如果CoreData数据库内没有当前对象数据，则向数据库写入数据
        SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
        NSManagedObjectContext *context = [coreDataManager managedObjectContext];
        SCCarManagedObject *carManagedObject = [NSEntityDescription insertNewObjectForEntityForName:coreDataManager.entityName inManagedObjectContext:context];
        carManagedObject.carID        = _car_id;
        carManagedObject.modelID      = _model_id;
        carManagedObject.carFullModel = _car_full_model;
        carManagedObject.upTime       = _up_time;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Whoops, brand id %@ couldn't save: %@", self.model_id, [error localizedDescription]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SCCar Data Save Error:%@", exception.reason);
    }
    @finally {
    }
}

- (NSArray<Ignore> *)localData
{
    // 加载本地数据
    NSMutableArray *cars = [@[] mutableCopy];
    NSArray *localManageData = [self setCoreData].fetchedObjects;
    for (SCCarManagedObject *object in localManageData)
    {
        SCCar *car = [[SCCar alloc] init];
        car.car_id           = object.carID;
        car.model_id         = object.modelID;
        car.car_full_model   = object.carFullModel;
        car.up_time          = object.upTime;
        [cars addObject:car];
    }
    return cars;
}

@end
