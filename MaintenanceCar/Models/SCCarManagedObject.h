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
@property (nonatomic, copy) NSString *brandID;
@property (nonatomic, copy) NSString *brandCountry;
@property (nonatomic, copy) NSString *brandInitials;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *carOption;
@property (nonatomic, copy) NSString *carFullModel;
@property (nonatomic, copy) NSString *carDisplacement;
@property (nonatomic, copy) NSString *turbo;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *upTime;
@property (nonatomic, copy) NSString *gearBox;
@property (nonatomic, copy) NSString *techOwner;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;

@end
