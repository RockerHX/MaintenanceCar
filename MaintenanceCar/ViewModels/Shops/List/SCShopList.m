//
//  SCShopList.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import "SCShopList.h"
#import "SCAPIRequest.h"

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
            _statusCode = [responseObject[@"status_code"] integerValue];
            _serverPrompt = responseObject[@"status_message"];
            if (_statusCode == SCAPIRequestErrorCodeNoError)
            {
                [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCShop *shop = [SCShop objectWithKeyValues:obj];
                    SCShopViewModel *shopViewModel = [[SCShopViewModel alloc] initWithShop:shop];
                    [_shops addObject:shopViewModel];
                }];
            }
            weakSelf.shopsLoaded = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == CocoaErrorCodeJsonParseError)
        {
            _statusCode = error.code;
            _serverPrompt = CocoaErrorJsonParseError;
        }
        else
        {
            _statusCode = [operation.responseObject[@"status_code"] integerValue];
            _serverPrompt = operation.responseObject[@"status_message"];
        }
        weakSelf.shopsLoaded = YES;
    }];
}

@end
