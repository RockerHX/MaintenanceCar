//
//  SCMerchantSummary.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantSummary.h"
#import "SCMerchantDetail.h"
#import "SCAllDictionary.h"

@implementation SCMerchantFlag

#pragma mark - Init Methods
- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail flag:(NSString *)flag
{
    self = [super init];
    if (self)
    {
        _flag = flag;
        [[SCAllDictionary share] requestColorsExplain:^(NSDictionary *colors, NSDictionary *explains, NSDictionary *details) {
            NSString *colorHex = colors[_flag];
            NSString *explain = explains[_flag];
            _title = explain ? explain : @"";
            _prompt = _title;
            _colorHex = colorHex ? colorHex : @"FFFFFF";
            
            _content = details[_flag];
            if ([_flag hasPrefix:@"专"])
            {
                _prompt = detail.majors;
                _content = [_content stringByAppendingString:[NSString stringWithFormat:@"(%@)", detail.majors]];
            }
        }];
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (NSString *)imageName
{
    NSString *name;
    if ([_flag isEqualToString:@"一"])
        name = @"OneIcon";
    else if ([_flag isEqualToString:@"二"])
        name = @"TwoIcon";
    else if ([_flag isEqualToString:@"三"])
        name = @"ThreeIcon";
    else if ([_flag isEqualToString:@"诚"])
        name = @"ChengIcon";
    else if ([_flag isEqualToString:@"综"])
        name = @"ZongIcon";
    else if ([_flag isEqualToString:@"专"])
        name = @"ZhuanIcon";
    return name;
}

@end


@implementation SCMerchantSummary

#pragma mark - Init Methods
- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail
{
    self = [super initWithMerchantDetail:detail];
    if (self)
    {
        _name         = detail.name;
        _distance     = detail.distance;
        _star         = [@([detail.star integerValue]/2) stringValue];
        _flags        = [detail.flags componentsSeparatedByString:@","];
        _unReserve    = ![SCAllDictionary share].serviceItems.count;
        _have_comment = [detail.have_comment integerValue];
        
        [self handleFlagsWithMerchantDetail:detail];
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (NSInteger)displayRow
{
    return _flags.count + 1;
}

#pragma mark - Private Methods
- (void)handleFlagsWithMerchantDetail:(SCMerchantDetail *)detail
{
    NSMutableArray *flags = [@[] mutableCopy];
    for (NSString *flag in _flags)
    {
        SCMerchantFlag *merchantFlag = [[SCMerchantFlag alloc] initWithMerchantDetail:detail flag:flag];
        [flags addObject:merchantFlag];
    }
    _flags = flags;
}

@end
