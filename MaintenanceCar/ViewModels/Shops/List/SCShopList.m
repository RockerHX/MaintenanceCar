//
//  SCShopList.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SCShopList.h"
#import "MicroConstants.h"
#import "SCAPIRequest.h"
#import "SCShopViewModel.h"

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
//    WEAK_SELF(weakSelf);
    NSDictionary *parameters = @{@"limit": @"3",
                                @"offset": @"0"};
    [[SCAPIRequest manager] startShopsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode)
            {
                case SCAPIRequestErrorCodeNoError:
                {
                    [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SCShop *shop = [SCShop objectWithKeyValues:obj];
                        SCShopViewModel *shopViewModel = [SCShopViewModel initWithShop:shop];
                        [_shops addObject:shopViewModel];
                    }];
                }
                    break;
                    
                case SCAPIRequestErrorCodeListNotFoundMore:
                {
                }
                    break;
            }
            if (statusMessage.length)
                NSLog(@"%@", statusMessage);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
