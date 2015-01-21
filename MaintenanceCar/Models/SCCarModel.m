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
    coreDataManager.entityName         = @"CarModel";
    coreDataManager.momdName           = @"MaintenanceCar";
    coreDataManager.sqliteName         = @"MaintenanceCar.sqlite";
    return coreDataManager;
}

#pragma mark - Public Methods
- (void)save
{
    // 如果CoreData数据库内没有当前对象数据，则向数据库写入数据
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
}

- (NSArray<Ignore> *)localData
{
    // 加载本地数据
    NSMutableArray *carModels = [@[] mutableCopy];
    NSArray *localManageData = [self setCoreData].fetchedObjects;
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
