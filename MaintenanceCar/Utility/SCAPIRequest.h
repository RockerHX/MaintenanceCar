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

#pragma mark - Merchant API
/**
 *  天气接口请求方法(API:/Weather - GET)
 *
 *  @param uccess  请求成功的block
 *  @param failure 请求失败的block
 */
- (void)startWearthAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  商户列表接口请求方法(API:/company_search - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startMerchantListAPIRequestWithParameters:(NSDictionary *)parameters
                                          Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  商户详情接口请求方法(API:/Carshop - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startMerchantDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  商户收藏接口请求方法(API:/Collection - POST)
 *
 *  @param parameters   请求参数集合
 */
- (void)startMerchantCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                                Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取收藏商户接口请求方法(API:/Collection - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startGetCollectionMerchantAPIRequestWithParameters:(NSDictionary *)parameters
                                                   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  取消收藏商户接口请求方法(API:/Collection/delete - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startCancelCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                              Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  检查商户是否收藏接口请求方法(API:/Collection/user - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startCheckMerchantCollectionStutasAPIRequestWithParameters:(NSDictionary *)parameters
                                                           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - User Center API
/**
 *  验证码获取请求方法(API:/Verification - POST)
 *
 *  @param parameters   请求参数集合
 */
- (void)startGetVerificationCodeAPIRequestWithParameters:(NSDictionary *)parameters
                                                 Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户注册接口请求方法(API:/User - POST)
 *
 *  @param parameters   请求参数集合
 */
- (void)startRegisterAPIRequestWithParameters:(NSDictionary *)parameters
                                      Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户登陆接口请求方法(API:/User - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startLoginAPIRequestWithParameters:(NSDictionary *)parameters
                                   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户日志记录接口请求方法(API:/Userlog - POST)
 *
 *  @param parameters   请求参数集合
 */
- (void)startUserLogAPIRequestWithParameters:(NSDictionary *)parameters
                                     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Reservation Reuqest
/**
 *  商户预约接口请求方法(API:/Reservation - POST)
 *
 *  @param parameters   请求参数集合
 */
- (void)startMerchantReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                                 Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  我的预约接口请求方法(API:/Reservation/all - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startGetMyReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                              Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新预约接口请求方法(API:/Reservation/update - POST)
 *
 *  @param parameters   请求参数集合
 */
- (void)startUpdateReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新汽车品牌接口请求方法(API:/Car_brand - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startUpdateCarBrandAPIRequestWithParameters:(NSDictionary *)parameters
                                            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新汽车型号接口请求方法(API:/Car_model - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startUpdateCarModelAPIRequestWithParameters:(NSDictionary *)parameters
                                            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新汽车款式接口请求方法(API:/Cars - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startUpdateCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                        Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户添加车辆接口请求方法(API:/Usercar - POST)
 *
 *  @param parameters   请求参数集合
 */
- (void)startAddCarAPIRequestWithParameters:(NSDictionary *)parameters
                                        Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取用户所有车辆接口请求方法(API:/Usercar - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startGetUserCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Maintenance API
/**
 *  保养数据接口请求方法(API:/Baoyang/user - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startMaintenanceDataAPIRequestWithParameters:(NSDictionary *)parameters
                                             Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新车辆数据接口请求方法(API:/Usercar/update - POST)
 *
 *  @param parameters   请求参数集合
 */
- (void)startUpdateUserCarAPIRequestWithParameters:(NSDictionary *)parameters
                                           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Dictionary API
/**
 *  保养数据接口请求方法(API:/Misc/dictAll - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startGetAllDictionaryAPIRequestWithParameters:(NSDictionary *)parameters
                                              Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Special API
/**
 *  首页第四个按钮数据接口请求方法(API:/Special - GET)
 *
 *  @param parameters   请求参数集合
 */
- (void)startHomePageSpecialAPIRequestWithParameters:(NSDictionary *)parameters
                                             Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
