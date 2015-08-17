//
//  SCAppApiRequest.h
//  MaintenanceCar
//
//  Created by Andy on 15/8/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCApiRequest.h"
#import "SCApi.h"


typedef NS_ENUM(NSInteger, SCAppApiRequestErrorCode) {
    SCAppApiRequestErrorCodeNoError                   = 0,
    // Json Parse
    SCAppApiRequestErrorCodeJsonParseError            = 3840,
    // Login
    SCAppApiRequestErrorCodePhoneError                = 4001,
    SCAppApiRequestErrorCodeVerificationCodeSendError = 4002,
    SCAppApiRequestErrorCodeVerificationCodeError     = 4003,
    SCAppApiRequestErrorCodeThirdAuthorizeError       = 4004,
    SCAppApiRequestErrorCodeRefreshTokenError         = 4005,
    // Reservation
    SCAppApiRequestErrorCodeReservationFailure        = 4006,
    SCAppApiRequestErrorCodeListNotFoundMore          = 4008,
    // Collection
    SCAppApiRequestErrorCodeCancelCollectionFailure   = 4012,
    SCAppApiRequestErrorCodeCollectionFailure         = 4013,
    // Car
    SCAppApiRequestErrorCodeUserHaveNotCars           = 4302
};


@interface SCAppApiRequest : SCApiRequest

#pragma mark - Merchant API
/**
 *  商家列表接口请求方法(API:/company_search - GET)
 */
- (void)startMerchantListAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  商家详情接口请求方法(API:/Carshop - GET)
 */
- (void)startMerchantDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  商家收藏接口请求方法(API:/Collection - POST)
 */
- (void)startMerchantCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取收藏商家接口请求方法(API:/Collection - GET)
 */
- (void)startCollectionsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  取消收藏商家接口请求方法(API:/Collection/delete - GET)
 */
- (void)startCancelCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Group Product API
/**
 *  商家团购详情接口请求方法(API:/Group_product - GET)
 */
- (void)startMerchantGroupProductDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  团购券列表接口请求方法(API:/Group_ticket/all - GET)
 */
- (void)startGroupTicketsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  团购券退款接口请求方法(API:/wepay/refund - POST)
 */
- (void)startGroupTicketRefundAPIRequestWithParameters:(NSDictionary *)parameters
                                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Pay API
/**
 *  获取微信支付下单信息接口请求方法(API:/wepay - POST)
 */
- (void)startWeiXinOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取微信支付买单信息接口请求方法(API:/wepay/custom - POST)
 */
- (void)startWeiXinPayOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取支付宝下单信息接口请求方法(API:/zhipay - POST)
 */
- (void)startAliOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取支付宝买单信息接口请求方法(API:/zhipay/custom - POST)
 */
- (void)startAliPayOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Comment API
/**
 *  团购券详情接口请求方法(API:/Comments - POST)
 */
- (void)startCommentAPIRequestWithParameters:(NSDictionary *)parameters
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  团购券详情接口请求方法(API:/Comments/shop - GET)
 */
- (void)startGetMerchantCommentListAPIRequestWithParameters:(NSDictionary *)parameters
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - User Center API
/**
 *  验证码获取请求方法(API:/Verification - POST)
 */
- (void)startGetVerificationCodeAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户登录接口请求方法(API:/User - POST)
 */
- (void)startLoginAPIRequestWithParameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户日志记录接口请求方法(API:/Userlog - POST)
 */
- (void)startUserLogAPIRequestWithParameters:(NSDictionary *)parameters
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  刷新Token接口请求方法(API:/User/refresh/ - POST)
 */
- (void)startRefreshTokenAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Reservation Reuqest
/**
 *  商家预约接口请求方法(API:/Reservation - POST)
 */
- (void)startMerchantReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新预约接口请求方法(API:/Reservation/update - POST)
 */
- (void)startUpdateReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取预约数量接口请求方法(API:/Carshop/reservation_left - GET)
 */
- (void)startGetReservationItemNumAPIRequestWithParameters:(NSDictionary *)parameters
                                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Car Reuqest
/**
 *  更新汽车品牌接口请求方法(API:/Car_brand - GET)
 */
- (void)startUpdateCarBrandAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新汽车型号接口请求方法(API:/Car_model - GET)
 */
- (void)startUpdateCarModelAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新汽车款式接口请求方法(API:/Cars - GET)
 */
- (void)startUpdateCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户添加车辆接口请求方法(API:/Usercar - POST)
 */
- (void)startAddCarAPIRequestWithParameters:(NSDictionary *)parameters
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  用户删除车辆接口请求方法(API:/Usercar/delete - POST)
 */
- (void)startDeleteCarAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取用户所有车辆接口请求方法(API:/Usercar - GET)
 */
- (void)startGetUserCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Maintenance API
/**
 *  保养数据接口请求方法(API:/Baoyang/user - GET)
 */
- (void)startMaintenanceDataAPIRequestWithParameters:(NSDictionary *)parameters
                                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  更新车辆数据接口请求方法(API:/Usercar/update - POST)
 */
- (void)startUpdateUserCarAPIRequestWithParameters:(NSDictionary *)parameters
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Dictionary API
/**
 *  保养数据接口请求方法(API:/Misc/dictAll - GET)
 */
- (void)startGetAllDictionaryAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取商家对应Flag颜色值接口请求方法(API:/Special/color - GET)
 */
- (void)startFlagsColorAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取商家对应Tag标签接口请求方法(API:/Cars/tags - GET)
 */
- (void)startMerchantTagsAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Home Page API
/**
 *  首页运营位数据接口请求方法(API:/Special/ad - GET)
 */
- (void)startGetOperatADAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  首页最新预约数据接口请求方法(API:/Reservation/latest - GET)
 */
- (void)startHomePageReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Shops API
/**
 *  商家列表接口请求方法(API:/company_search/company_product - GET)
 */
- (void)startShopsAPIRequestWithParameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  筛选分类数据接口请求方法(API:/company_search/category - GET)
 */
- (void)startFilterCategoryAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  搜索商家接口请求方法(API:/company_search/input_result - GET)
 */
- (void)startSearchShopsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - User Center API
/**
 *  进行中订单接口请求方法(API:/Reservation/doing - GET)
 */
- (void)startProgressOrdersAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  已完成订单接口请求方法(API:/Reservation/done - GET)
 */
- (void)startFinishedOrdersAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  订单详情接口请求方法(API:/Reservation - GET)
 */
- (void)startOrderDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  订单详情接口请求方法(API:/Group_ticket/order - GET)
 */
- (void)startOrderTicketsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  有效优惠券接口请求方法(API:/coupon/get_effective_coupon - GET)
 */
- (void)startValidCouponsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  无效优惠券接口请求方法(API:/coupon/get_invalid_coupon - GET)
 */
- (void)startInvalidCouponsAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  添加优惠券接口请求方法(API:/coupon/add_coupon - POST)
 */
- (void)startAddCouponAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  使用优惠券接口请求方法(API:/coupon/use_coupon - POST)
 */
- (void)startUseCouponAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  优惠券商家接口请求方法(API:/coupon/shop_list - POST)
 */
- (void)startCouponMerchantsAPIRequestWithParameters:(NSDictionary *)parameters
                                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
