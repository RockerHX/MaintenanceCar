//
//  SCUtility.m
//  新闻刚刚好
//
//  Created by ShiCang on 13-8-26.
//  Copyright (c) 2013年 新闻刚刚好. All rights reserved.
//

#import "SCUtility.h"

#define HOME_DIRECTORY          NSHomeDirectory()
#define DOCUMENTS_DIRECTORY     [HOME_DIRECTORY stringByAppendingFormat:@"/Documents"]
#define LIBRARY_DIRECTORY       [HOME_DIRECTORY stringByAppendingFormat:@"/Library"]
#define CACHES_DIRECTORY        [LIBRARY_DIRECTORY stringByAppendingFormat:@"/Caches"]
#define PICTURE_DIRECTORY       [CACHES_DIRECTORY stringByAppendingFormat:@"/Picture/"]
#define MUSIC_DIRECTORY         [CACHES_DIRECTORY stringByAppendingFormat:@"/Muisc/"]
#define MOVIE_DIRECTORY         [CACHES_DIRECTORY stringByAppendingFormat:@"/Movie/"]
#define TMP_DIRECTORY           [CACHES_DIRECTORY stringByAppendingFormat:@"/tmp/"]
#define CACHE_DIRECTORY         [CACHES_DIRECTORY stringByAppendingFormat:@"/Cache/"]
#define OTHER_DIRECTORY         [CACHES_DIRECTORY stringByAppendingFormat:@"/Other/"]

#define RECORD_TIME             @"RECORD_TIME"
#define TIME_INTERVAL           600.0f

@implementation SCUtility

#pragma mark -- Class Methods --
+ (NSString *)examineIsNullByString:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]] || string == nil || [string isEqualToString:@"(null)"])
    {
        string = @"";
    }
    return string;
}

+ (NSString *)decodeByString:(NSString *)string
{
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)incodeByString:(NSString *)string
{
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)getDirectoryWithType:(SCDirectoryType)directoryType
{
    switch (directoryType)
    {
        case SCDirectoryTypeTypeDocumentsDir:
            return DOCUMENTS_DIRECTORY;
            break;
        case SCDirectoryTypeTypeLibraryDir:
            return LIBRARY_DIRECTORY;
            break;
        case SCDirectoryTypeTypeCachesDir:
            return CACHE_DIRECTORY;
            break;
        case SCDirectoryTypeTypePictureDir:
            [self examineDirectoryAndCreateWithPath:PICTURE_DIRECTORY];
            return PICTURE_DIRECTORY;
            break;
        case SCDirectoryTypeTypeMusicDir:
            [self examineDirectoryAndCreateWithPath:MUSIC_DIRECTORY];
            return MUSIC_DIRECTORY;
            break;
        case SCDirectoryTypeTypeMovieDir:
            [self examineDirectoryAndCreateWithPath:MOVIE_DIRECTORY];
            return MOVIE_DIRECTORY;
            break;
        case SCDirectoryTypeTypeTmpDir:
            [self examineDirectoryAndCreateWithPath:TMP_DIRECTORY];
            return TMP_DIRECTORY;
            break;
        case SCDirectoryTypeTypeOtherDir:
            [self examineDirectoryAndCreateWithPath:OTHER_DIRECTORY];
            return OTHER_DIRECTORY;
            break;
            
        default:
            return HOME_DIRECTORY;
            break;
    }
}

+ (NSString *)getFileNameAndHandleWithURL:(NSString *)url
{
    if (url)
    {
        NSRange range = [url rangeOfString:@"/" options:NSBackwardsSearch];
        range.location += 1;
        range.length = [url length] - range.location;
        return [url substringWithRange:range];
    }
    return @"failed";
}

+ (NSArray *)getListWithFileName:(NSString *)fileName
{
    return [NSArray arrayWithContentsOfFile:[[self getDirectoryWithType:SCDirectoryTypeTypeOtherDir] stringByAppendingString:fileName]];
}

+ (void)writeFileWithData:(id)fileData fileName:(NSString *)fileName
{
    NSString *path = [OTHER_DIRECTORY stringByAppendingString:fileName];
    if ([fileData respondsToSelector:@selector(writeToFile:atomically:)])
        [fileData writeToFile:path atomically:YES];
}

+ (NSString *)getNameWithFileName:(NSString *)fileName
{
    NSInteger index = [fileName rangeOfString:@"." options:NSBackwardsSearch].location;
    return [fileName substringToIndex:index];
}

+ (void)deleteFileWithPath:(NSString *)path
{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (BOOL)isNeedRefresh
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSTimeInterval recordTime = [[userDefault objectForKey:RECORD_TIME] doubleValue];
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    if (ABS(currentTime - recordTime) > TIME_INTERVAL)
    {
        [userDefault setObject:[NSNumber numberWithDouble:currentTime] forKey:RECORD_TIME];
        [userDefault synchronize];
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)recordTimeReset
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithDouble:0.0f] forKey:RECORD_TIME];
    [userDefault synchronize];
}

#pragma mark -- Private Methods --
+ (void)examineDirectoryAndCreateWithPath:(NSString *)path
{
    BOOL isDirectory = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSLog(@"Music Directory Create Error");
        }
    }
}

+ (NSURL *)generateURL:(NSString*)baseURL params:(NSDictionary*)params
{
	if (params)
    {
		NSMutableArray *pairs = [NSMutableArray array];
		for (NSString *key in params.keyEnumerator)
        {
			NSString *value = [params objectForKey:key];
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
		}
		
		NSString *query = [pairs componentsJoinedByString:@"&"];
		NSString *url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:[self incodeByString:url]];
	}
    else
    {
		return [NSURL URLWithString:[self incodeByString:baseURL]];;
	}
}

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

@end
