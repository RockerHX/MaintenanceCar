//
//  SCShopList.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopList.h"
#import "SCAPIRequest.h"
#import "SCServerResponse.h"
#import "SCLocationManager.h"
#import "SCUserInfo.h"

@implementation SCShopList
{
    NSInteger _page;
    NSMutableArray *_shops;
}

#pragma mark - Init Methods
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initConfig];
    }
    return self;
}

#pragma mark - Config Methods
- (void)initConfig
{
    _shops = @[].mutableCopy;
    _parameters = @{@"limit": @(SearchLimit),
                   @"offset": @(_page * SearchLimit),
                   @"radius": @(SearchRadius),
             @"auto_get_car": @(YES),
                      @"uid": [SCUserInfo share].userID}.mutableCopy;
    _serverResponse = [[SCServerResponse alloc] init];
}

#pragma mark - Setter And Getter Methods
- (NSArray *)shops
{
    return [NSArray arrayWithArray:_shops];
}

#pragma mark - Public Methods
- (void)setParameter:(NSString *)parameter value:(NSString *)value
{
    [_parameters setValue:value forKey:parameter];
}

#pragma mark - Private Methods
- (void)clearShops
{
    [_shops removeAllObjects];
}

- (void)updateOffsetParameterWithPage:(NSInteger)page
{
    _page = page;
    [_parameters setValue:@(page * SearchLimit) forKey:@"offset"];
}

- (void)locationCompletedWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    [self addParametersWithLatitude:latitude longitude:longitude];
    [self requestShops];
}

- (void)addParametersWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    [_parameters setValue:latitude forKey:@"latitude"];
    [_parameters setValue:longitude forKey:@"longtitude"];
}

- (void)requestShops
{
    __weak typeof(self)weakSelf = self;
    [[SCAPIRequest manager] startShopsAPIRequestWithParameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            [_serverResponse parseResponseObject:responseObject];
            if (_serverResponse.firstLoad)
                [self clearShops];
            if (_serverResponse.statusCode == SCAPIRequestErrorCodeNoError)
            {
                [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCShop *shop = [SCShop objectWithKeyValues:obj];
                    SCShopViewModel *shopViewModel = [[SCShopViewModel alloc] initWithShop:shop];
                    [_shops addObject:shopViewModel];
                }];
                _page ++;
            }
            weakSelf.loaded = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == CocoaErrorCodeJsonParseError)
        {
            _serverResponse = [[SCServerResponse alloc] init];
            _serverResponse.statusCode = error.code;
            _serverResponse.prompt = CocoaErrorJsonParseError;
        }
        else
            [_serverResponse parseResponseObject:operation.responseObject];
        weakSelf.loaded = YES;
    }];
}

#pragma mark - Public Methods
- (void)reloadShops
{
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

- (void)loadMoreShops
{
    _serverResponse.firstLoad = NO;
    [self updateOffsetParameterWithPage:_page];
    [self requestShops];
}

@end
