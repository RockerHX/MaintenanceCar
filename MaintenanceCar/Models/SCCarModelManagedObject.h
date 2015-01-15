//
//  SCCarModelManagedObject.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <CoreData/CoreData.h>

// 车辆车型对应CoreData数据Model，属性对应SCCarModel模型
@interface SCCarModelManagedObject : NSManagedObject

@property (nonatomic, copy) NSString *modelID;
@property (nonatomic, copy) NSString *brandID;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *createTime;

@end
