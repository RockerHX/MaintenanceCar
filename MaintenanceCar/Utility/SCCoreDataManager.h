//
//  SCCoreDataManager.h
//  MaintenanceCar
//
//  Created by ShiCang on 15-1-10.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SCCoreDataManager : NSObject

@property (nonatomic, copy)             NSString                     *entityName;
@property (nonatomic, copy)             NSString                     *momdName;
@property (nonatomic, copy)             NSString                     *sqliteName;

@property (readonly, strong, nonatomic) NSArray                      *fetchedObjects;

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SCCoreDataManager *)shareManager;

- (BOOL)saveContextSuccess;
- (NSURL *)applicationDocumentsDirectory;

@end
