//
//  SCCarManagedObject.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <CoreData/CoreData.h>

// 车辆型号对应CoreData数据Model，属性对应SCCar模型
@interface SCCarManagedObject : NSManagedObject

@property (nonatomic, copy) NSString *carID;
@property (nonatomic, copy) NSString *modelID;
@property (nonatomic, copy) NSString *carFullModel;
@property (nonatomic, copy) NSString *upTime;

@end
