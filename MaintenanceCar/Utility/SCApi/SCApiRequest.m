//
//  SCApiRequest.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/25.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCApiRequest.h"

@implementation SCApiRequest

#pragma mark - Init Methods
- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        NSURL *requestURL = [NSURL URLWithString:url];
        _doMain = [[requestURL.scheme stringByAppendingString:@"://"] stringByAppendingString:requestURL.host];     // 获取URL域
        
        // 异常捕获，传入的url可能有出错，在获取api路径的时候可能会出现访问数组数据溢出
        @try {
            _path = [requestURL.pathComponents[0] stringByAppendingString:requestURL.pathComponents[1]];            // 通过url参数获取到api路径
            _api = [requestURL.path stringByReplacingOccurrencesOfString:_path withString:@""];                     // 通过url参数获取到api
        }
        // 异常捕获成功，打印导致异常原因，path和api属性置nil
        @catch (NSException *exception) {
            NSLog(@"Set Path And API Error:%@", exception.reason);
            _path = nil;
            _api = nil;
        }
        @finally {
            _url = url;
            _requstURL = [NSURL URLWithString:url];
        }
    }
    
    return self;
}

- (instancetype)initWithDoMain:(NSString *)doMain path:(NSString *)path api:(NSString *)api {
    NSString *url = [[doMain stringByAppendingString:path] stringByAppendingString:api];
    self = [self initWithURL:url];
    _doMain = doMain;
    _path = path;
    _api = api;
    return self;
}

#pragma mark - Request Methods
- (void)requestGETMethodsWithAPI:(NSString *)api
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self GET:api parameters:parameters success:success failure:failure];
}

- (void)requestPOSTMethodsWithAPI:(NSString *)api
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self POST:api parameters:parameters success:success failure:failure];
}

@end
