//
//  SCUtility.m
//
//  Copyright (c) 2013年 ShiCang. All rights reserved.
//

#import "SCUtility.h"

@implementation SCUtility

#pragma mark - Public Methods
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

+ (NSString *)getNameWithFileName:(NSString *)fileName
{
    NSInteger index = [fileName rangeOfString:@"." options:NSBackwardsSearch].location;
    return [fileName substringToIndex:index];
}

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

@end
