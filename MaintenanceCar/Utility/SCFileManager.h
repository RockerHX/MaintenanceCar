//
//  SCFileManager.h
//
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCDirectory) {
    SCDirectoryHome,
    SCDirectoryTmp,
    SCDirectoryDocuments,
    SCDirectoryLibrary,
    SCDirectoryCaches,
    SCDirectoryPicture,
    SCDirectoryMusic,
    SCDirectoryMovie,
    SCDirectoryOther
};

@interface NSFileManager (SCFileManager)

/**
 *  获取路径
 *
 *  @param directory 路径名称
 *
 *  @return 文件路径
 */
- (NSString *)getDirectoryWithType:(SCDirectory)directory;

/**
 *  删除文件
 *
 *  @param path 需要删除路径
 */
- (BOOL)deleteFileWithPath:(NSString *)path;

@end
