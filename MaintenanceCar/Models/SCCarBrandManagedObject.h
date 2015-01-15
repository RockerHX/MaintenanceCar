//
//  SCCarBrandManagedObject.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SCCarBrandManagedObject : NSManagedObject

@property (nonatomic, copy) NSString *brandID;
@property (nonatomic, copy) NSString *seriesID;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *seriesName;
@property (nonatomic, copy) NSString *brandInit;
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *brandOwner;
@property (nonatomic, copy) NSString *hitCount;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *createTime;

@end
