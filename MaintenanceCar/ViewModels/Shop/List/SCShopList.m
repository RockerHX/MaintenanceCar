//
//  SCShopList.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopList.h"
#import "SCAppApiRequest.h"
#import "SCServerResponse.h"
#import "SCLocationManager.h"
#import "SCAppConstants.h"
#import "SCUserInfo.h"

@implementation SCShopList {
    NSInteger _page;
    NSMutableArray *_shops;
}

#pragma mark - Init Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

#pragma mark - Config Methods
- (void)initConfig {
    _shops = @[].mutableCopy;
    _parameters = @{@"limit": @(SearchLimit),
                   @"offset": @(_page * SearchLimit),
                   @"radius": @(SearchRadius)}.mutableCopy;
    _serverResponse = [[SCServerResponse alloc] init];
}

#pragma mark - Setter And Getter Methods
- (NSArray *)shops {
    return [NSArray arrayWithArray:_shops];
}

#pragma mark - Public Methods
- (void)setParameter:(id)parameter value:(id)value {
    [_parameters setValue:value forKey:parameter];
}

- (void)addParameters:(NSDictionary *)parameters {
    NSArray *keys = [parameters allKeys];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_parameters setValue:parameters[@"obj"] forKey:obj];
    }];
}

#pragma mark - Private Methods
- (void)clearShops {
    [_shops removeAllObjects];
}

- (void)updateOffsetParameterWithPage:(NSInteger)page {
    _page = page;
    [_parameters setValue:@(page * SearchLimit) forKey:@"offset"];
}

- (void)locationCompletedWithLatitude:(NSString *)latitude longitude:(NSString *)longitude {
    [self addParametersWithLatitude:latitude longitude:longitude];
    [self requestShops];
}

- (void)addParametersWithLatitude:(NSString *)latitude longitude:(NSString *)longitude {
    [_parameters setValue:latitude forKey:@"latitude"];
    [_parameters setValue:longitude forKey:@"longtitude"];
}

- (void)loadNewShops {
    _serverResponse.firstLoad = YES;
    [self updateOffsetParameterWithPage:0];
    
    __weak typeof(self)weakSelf = self;
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        [weakSelf locationCompletedWithLatitude:latitude longitude:longitude];
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        [weakSelf locationCompletedWithLatitude:latitude longitude:longitude];
        _serverResponse.locationPrompt = @"定位失败，采用当前城市中心坐标!";
    }];
}

- (void)requestShops {
    __weak typeof(self)weakSelf = self;
    if (_type == SCShopListTypeSearch) {
        [[SCAppApiRequest manager] startSearchShopsAPIRequestWithParameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf reuqeustSuccessWithOperation:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf reuqeustFailureWithOperation:operation error:error];
        }];
    } else {
        [[SCAppApiRequest manager] startShopsAPIRequestWithParameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf reuqeustSuccessWithOperation:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf reuqeustFailureWithOperation:operation error:error];
        }];
    }
}

- (void)reuqeustSuccessWithOperation:(AFHTTPRequestOperation *)operation {
    id responseObject = operation.responseObject;
    if (operation.response.statusCode == SCApiRequestStatusCodeGETSuccess) {
        [_serverResponse parseResponseObject:responseObject];
        if (_serverResponse.firstLoad) {
            [self clearShops];
        }
        if (_serverResponse.statusCode == SCAppApiRequestErrorCodeNoError) {
            [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCShop *shop = [SCShop objectWithKeyValues:obj];
                SCShopViewModel *shopViewModel = [[SCShopViewModel alloc] initWithShop:shop];
                [_shops addObject:shopViewModel];
            }];
            _page ++;
        }
        self.loaded = YES;
    }
}

- (void)reuqeustFailureWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    if (error.code == SCAppApiRequestErrorCodeJsonParseError) {
        _serverResponse = [[SCServerResponse alloc] init];
        _serverResponse.statusCode = error.code;
        _serverResponse.prompt = JsonParseError;
    } else {
        [_serverResponse parseResponseObject:operation.responseObject];
    }
    self.loaded = YES;
}

#pragma mark - Public Methods
- (void)reloadShops {
    [self initConfig];
    [self loadShops];
}

- (void)loadShops {
    _type = SCShopListTypeNormal;
    [self setParameter:@"auto_get_car" value:@([SCUserInfo share].loginState)];
    [self setParameter:@"user_id" value:[SCUserInfo share].userID];
    [self loadNewShops];
}

- (void)loadShopsWithSearch:(NSString *)search {
    _type = SCShopListTypeSearch;
    [self setParameter:@"field" value:search];
    [self loadNewShops];
}

- (void)loadMoreShops {
    _serverResponse.firstLoad = NO;
    [self updateOffsetParameterWithPage:_page];
    [self requestShops];
}

@end
