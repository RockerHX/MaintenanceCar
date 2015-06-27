//
//  SCFilterViewModel.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilterViewModel.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"
#import "MicroConstants.h"
#import "SCServerResponse.h"

@implementation SCFilterViewModel

#pragma mark - Public Methods
- (void)load
{
    NSDictionary *parameters = @{@"uid": [SCUserInfo share].userID};
    WEAK_SELF(weakSelf);
    [[SCAPIRequest manager] startFilterCategoryAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _serverResponse = [[SCServerResponse alloc] initWithResponseObject:responseObject];
            if (_serverResponse.statusCode == SCAPIRequestErrorCodeNoError)
                _filter = [SCFilter objectWithKeyValues:responseObject[@"data"]];
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
