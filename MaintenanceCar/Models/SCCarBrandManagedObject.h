//
//  SCCarBrandManagedObject.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <CoreData/CoreData.h>

// 车辆品牌对应CoreData数据Model，属性对应SCCarBrand模型
@interface SCCarBrandManagedObject : NSManagedObject

@property (nonatomic, copy) NSString *brandID;
@property (nonatomic, copy) NSString *brandInit;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *imgName;

@end
