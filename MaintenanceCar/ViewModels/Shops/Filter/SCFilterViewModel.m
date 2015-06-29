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

typedef void(^BLOCK)(SCFilterViewModel *viewModel, BOOL success);

@implementation SCFilterViewModel
{
    BLOCK _block;
}

#pragma mark - Public Methods
- (void)loadCompleted:(void(^)(SCFilterViewModel *viewModel, BOOL success))block
{
    _block = block;
    NSDictionary *parameters = @{@"uid": [SCUserInfo share].userID};
    WEAK_SELF(weakSelf);
    [[SCAPIRequest manager] startFilterCategoryAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSInteger statusCode = [responseObject[@"status_code"] integerValue];
            if (statusCode == SCAPIRequestErrorCodeNoError)
                _filter = [SCFilter objectWithKeyValues:responseObject[@"data"]];
            if (_block)
                _block(weakSelf, YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_block)
            _block(nil, NO);
    }];
}

@end
