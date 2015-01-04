//
//  SCAPIRequest.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/25.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "API.h"

@interface SCAPIRequest : AFHTTPRequestOperationManager

@property (nonatomic, copy) NSString *doMain;       // URL域
@property (nonatomic, copy) NSString *path;         // API路径
@property (nonatomic, copy) NSString *api;          // 请求的API

@property (nonatomic, copy) NSString *url;          // 完整的API链接地址(不带参数)

/**
 *  初始化方法 - 通过url参数生成SCAPIRequest实例
 *
 *  @param url 需要请求的链接
 *
 *  @return    SCAPIRequest实例
 */
- (instancetype)initWithURL:(NSString *)url;

/**
 *  初始化方法 - 通过拼接参数doMain, path, api成请求URL来生成SCAPIRequest实例
 *
 *  @param doMain URL域
 *  @param path   API路径
 *  @param api    请求的API
 *
 *  @return       SCAPIRequest实例
 */
- (instancetype)initWithDoMain:(NSString *)doMain
                          path:(NSString *)path
                           api:(NSString *)api;

/**
 *  天气接口请求方法(API:/Weather)
 *
 *  @param uccess  请求成功的block
 *  @param failure 请求失败的block
 */
- (void)startWearthAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  商户列表接口请求方法(API:/company_search)
 *
 *  @param parameters   请求参数集合
 *  @param uccess       请求成功的block
 *  @param failure      请求失败的block
 */
- (void)startMerchantListAPIRequestWithParameters:(NSDictionary *)parameters
                                          Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  商户详情接口请求方法(API:/Carshop)
 *
 *  @param parameters   请求参数集合
 *  @param uccess       请求成功的block
 *  @param failure      请求失败的block
 */
- (void)startMerchantDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  验证码获取请求方法(API:/Verification)
 *
 *  @param parameters   请求参数集合
 *  @param uccess       请求成功的block
 *  @param failure      请求失败的block
 */
- (void)startGetVerificationCodeAPIRequestWithParameters:(NSDictionary *)parameters
                                                 Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户注册接口请求方法(API:/User)
 *
 *  @param parameters   请求参数集合
 *  @param uccess       请求成功的block
 *  @param failure      请求失败的block
 */
- (void)startRegisterAPIRequestWithParameters:(NSDictionary *)parameters
                                      Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户登陆接口请求方法(API:/User)
 *
 *  @param parameters   请求参数集合
 *  @param uccess       请求成功的block
 *  @param failure      请求失败的block
 */
- (void)startLoginAPIRequestWithParameters:(NSDictionary *)parameters
                                   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
