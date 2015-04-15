//
//  SCObject.m
//
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCObjectCategory.h"

@implementation  NSObject (SCObject)

- (BOOL)saveData:(id)data fileName:(NSString *)fileName
{
    return [self saveData:data path:[[[NSFileManager defaultManager] getDirectoryWithType:SCDirectoryOther] stringByAppendingString:fileName]];
}

- (id)readLocalDataWithFileName:(NSString *)fileName
{
    return [self readLocalDataWithPath:[[[NSFileManager defaultManager] getDirectoryWithType:SCDirectoryOther] stringByAppendingString:fileName]];
}

- (BOOL)saveData:(id)data path:(NSString *)path
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToFileAtPath:path append:NO];
    
    [outputStream open];
    NSError *error = nil;
    BOOL success = [NSJSONSerialization writeJSONObject:data toStream:outputStream options:NSJSONWritingPrettyPrinted error:&error];
    [outputStream close];
    return success;
}

- (id)readLocalDataWithPath:(NSString *)path
{
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
    
    [inputStream open];
    NSError *error = nil;
    id data = [NSJSONSerialization JSONObjectWithStream:inputStream options:NSJSONReadingMutableContainers error:&error];
    [inputStream close];
    return data;
}

@end
