//
//  SCApiRequest.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/25.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


typedef NS_ENUM(NSInteger, SCApiRequestStatusCode) {
    SCApiRequestStatusCodeGETSuccess     = 200,
    SCApiRequestStatusCodePOSTSuccess    = 201,
    
    SCApiRequestStatusCodeBadRequest     = 400,
    SCApiRequestStatusCodeTokenError     = 403,
    SCApiRequestStatusCodeNotFound       = 404,
    SCApiRequestStatusCodeDataError      = 408,
    
    SCApiRequestStatusCodeServerError    = 500
};


@interface SCApiRequest : AFHTTPRequestOperationManager

@property (nonatomic, copy, readonly) NSString *doMain;       // URL域
@property (nonatomic, copy, readonly) NSString *path;         // API路径
@property (nonatomic, copy, readonly) NSString *api;          // 请求的API

@property (nonatomic, copy, readonly) NSString *url;          // 完整的API链接地址(不带参数)
@property (nonatomic, strong, readonly)  NSURL *requstURL;    // 完整的API请求URL(不带参数)

/**
 *  初始化方法 - 通过url参数生成SCApiRequest实例
 *
 *  @param url 需要请求的链接
 *
 *  @return    SCApiRequest实例
 */
- (instancetype)initWithURL:(NSString *)url;

/**
 *  初始化方法 - 通过拼接参数doMain, path, api成请求URL来生成SCApiRequest实例
 *
 *  @param doMain URL域
 *  @param path   API路径
 *  @param api    请求的API
 *
 *  @return       SCApiRequest实例
 */
- (instancetype)initWithDoMain:(NSString *)doMain
                          path:(NSString *)path
                           api:(NSString *)api;

/**
 *  通用的GET请求方法
 *
 *  @param api        完整的API请求链接
 *  @param parameters 请求的参数集合
 *  @param uccess     请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)requestGETMethodsWithAPI:(NSString *)api
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  通用的POST请求方法
 *
 *  @param api        完整的API请求链接
 *  @param parameters 请求的参数集合
 *  @param uccess     请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)requestPOSTMethodsWithAPI:(NSString *)api
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
