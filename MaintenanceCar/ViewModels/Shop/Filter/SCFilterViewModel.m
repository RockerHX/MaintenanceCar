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

#pragma mark - Setter And Getter Methods
- (CGFloat)contentHeight
{
    if (_type == SCFilterTypeCarModel)
        return (120.0f + _filter.carModelCategory.myCarsViewHeight + _filter.carModelCategory.otherCarsViewHeight);
    else
        return ((_category.maxCount > 4) ? contentHeight : (_category.maxCount*44.0f + bottomBarHeight));
}

#pragma mark - Public Methods
- (void)changeCategory:(SCFilterType)type
{
    _type = type;
    switch (type)
    {
        case SCFilterTypeService:
            _category = _filter.serviceCategory;
            break;
        case SCFilterTypeRegion:
            _category = _filter.regionCategory;
            break;
        case SCFilterTypeSort:
            _category = _filter.sortCategory;
            break;
        case SCFilterTypeCarModel:
            _category = _filter.carModelCategory;
            break;
    }
}

- (void)loadCompleted:(void(^)(SCFilterViewModel *viewModel, BOOL success))block
{
    _block = block;
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID};
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
