//
//  SCAPIRequest.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/25.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCAPIRequest.h"

static SCAPIRequest *apiRequest = nil;

@interface SCAPIRequest ()

@property (nonatomic, strong)   NSURL *requstURL;

@end

@implementation SCAPIRequest

#pragma mark - Init Methods
#pragma mark -
+ (instancetype)shareRequest
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiRequest = [[SCAPIRequest alloc] init];
        apiRequest.doMain = DoMain;
        apiRequest.path = APIPath;
    });
    return apiRequest;
}

- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    if (self)
    {
        NSURL *requestURL = [NSURL URLWithString:url];
        self.doMain = [[requestURL.scheme stringByAppendingString:@"://"] stringByAppendingString:requestURL.host];
        
        @try {
            self.path = [requestURL.pathComponents[0] stringByAppendingString:requestURL.pathComponents[1]];
            self.api = [requestURL.path stringByReplacingOccurrencesOfString:self.path withString:@""];
        }
        @catch (NSException *exception) {
            NSLog(@"Set Path And API Error:%@", exception.reason);
            self.path = nil;
            self.api = nil;
        }
        @finally {
        }
        
        self.url = url;
        self.requstURL = [NSURL URLWithString:url];
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
#pragma mark -
- (AFSecurityPolicy *)customSecurityPolicy
{
    /**** SSL Pinning ****/
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"bundle" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.pinnedCertificates = @[certData];
    /**** SSL Pinning ****/
    return securityPolicy;
}

- (NSDictionary *)requestGETMethodsWithAPI:(NSString *)api parameters:(NSDictionary *)parameters
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.securityPolicy = [self customSecurityPolicy];
    [manger GET:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Parse Josn error:%@", error);
        NSLog(@"Json:%@", dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Rquest error:%@", error);
    }];
    return @{@"a": @"a"};
}

#pragma mark - Public Methods
#pragma mark -
- (NSDictionary *)startWearthAPIRequest
{
    NSDictionary *parameters = @{@"location": @"深圳"};
    return [self requestGETMethodsWithAPI:WearthAPIURL parameters:parameters];
}

@end
