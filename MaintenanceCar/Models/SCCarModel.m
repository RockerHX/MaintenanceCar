//
//  SCCarModel.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarModel.h"
#import "SCCoreDataManager.h"
#import "SCCarModelManagedObject.h"

@implementation SCCarModel

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
        coreDataManager.entityName         = @"CarModel";
        coreDataManager.momdName           = @"MaintenanceCar";
        coreDataManager.sqliteName         = @"MaintenanceCar.sqlite";
    }
    return self;
}


- (BOOL)hasObject:(SCCarModel *)object
{
    SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
    NSArray *objects = coreDataManager.fetchedObjects;
    
    for (SCCarModelManagedObject *carModelManagedObject in objects)
    {
        if ([carModelManagedObject.brandID isEqualToString:object.brand_id])
        {
            if (![carModelManagedObject.createTime isEqualToString:object.create_time])
            {
                [coreDataManager.managedObjectContext deleteObject:carModelManagedObject];
                NSError *error;
                if (![coreDataManager.managedObjectContext save:&error])
                {
                    NSLog(@"Whoops, brand id %@ couldn't save: %@", self.brand_id, [error localizedDescription]);
                }
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Public Methods
- (BOOL)save
{
    if (![self hasObject:self])
    {
        SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
        NSManagedObjectContext *context = [coreDataManager managedObjectContext];
        SCCarModelManagedObject *carModelManagedObject = [NSEntityDescription insertNewObjectForEntityForName:coreDataManager.entityName inManagedObjectContext:context];
        carModelManagedObject.brandID    = _brand_id;
        carModelManagedObject.modelID    = _model_id;
        carModelManagedObject.memo       = _memo;
        carModelManagedObject.modelName  = _model_name;
        carModelManagedObject.createTime = _create_time;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Whoops, brand id %@ couldn't save: %@", self.brand_id, [error localizedDescription]);
        }
        return YES;
    }
    return NO;
}

- (NSArray<Ignore> *)localData
{
    NSMutableArray *carModels = [@[] mutableCopy];
    SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
    coreDataManager.entityName         = @"CarModel";
    coreDataManager.momdName           = @"MaintenanceCar";
    coreDataManager.sqliteName         = @"MaintenanceCar.sqlite";
    NSArray *localManageData = coreDataManager.fetchedObjects;
    for (SCCarModelManagedObject *object in localManageData)
    {
        SCCarModel *carModel = [[SCCarModel alloc] init];
        carModel.model_id    = object.modelID;
        carModel.brand_id    = object.brandID;
        carModel.memo        = object.memo;
        carModel.model_name  = object.modelName;
        carModel.create_time = object.createTime;
        [carModels addObject:carModel];
    }
    return carModels;
}

@end
