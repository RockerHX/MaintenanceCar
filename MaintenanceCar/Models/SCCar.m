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

/**
 *  判断CoreData数据库内是否有SCCarBrand对象数据
 *
 *  @param object SCCarBrand对象
 *
 *  @return 是否包含改对象数据
 */
- (BOOL)hasObject:(SCCar *)object
{
    @try {
        SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
        NSArray *objects = coreDataManager.fetchedObjects;
        
        for (SCCarManagedObject *carManagedObject in objects)
        {
            if ([carManagedObject.brandID isEqualToString:object.brand_id])
            {
                if (![carManagedObject.updateTime isEqualToString:object.update_time])
                {
                    [coreDataManager.managedObjectContext deleteObject:carManagedObject];
                    NSError *error;
                    if (![coreDataManager.managedObjectContext save:&error])
                    {
                        NSLog(@"Whoops, brand id %@ couldn't save: %@", self.brand_id, [error localizedDescription]);
                    }
                    return NO;
                }
                else
                    return YES;
            }
        }
        return NO;
    }
    @catch (NSException *exception) {
        SCException(@"SCCar Data Compare Error:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Public Methods
- (BOOL)save
{
    @try {
        if (![self hasObject:self])
        {
            // 如果CoreData数据库内没有当前对象数据，则向数据库写入数据
            SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
            NSManagedObjectContext *context = [coreDataManager managedObjectContext];
            SCCarManagedObject *carManagedObject = [NSEntityDescription insertNewObjectForEntityForName:coreDataManager.entityName inManagedObjectContext:context];
            carManagedObject.carID           = _car_id;
            carManagedObject.modelID         = _model_id;
            carManagedObject.brandID         = _brand_id;
            carManagedObject.brandInitials   = _brand_Initials;
            carManagedObject.carFullModel    = _car_full_model;
            carManagedObject.carDisplacement = _car_displacement;
            carManagedObject.updateTime      = _up_time;
            carManagedObject.carType         = _car_type;
            carManagedObject.gearBox         = _gearbox;
            carManagedObject.techOwner       = _tech_owner;
            carManagedObject.carOption       = _car_option;
            carManagedObject.turbo           = _turbo;
            carManagedObject.grade           = _grade;
            carManagedObject.createTime      = _create_time;
            carManagedObject.updateTime      = _update_time ? _update_time : @"";
            
            NSError *error;
            if (![context save:&error])
            {
                NSLog(@"Whoops, brand id %@ couldn't save: %@", self.brand_id, [error localizedDescription]);
            }
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
        SCException(@"SCCar Data Save Error:%@", exception.reason);
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
        car.brand_id         = object.brandID;
        car.brand_Initials   = object.brandInitials;
        car.car_full_model   = object.carFullModel;
        car.car_displacement = object.carDisplacement;
        car.up_time          = object.upTime;
        car.car_type         = object.carType;
        car.gearbox          = object.gearBox;
        car.brand_country    = object.brandCountry;
        car.tech_owner       = object.techOwner;
        car.car_option       = object.carOption;
        car.turbo            = object.turbo;
        car.grade            = object.grade;
        car.update_time      = object.updateTime;
        car.create_time      = object.createTime;
        [cars addObject:car];
    }
    return cars;
}

@end
