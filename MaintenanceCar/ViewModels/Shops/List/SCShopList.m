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

@implementation SCShopList
{
    NSMutableArray *_shops;
}

#pragma mark - Init Methods
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _shops = @[].mutableCopy;
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (NSArray *)shops
{
    return [NSArray arrayWithArray:_shops];
}

#pragma mark - Public Methods
- (void)loadMoreShops
{
    NSDictionary *parameters = @{@"limit": @"10",
                                @"offset": @"0",
                              @"latitude": @"22.5207972824928",
                            @"longtitude": @"113.9498737813554",
                                @"radius": @"50000"};
    __weak typeof(self)weakSelf = self;
    [[SCAPIRequest manager] startShopsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _serverResponse = [[SCServerResponse alloc] initWithResponseObject:responseObject];
            if (_serverResponse.statusCode == SCAPIRequestErrorCodeNoError)
            {
                [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCShop *shop = [SCShop objectWithKeyValues:obj];
                    SCShopViewModel *shopViewModel = [[SCShopViewModel alloc] initWithShop:shop];
                    [_shops addObject:shopViewModel];
                }];
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
            _serverResponse = [[SCServerResponse alloc] initWithResponseObject:operation.responseObject];
        weakSelf.loaded = YES;
    }];
}

@end
