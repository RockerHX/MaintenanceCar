//
//  SCFileManager.m
//
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCFileManager.h"

#define HOME_DIRECTORY          NSHomeDirectory()
#define TMP_DIRECTORY           NSTemporaryDirectory()
#define DOCUMENTS_DIRECTORY     [HOME_DIRECTORY stringByAppendingFormat:@"/Documents"]
#define LIBRARY_DIRECTORY       [HOME_DIRECTORY stringByAppendingFormat:@"/Library"]
#define CACHES_DIRECTORY        [TMP_DIRECTORY stringByAppendingFormat:@"/Caches"]
#define PICTURE_DIRECTORY       [CACHES_DIRECTORY stringByAppendingFormat:@"/Picture/"]
#define MUSIC_DIRECTORY         [CACHES_DIRECTORY stringByAppendingFormat:@"/Muisc/"]
#define MOVIE_DIRECTORY         [CACHES_DIRECTORY stringByAppendingFormat:@"/Movie/"]
#define CACHE_DIRECTORY         [CACHES_DIRECTORY stringByAppendingFormat:@"/Cache/"]
#define OTHER_DIRECTORY         [CACHES_DIRECTORY stringByAppendingFormat:@"/Other/"]

@implementation NSFileManager (SCFileManager)

- (NSString *)getDirectoryWithType:(SCDirectory)directory
{
    switch (directory)
    {
        case SCDirectoryHome:
            return HOME_DIRECTORY;
            break;
        case SCDirectoryTmp:
            return TMP_DIRECTORY;
            break;
        case SCDirectoryDocuments:
            return DOCUMENTS_DIRECTORY;
            break;
        case SCDirectoryLibrary:
            return LIBRARY_DIRECTORY;
            break;
        case SCDirectoryCaches:
        {
            if ([self hasDirectoryAtPath:CACHE_DIRECTORY])
                return CACHE_DIRECTORY;
        }
            break;
        case SCDirectoryPicture:
        {
            if ([self hasDirectoryAtPath:PICTURE_DIRECTORY])
                return PICTURE_DIRECTORY;
        }
            break;
        case SCDirectoryMusic:
        {
            if ([self hasDirectoryAtPath:MUSIC_DIRECTORY])
            return MUSIC_DIRECTORY;
        }
            break;
        case SCDirectoryMovie:
        {
            if ([self hasDirectoryAtPath:MOVIE_DIRECTORY])
                return MOVIE_DIRECTORY;
        }
            break;
        case SCDirectoryOther:
        {
            if ([self hasDirectoryAtPath:OTHER_DIRECTORY])
                return OTHER_DIRECTORY;
        }
            break;
    }
    return HOME_DIRECTORY;
}

- (BOOL)deleteFileWithPath:(NSString *)path
{
    NSError *eroor = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&eroor];
    return eroor ? YES : NO;
}

#pragma mark -- Private Methods --
- (BOOL)hasDirectoryAtPath:(NSString *)path
{
    BOOL isDirectory = YES;
    NSError *error = nil;
    if (![self fileExistsAtPath:path isDirectory:&isDirectory])
    {
        if (![self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Directory Create Error");
        }
    }
    return error ? NO : YES;
}

@end
