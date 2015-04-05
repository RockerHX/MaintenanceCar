//
//  SCUtility.h
//
//  Copyright (c) 2013年 ShiCang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCUtility : NSObject

/**
 *  检查字符串（防止空字符串执行方法是程序崩溃）
 *
 *  @param string   需要检查的字符串
 *
 *  @return         如果字符串为空就返回一个空值,否则原文返回
 */
+ (NSString *)examineIsNullByString:(NSString *)string;

/**
 *  解码字符串
 *
 *  @param string   需要解码的字符串
 *
 *  @return         解码后的字符串
 */
+ (NSString *)decodeByString:(NSString *)string;

/**
 *  编码字符串
 *
 *  @param string   需要编码的字符串
 *
 *  @return         编码后的字符串
 */
+ (NSString *)incodeByString:(NSString *)string;

/**
 *  获取文件名
 *
 *  @param fileName 完整文件名
 *
 *  @return 文件名
 */
+ (NSString *)getNameWithFileName:(NSString *)fileName;

+ (BOOL)validateEmail:(NSString*)email;

@end
