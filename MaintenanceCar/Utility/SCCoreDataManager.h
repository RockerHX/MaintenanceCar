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

@property (nonatomic, copy)             NSString                     *entityName;                   // CoreData实体名
@property (nonatomic, copy)             NSString                     *momdName;                     // CoreData数据文件名
@property (nonatomic, copy)             NSString                     *sqliteName;                   // SQLite数据库文件名

@property (readonly, strong, nonatomic) NSArray                      *fetchedObjects;               // 查询数据集合

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;         // CoreData管理上下文
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;           // CoreData管理模型
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;   // CoreData数据协调对象

/**
 *  SCCoreDataManager单例方法
 *
 *  @return SCCoreDataManager实例
 */
+ (SCCoreDataManager *)shareManager;

/**
 *  数据保存
 *
 *  @return 是否成功
 */
- (BOOL)saveContextSuccess;

/**
 *  获取沙盒路径
 *
 *  @return 沙盒路径
 */
- (NSURL *)applicationDocumentsDirectory;

@end
