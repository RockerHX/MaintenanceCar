//
//  SCUtility.h
//  新闻刚刚好
//
//  Created by ShiCang on 13-8-26.
//  Copyright (c) 201年. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCDirectoryType) {
    SCDirectoryTypeTypeHomeDir = 0,
    SCDirectoryTypeTypeDocumentsDir,
    SCDirectoryTypeTypeLibraryDir,
    SCDirectoryTypeTypeCachesDir,
    SCDirectoryTypeTypePictureDir,
    SCDirectoryTypeTypeMusicDir,
    SCDirectoryTypeTypeMovieDir,
    SCDirectoryTypeTypeTmpDir,
    SCDirectoryTypeTypeOtherDir
};

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
 *  获取储存路径
 *
 *  @param fileName 文件名
 *
 *  @return         文件路径
 */
+ (NSString *)getDirectoryWithType:(SCDirectoryType)directoryType;

/**
 *  处理链接获取完整文件名
 *
 *  @param url      网络连接
 *
 *  @return         文件名
 */
+ (NSString *)getFileNameAndHandleWithURL:(NSString *)url;

/**
 *  获取文件列表
 *
 *  @param fileName 文件名
 *
 *  @return 列表
 */
+ (NSArray *)getListWithFileName:(NSString *)fileName;

/**
 *  把数据写入文件
 *
 *  @param fileData 文件数据
 *  @param fileName 文件名
 *  @param type     文件类型
 */
+ (void)writeFileWithData:(id)fileData fileName:(NSString *)fileName;

/**
 *  获取文件名
 *
 *  @param fileName 完整文件名
 *
 *  @return 文件名
 */
+ (NSString *)getNameWithFileName:(NSString *)fileName;

/**
 *  删除文件
 *
 *  @param path     删除文件路径
 */
+ (void)deleteFileWithPath:(NSString *)path;

/**
 *  用网络接口和参数拼接处一个请求链接
 *
 *  @param baseURL  网络接口
 *  @param params   请求参数
 *
 *  @return         请求链接
 */
+ (NSURL *)generateURL:(NSString*)baseURL params:(NSDictionary*)params;

/**
 *  通过获取系统时间来判断刷新
 *
 *  @return 是否需要刷新
 */
+ (BOOL)isNeedRefresh;

/**
 *  重置刷新时间
 */
+ (void)recordTimeReset;

+ (BOOL)validateEmail:(NSString*)email;

@end
