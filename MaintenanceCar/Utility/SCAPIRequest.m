//
//  SCAPIRequest.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/25.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCAPIRequest.h"

#define CustomRequestHeaderKey        @"X-API-KEY"                  // 请求加密Key
#define CustomRequestHeaderValue      @"SlwX20U65YMTuNRDe3fZ"       // 请求加密Value

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
    /**** SSL Pinning ****/
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];                    // 获取cer秘钥文件路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;                                                           // 不允许使用无效证书
    securityPolicy.pinnedCertificates = @[certData];
    /**** SSL Pinning ****/
    self.securityPolicy = securityPolicy;
}

/**
 *  为请求添加自定义的KEY
 */
- (void)addHeader
{
    [self.requestSerializer setValue:CustomRequestHeaderValue forHTTPHeaderField:CustomRequestHeaderKey];
}

/**
 *  通用的GET请求方法
 *
 *  @param api        完整的API请求链接
 *  @param parameters 请求的参数集合
 *  @param uccess     请求成功的block
 *  @param failure    请求失败的block
 */
- (void)requestGETMethodsWithAPI:(NSString *)api
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self addHeader];
    [self customSecurityPolicy];
    [self GET:api parameters:parameters success:success failure:failure];
}

/**
 *  通用的POST请求方法
 *
 *  @param api        完整的API请求链接
 *  @param parameters 请求的参数集合
 *  @param uccess     请求成功的block
 *  @param failure    请求失败的block
 */
- (void)requestPOSTMethodsWithAPI:(NSString *)api
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self addHeader];
    [self customSecurityPolicy];
    [self POST:api parameters:parameters success:success failure:failure];
}

- (void)startWearthAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameters = @{@"location": @"深圳"};
    [self requestGETMethodsWithAPI:WearthAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Merchant API
- (void)startMerchantListAPIRequestWithParameters:(NSDictionary *)parameters
                                          Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:SearchAPIURL parameters:parameters success:success failure:failure];
}

- (void)startMerchantDetailAPIRequestWithParameters:(NSDictionary *)parameters
                                            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MerchantDetailAPIURL parameters:parameters success:success failure:failure];
}

- (void)startMerchantCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                                Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:MerchantCollectionAPIURL parameters:parameters success:success failure:failure];
}

- (void)startGetCollectionMerchantAPIRequestWithParameters:(NSDictionary *)parameters
                                                   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MerchantCollectionAPIURL parameters:parameters success:success failure:failure];
}

- (void)startCancelCollectionAPIRequestWithParameters:(NSDictionary *)parameters
                                              Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:CancelCollectionAPIURL parameters:parameters success:success failure:failure];
}

- (void)startCheckMerchantCollectionStutasAPIRequestWithParameters:(NSDictionary *)parameters
                                                           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:CheckMerchantCollectionAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - User Center API
- (void)startGetVerificationCodeAPIRequestWithParameters:(NSDictionary *)parameters
                                                 Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:VerificationCodeAPIURL parameters:parameters success:success failure:failure];
}

- (void)startRegisterAPIRequestWithParameters:(NSDictionary *)parameters
                                      Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    [self requestPOSTMethodsWithAPI:RegisterAPIURL parameters:parameters success:success failure:failure];
}

- (void)startLoginAPIRequestWithParameters:(NSDictionary *)parameters
                                   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:LoginAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUserLogAPIRequestWithParameters:(NSDictionary *)parameters
                                     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:UserLogAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Reservation Reuqest
- (void)startMerchantReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                                 Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:MerchantReservationAPIURL parameters:parameters success:success failure:failure];
}

- (void)startGetMyReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                              Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MyReservationAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUpdateReservationAPIRequestWithParameters:(NSDictionary *)parameters
                                               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:UpdateReservationAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Add Car Request
- (void)startUpdateCarBrandAPIRequestWithParameters:(NSDictionary *)parameters
                                            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:CarBrandAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUpdateCarModelAPIRequestWithParameters:(NSDictionary *)parameters
                                            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:CarModelAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUpdateCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                        Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:CarsAPIURL parameters:parameters success:success failure:failure];
}

- (void)startAddCarAPIRequestWithParameters:(NSDictionary *)parameters
                                    Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:AddCarAPIURL parameters:parameters success:success failure:failure];
}

- (void)startGetUserCarsAPIRequestWithParameters:(NSDictionary *)parameters
                                         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:AddCarAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Maintenance Request
- (void)startMaintenanceDataAPIRequestWithParameters:(NSDictionary *)parameters
                                             Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MaintenanceAPIURL parameters:parameters success:success failure:failure];
}

- (void)startUpdateUserCarAPIRequestWithParameters:(NSDictionary *)parameters
                                           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestPOSTMethodsWithAPI:UpdateCarAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - AllDictionary Request
- (void)startGetAllDictionaryAPIRequestWithParameters:(NSDictionary *)parameters
                                              Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:AllDictionaryAPIURL parameters:parameters success:success failure:failure];
}

#pragma mark - Special API
- (void)startHomePageSpecialAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:HomePageSpecialAPIURL parameters:nil success:success failure:failure];
}

- (void)startFlagsColorAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:FlagsColorAPIURL parameters:nil success:success failure:failure];
}

- (void)startMerchantTagsAPIRequestSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self requestGETMethodsWithAPI:MerchantTagsAPIURL parameters:nil success:success failure:failure];
}

@end
