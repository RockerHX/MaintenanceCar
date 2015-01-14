//
//  SCCar.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCar.h"
#import "SCCoreDataManager.h"
#import "SCCarManagedObject.h"

@implementation SCCar

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
        coreDataManager.entityName         = @"Car";
        coreDataManager.momdName           = @"MaintenanceCar";
        coreDataManager.sqliteName         = @"MaintenanceCar.sqlite";
    }
    return self;
}

- (BOOL)hasObject:(SCCar *)object
{
    NSArray *objects = [SCCoreDataManager shareManager].fetchedObjects;
    
    for (SCCarManagedObject *carManagedObject in objects)
    {
        if ([carManagedObject.brandID isEqualToString:object.brand_id])
            return YES;
    }
    return NO;
}

#pragma mark - Public Methods
- (BOOL)save
{
    _img_name = [NSString stringWithFormat:@"%@.png", _brand_id];
    if (![self hasObject:self])
    {
        SCCoreDataManager *coreDataManager = [SCCoreDataManager shareManager];
        NSManagedObjectContext *context = [coreDataManager managedObjectContext];
        SCCarManagedObject *carManagedObject = [NSEntityDescription insertNewObjectForEntityForName:coreDataManager.entityName inManagedObjectContext:context];
        carManagedObject.brandID    = _brand_id;
        carManagedObject.brandName  = _brand_name;
        carManagedObject.seriesID   = _series_id;
        carManagedObject.seriesName = _series_name;
        carManagedObject.brandInit  = _brand_init;
        carManagedObject.imgName    = _img_name;
        carManagedObject.brandOwner = _brand_owner;
        carManagedObject.hitCount   = _hit_count;
        carManagedObject.status     = _status;
        carManagedObject.createTime = _create_time;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Whoops, brand id %@ couldn't save: %@", self.brand_id, [error localizedDescription]);
        }
        return YES;
    }
    return NO;
}

@end
