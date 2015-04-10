//
//  SCMerchantInfo.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantInfo.h"
#import "SCMerchantDetail.h"
#import "MicroConstants.h"

@implementation SCMerchantInfoItem : NSObject

#pragma mark - Init Methods
- (id)init
{
    self = [super init];
    if (self)
    {
        _fontSize = 15.0f;
        _textColor = [UIColor blackColor];
        _accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

#pragma mark - Setter And Getter
- (NSString *)text
{
    return _text.length ? _text : @"数据完善中...";
}

@end


@implementation SCMerchantInfo

#pragma mark - Init Methods
- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail
{
    self = [super initWithMerchantDetail:detail];
    if (self)
    {
        SCMerchantInfoItem *addressItem   = [[SCMerchantInfoItem alloc] init];
        addressItem.imageName             = @"MerchantAddressIcon";
        addressItem.text                  = detail.address;
        addressItem.canSelected           = YES;
        addressItem.accessoryType         = UITableViewCellAccessoryDisclosureIndicator;

        SCMerchantInfoItem *phoneItem     = [[SCMerchantInfoItem alloc] init];
        phoneItem.imageName               = @"MerchantPhoneIcon";
        phoneItem.text                    = detail.telephone;
        phoneItem.textColor               = UIColorWithRGBA(70.0f, 171.0f, 218, 1.0f);
        phoneItem.canSelected             = YES;

        SCMerchantInfoItem *timeItem      = [[SCMerchantInfoItem alloc] init];
        timeItem.imageName                = @"merchantTimeIcon";
        timeItem.text                     = [NSString stringWithFormat:@"%@ - %@", [detail.time_open substringWithRange:(NSRange){0, 5}], [detail.time_closed substringWithRange:(NSRange){0, 5}]];

        SCMerchantInfoItem *serviceItem   = [[SCMerchantInfoItem alloc] init];
        serviceItem.imageName             = @"MerchantIntroduceIcon";
        serviceItem.text                  = detail.serverItemsPrompt;

        SCMerchantInfoItem *introduceItem = [[SCMerchantInfoItem alloc] init];
        introduceItem.imageName           = @"MerchantIntroduceIcon";
        introduceItem.text                = detail.service;
        
        _infoItems = @[addressItem, phoneItem, timeItem, serviceItem, introduceItem];
    }
    return self;
}

#pragma mark - Setter And Getter
- (NSInteger)displayRow
{
    return _infoItems.count;
}

- (NSString *)headerTitle
{
    return @"商家详情";
}

@end
