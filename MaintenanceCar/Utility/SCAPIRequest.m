//
//  SCAPIRequest.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/25.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCAPIRequest.h"
#import "SCUserInfo.h"

NSString *const CocoaErrorJsonParseError    = @"数据出错，请联系元景科技！";

#define CustomRequestHeaderKey          @"X-API-KEY"                // 请求头加密Key
#define CustomRequestHeaderValue        @"SlwX20U65YMTuNRDe3fZ"     // 请求头加密Value

#define TokenRequestHeaderKey           @"token"                    // 请求头token的Key
#define UIDRequestHeaderKey             @"uid"                      // 请求头uid的Key

@interface SCAPIRequest ()

@property (nonatomic, strong)   NSURL *requstURL;       // 完整的API请求URL(不带参数)

@end

@implementation SCAPIRequest

#pragma mark - Init Methods
- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    if (self)
    {
        NSURL *requestURL = [NSURL URLWithString:url];
        self.doMain = [[requestURL.scheme stringByAppendingString:@"://"] stringByAppendingString:requestURL.host];     // 获取URL域
        
        // 异常捕获，传入的url可能有出错，在获取api路径的时候可能会出现访问数组数据溢出
        @try {
            self.path = [requestURL.pathComponents[0] stringByAppendingString:requestURL.pathComponents[1]];            // 通过url参数获取到api路径
            self.api = [requestURL.path stringByReplacingOccurrencesOfString:self.path withString:@""];                 // 通过url参数获取到api
        }
        // 异常捕获成功，打印导致异常原因，path和api属性置nil
        @catch (NSException *exception) {
            NSLog(@"Set Path And API Error:%@", exception.reason);
            self.path = nil;
            self.api = nil;
        }
        @finally {
            self.url = url;
            self.requstURL = [NSURL URLWithString:url];
        }
    }
    
    return self;
}

- (instancetype)initWithDoMain:(NSString *)doMain path:(NSString *)path api:(NSString *)api
{
    NSString *url = [[DoMain stringByAppendingString:path] stringByAppendingString:api];
    self = [self initWithURL:url];
    self.doMain = doMain;
    self.path = path;
    self.api = api;
    return self;
}

#pragma mark - Private Methods
/**
 *  通过导入工程的cer秘钥文件设置安全策略
 *
 *  @return AFSecurityPolicy实例
 */
- (void)customSecurityPolicy
{
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
- (void)addHeader
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (userInfo.loginStatus)
    {
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
    [self GET:api parameters:parameters success:success failure:failure];
}

- (void)requestPOSTMethodsWithAPI:(NSString *)api
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self addHeader];
    [self customSecurityPolicy];
    [self POST:api parameters:parameters success:success failure:failure];
}


#pragma mark - V1 API
#pragma mark - Merchant API
- (void)startMerchantListAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:SearchAPIURL parameters:parameters success:success failure:failure];
}

- (void)startMerchantDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MerchantDetailAPIURL parameters:parameters success:success failure:failure];
}

- (void)startMerchantCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:MerchantCollectionAPIURL parameters:parameters success:success failure:failure];
}

- (void)startCollectionsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MerchantCollectionAPIURL parameters:parameters success:success failure:failure];
}

- (void)startCancelCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:CancelCollectionAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Group Product API
- (void)startMerchantGroupProductDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MerchantGroupProductAPIURL parameters:parameters success:success failure:failure];
}

- (void)startGroupTicketsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:GroupTicketsAPIURL parameters:parameters success:success failure:failure];
}

- (void)startGroupTicketRefundAPIRequestWithParameters:(NSDictionary *)parameters
                                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:GroupTicketRefundAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Pay API
- (void)startWeiXinOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:WeiXinOrderAPIURL parameters:parameters success:success failure:failure];
}

- (void)startWeiXinPayOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:WeiXinPayOrderAPIURL parameters:parameters success:success failure:failure];
}

- (void)startAliOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:AliOrderAPIURL parameters:parameters success:success failure:failure];
}

- (void)startAliPayOrderAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:AliPayOrderAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Comment API
- (void)startCommentAPIRequestWithParameters:(NSDictionary *)parameters
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:CommentAPIURL parameters:parameters success:success failure:failure];
}

- (void)startGetMerchantCommentListAPIRequestWithParameters:(NSDictionary *)parameters
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MerchantCommentAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - User Center API
- (void)startGetVerificationCodeAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:VerificationCodeAPIURL parameters:parameters success:success failure:failure];
}

- (void)startLoginAPIRequestWithParameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:LoginAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUserLogAPIRequestWithParameters:(NSDictionary *)parameters
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:UserLogAPIURL parameters:parameters success:success failure:failure];
}

- (void)startRefreshTokenAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:RefreshTokenAPIURL parameters:nil success:success failure:failure];
}

#pragma mark - Reservation Reuqest
- (void)startMerchantReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:MerchantReservationAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUpdateReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:UpdateReservationAPIURL parameters:parameters success:success failure:failure];
}

- (void)startGetReservationItemNumAPIRequestWithParameters:(NSDictionary *)parameters
                                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:ReservationItemNumAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Add Car Request
- (void)startUpdateCarBrandAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:CarBrandAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUpdateCarModelAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:CarModelAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUpdateCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:CarsAPIURL parameters:parameters success:success failure:failure];
}

- (void)startAddCarAPIRequestWithParameters:(NSDictionary *)parameters
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:AddCarAPIURL parameters:parameters success:success failure:failure];
}

- (void)startDeleteCarAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:DeleteCarAPIURL parameters:parameters success:success failure:failure];
}

- (void)startGetUserCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:AddCarAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Maintenance Request
- (void)startMaintenanceDataAPIRequestWithParameters:(NSDictionary *)parameters
                                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MaintenanceAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUpdateUserCarAPIRequestWithParameters:(NSDictionary *)parameters
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:UpdateCarAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - AllDictionary Request
- (void)startGetAllDictionaryAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:AllDictionaryAPIURL parameters:nil success:success failure:failure];
}

- (void)startFlagsColorAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:FlagsColorExplainAPIURL parameters:nil success:success failure:failure];
}

- (void)startMerchantTagsAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MerchantTagsAPIURL parameters:nil success:success failure:failure];
}

#pragma mark - Home Page API
- (void)startGetOperatADAPIRequestWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:OperatADAPIURL parameters:nil success:success failure:failure];
}

- (void)startHomePageReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:HomePageReservationAPIURL parameters:parameters success:success failure:failure];
}

- (void)startHomePageSpecialAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:HomePageSpecialAPIURL parameters:nil success:success failure:failure];
}


#pragma mark - V2 API
#pragma mark - Shops API
- (void)startShopsAPIRequestWithParameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:ShopsAPIURL parameters:parameters success:success failure:failure];
}

- (void)startFilterCategoryAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:FilterCategoryAPIURL parameters:parameters success:success failure:failure];
}

- (void)startSearchShopsAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:SearchShopsAPI parameters:parameters success:success failure:failure];
}

#pragma mark - User Center API
- (void)startProgressOrdersAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:ProgressOrdersAPIURL parameters:parameters success:success failure:failure];
}

- (void)startFinishedOrdersAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:FinishedOrdersAPIURL parameters:parameters success:success failure:failure];
}

- (void)startOrderDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:OrderDetailAPIURL parameters:parameters success:success failure:failure];
}

- (void)startOrderTicketsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:OrderTicketsAPIURL parameters:parameters success:success failure:failure];
}

- (void)startValidCouponsAPIRequestWithParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:ValidCouponsAPIURL parameters:parameters success:success failure:failure];
}

- (void)startInvalidCouponsAPIRequestWithParameters:(NSDictionary *)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:InvalidCouponsAPIURL parameters:parameters success:success failure:failure];
}

- (void)startAddCouponAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:AddCouponAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUseCouponAPIRequestWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:UseCouponAPIURL parameters:parameters success:success failure:failure];
}

- (void)startCouponMerchantsAPIRequestWithParameters:(NSDictionary *)parameters
                                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:CouponMerchantsAPIURL parameters:parameters success:success failure:failure];
}

@end
