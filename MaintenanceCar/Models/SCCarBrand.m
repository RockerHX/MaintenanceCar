//
//  SCCarBrand.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrand.h"
#import "SCCoreDataManager.h"
#import "SCCarBrandManagedObject.h"

@implementation SCCarBrand

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        // 设置CoreData数据信息
        SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
        coreDataManager.entityName         = @"CarBrand";
        coreDataManager.momdName           = @"MaintenanceCar";
        coreDataManager.sqliteName         = @"MaintenanceCar.sqlite";
    }
    return self;
}

/**
 *  判断CoreData数据库内是否有SCCarBrand对象数据
 *
 *  @param object SCCarBrand对象
 *
 *  @return 是否包含改对象数据
 */
- (BOOL)hasObject:(SCCarBrand *)object
{
    SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
    NSArray *objects = coreDataManager.fetchedObjects;
    
    for (SCCarBrandManagedObject *carBrandManagedObject in objects)
    {
        if ([carBrandManagedObject.brandID isEqualToString:object.brand_id])
        {
            if (![carBrandManagedObject.createTime isEqualToString:object.create_time])
            {
                [coreDataManager.managedObjectContext deleteObject:carBrandManagedObject];
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

#pragma mark - Public Methods
- (BOOL)save
{
    // 拼接车辆品牌logo文件名
    _img_name = [NSString stringWithFormat:@"%@.png", _brand_id];
    if (![self hasObject:self])
    {
        // 如果CoreData数据库内没有当前对象数据，则向数据库写入数据
        SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
        NSManagedObjectContext *context = [coreDataManager managedObjectContext];
        SCCarBrandManagedObject *carBrandManagedObject = [NSEntityDescription insertNewObjectForEntityForName:coreDataManager.entityName inManagedObjectContext:context];
        carBrandManagedObject.brandID    = _brand_id;
        carBrandManagedObject.brandName  = _brand_name;
        carBrandManagedObject.seriesID   = _series_id;
        carBrandManagedObject.seriesName = _series_name;
        carBrandManagedObject.brandInit  = _brand_init;
        carBrandManagedObject.imgName    = _img_name;
        carBrandManagedObject.brandOwner = _brand_owner;
        carBrandManagedObject.hitCount   = _hit_count;
        carBrandManagedObject.status     = _status;
        carBrandManagedObject.createTime = _create_time;
        
        NSError *error;
        if (![context save:&error])
            NSLog(@"Whoops, brand id %@ couldn't save: %@", self.brand_id, [error localizedDescription]);
        return YES;
    }
    return NO;
}

@end
