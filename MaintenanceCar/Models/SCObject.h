//
//  SCObject.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCObject : NSObject

/**
 *  保存字典数据到本地
 *
 *  @param dic 字典数据
 */
- (void)saveData:(id)data withKey:(NSString *)key;

/**
 *  从本地读取字典数据
 *
 *  @return 字典数据
 */
- (id)readLocalDataWithKey:(NSString *)key;

@end
