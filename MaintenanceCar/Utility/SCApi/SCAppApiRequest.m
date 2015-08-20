//
//  SCAppApiRequest.m
//  MaintenanceCar
//
//  Created by Andy on 15/8/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAppApiRequest.h"
#import "SCUserInfo.h"
//#import "AppMicroConstants.h"


static NSString *const CustomRequestHeaderKey       = @"X-API-KEY";                // 请求头加密Key
static NSString *const CustomRequestHeaderValue     = @"SlwX20U65YMTuNRDe3fZ";     // 请求头加密Value

static NSString *const TokenRequestHeaderKey        = @"token";                    // 请求头token的Key
static NSString *const UIDRequestHeaderKey          = @"uid";                      // 请求头uid的Key

@implementation SCAppApiRequest

#pragma mark - Private Methods
/**
 *  通过导入工程的cer秘钥文件设置安全策略
 *
 *  @return AFSecurityPolicy实例
 */
- (void)customSecurityPolicy {
    @try {
        /**** SSL Pinning ****/
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];                    // 获取cer秘钥文件路径
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = NO;                                                           // 不允许使用无效证书
        securityPolicy.pinnedCertificates = @[certData];
        /**** SSL Pinning ****/
        self.securityPolicy = securityPolicy;
//        self.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    }
    @catch (NSException *exception) {
        NSLog(@"%s:%@", __FUNCTION__, exception.reason);
    }
    @finally {
    }
}

/**
 *  为请求添加自定义的KEY
 */
- (void)addHeader {
    SCUserInfo *userInfo = [SCUserInfo share];
    if (userInfo.loginState) {
        [self.requestSerializer setValue:userInfo.token forHTTPHeaderField:TokenRequestHeaderKey];
        [self.requestSerializer setValue:userInfo.userID forHTTPHeaderField:UIDRequestHeaderKey];
    }
    [self.requestSerializer setValue:CustomRequestHeaderValue forHTTPHeaderField:CustomRequestHeaderKey];
}

#pragma mark - Request Methods
- (void)requestGETMethodsWithAPI:(NSString *)api
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self addHeader];
    [self customSecurityPolicy];
    [super GET:api parameters:parameters success:success failure:failure];
}

- (void)requestPOSTMethodsWithAPI:(NSString *)api
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self addHeader];
    [self customSecurityPolicy];
    [super POST:api parameters:parameters success:success failure:failure];
}

#pragma mark - Merchant API
- (void)startMerchantListAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:SearchApi] parameters:parameters success:success failure:failure];
}

- (void)startMerchantDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:MerchantDetailApi] parameters:parameters success:success failure:failure];
}

- (void)startMerchantCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:MerchantCollectionApi] parameters:parameters success:success failure:failure];
}

- (void)startCollectionsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:MerchantCollectionApi] parameters:parameters success:success failure:failure];
}

- (void)startCancelCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:CancelCollectionApi] parameters:parameters success:success failure:failure];
}

#pragma mark - Group Product API
- (void)startMerchantGroupProductDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:MerchantGroupProductApi] parameters:parameters success:success failure:failure];
}

- (void)startGroupTicketsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:GroupTicketsApi] parameters:parameters success:success failure:failure];
}

- (void)startGroupTicketRefundAPIRequestWithParameters:(NSDictionary *)parameters
                                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:GroupTicketRefundApi] parameters:parameters success:success failure:failure];
}

#pragma mark - Pay API
- (void)startWeiXinOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:WeiXinOrderApi] parameters:parameters success:success failure:failure];
}

- (void)startWeiXinPayOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:WeiXinPayOrderApi] parameters:parameters success:success failure:failure];
}

- (void)startAliOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:AliOrderApi] parameters:parameters success:success failure:failure];
}

- (void)startAliPayOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:AliPayOrderApi] parameters:parameters success:success failure:failure];
}

#pragma mark - Comment API
- (void)startCommentAPIRequestWithParameters:(NSDictionary *)parameters
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:CommentApi] parameters:parameters success:success failure:failure];
}

- (void)startGetMerchantCommentListAPIRequestWithParameters:(NSDictionary *)parameters
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:MerchantCommentApi] parameters:parameters success:success failure:failure];
}

#pragma mark - User Center API
- (void)startGetVerificationCodeAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:VerificationCodeApi] parameters:parameters success:success failure:failure];
}

- (void)startLoginAPIRequestWithParameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:LoginApi] parameters:parameters success:success failure:failure];
}

- (void)startUserLogAPIRequestWithParameters:(NSDictionary *)parameters
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:UserLogApi] parameters:parameters success:success failure:failure];
}

- (void)startRefreshTokenAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:RefreshTokenApi] parameters:nil success:success failure:failure];
}

#pragma mark - Reservation Reuqest
- (void)startMerchantReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:MerchantReservationApi] parameters:parameters success:success failure:failure];
}

- (void)startUpdateReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:UpdateReservationApi] parameters:parameters success:success failure:failure];
}

- (void)startGetReservationItemNumAPIRequestWithParameters:(NSDictionary *)parameters
                                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:ReservationItemNumApi] parameters:parameters success:success failure:failure];
}

#pragma mark - Add Car Request
- (void)startUpdateCarBrandAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:CarBrandApi] parameters:parameters success:success failure:failure];
}

- (void)startUpdateCarModelAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:CarModelApi] parameters:parameters success:success failure:failure];
}

- (void)startUpdateCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:CarsApi] parameters:parameters success:success failure:failure];
}

- (void)startAddCarAPIRequestWithParameters:(NSDictionary *)parameters
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:AddCarApi] parameters:parameters success:success failure:failure];
}

- (void)startDeleteCarAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:DeleteCarApi] parameters:parameters success:success failure:failure];
}

- (void)startGetUserCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:AddCarApi] parameters:parameters success:success failure:failure];
}

#pragma mark - Maintenance Request
- (void)startMaintenanceDataAPIRequestWithParameters:(NSDictionary *)parameters
                                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:MaintenanceApi] parameters:parameters success:success failure:failure];
}

- (void)startUpdateUserCarAPIRequestWithParameters:(NSDictionary *)parameters
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:UpdateCarApi] parameters:parameters success:success failure:failure];
}

#pragma mark - AllDictionary Request
- (void)startGetAllDictionaryAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:AllDictionaryApi] parameters:nil success:success failure:failure];
}

- (void)startFlagsColorAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:FlagsColorExplainApi] parameters:nil success:success failure:failure];
}

- (void)startMerchantTagsAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:MerchantTagsApi] parameters:nil success:success failure:failure];
}

#pragma mark - Home Page API
- (void)startGetOperatADAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:OperatADApi] parameters:nil success:success failure:failure];
}

- (void)startHomePageReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:HomePageReservationApi] parameters:parameters success:success failure:failure];
}


#pragma mark - V2 API
#pragma mark - Shops API
- (void)startShopsAPIRequestWithParameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:ShopsApi] parameters:parameters success:success failure:failure];
}

- (void)startFilterCategoryAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:FilterCategoryApi] parameters:parameters success:success failure:failure];
}

- (void)startSearchShopsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:SearchShopsApi] parameters:parameters success:success failure:failure];
}

#pragma mark - User Center API
- (void)startProgressOrdersAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:ProgressOrdersApi] parameters:parameters success:success failure:failure];
}

- (void)startFinishedOrdersAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:FinishedOrdersApi] parameters:parameters success:success failure:failure];
}

- (void)startOrderDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:OrderDetailApi] parameters:parameters success:success failure:failure];
}

- (void)startOrderTicketsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:OrderTicketsApi] parameters:parameters success:success failure:failure];
}

- (void)startValidCouponsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:ValidCouponsApi] parameters:parameters success:success failure:failure];
}

- (void)startInvalidCouponsAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:InvalidCouponsApi] parameters:parameters success:success failure:failure];
}

- (void)startAddCouponAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:AddCouponApi] parameters:parameters success:success failure:failure];
}

- (void)startUseCouponAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:[SCApi apiURLWithApi:UseCouponApi] parameters:parameters success:success failure:failure];
}

- (void)startCouponMerchantsAPIRequestWithParameters:(NSDictionary *)parameters
                                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:[SCApi apiURLWithApi:CouponMerchantsApi] parameters:parameters success:success failure:failure];
}

@end
