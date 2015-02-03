//
//  SCObject.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCObject.h"
#import "MicroCommon.h"

@implementation SCObject

/**
 *  保存字典数据到本地
 *
 *  @param dic 字典数据
 */
- (void)saveData:(id)data withKey:(NSString *)key
{
    [USER_DEFAULT setObject:data forKey:key];
    [USER_DEFAULT synchronize];
}

/**
 *  从本地读取字典数据
 *
 *  @return 字典数据
 */
- (id)readLocalDataWithKey:(NSString *)key
{
    id data = [USER_DEFAULT objectForKey:key];
    return data;
}

@end
