//
//  SCObject.h
//
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCFileManager.h"

@interface NSObject (SCObject)

/**
 *  保存缓存数据到本地
 *
 *  @param data 需要缓存的数据
 *  @param path 缓存数据文件名(缓存路径Temp)
 */
- (BOOL)saveData:(id)data fileName:(NSString *)fileName;

/**
 *  从本地读取数据
 *
 *  @return 本地缓存数据
 */
- (id)readLocalDataWithFileName:(NSString *)fileName;

/**
 *  保存缓存数据到本地
 *
 *  @param data 需要缓存的数据
 *  @param path 缓存数据路径
 */
- (BOOL)saveData:(id)data path:(NSString *)path;

/**
 *  从本地读取数据
 *
 *  @return 本地缓存数据
 */
- (id)readLocalDataWithPath:(NSString *)path;

/**
 *  获取商家Flag标签的图片文件名
 *
 *  @param flag 商家Flag标签名称
 *
 *  @return 商家Flag标签对应图片文件名
 */
- (NSString *)imageNameOfFlag:(NSString *)flag;

@end
