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
            if ([_flag hasPrefix:@"专"] && detail.majors.length)
            {
                _prompt = [NSString stringWithFormat:@"%@", detail.majors];
                _content = [_content stringByAppendingFormat:@"（%@）", _prompt];
            }
            else if ([_flag hasPrefix:@"综"] && detail.majors.length)
            {
                _prompt = [NSString stringWithFormat:@"该厂擅长维修%@", detail.majors];
                _content = [_content stringByAppendingFormat:@"（%@）", _prompt];
            }
        }];
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (NSString *)imageName
{
    return [[SCAllDictionary share] imageNameOfFlag:_flag];
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
        _star         = detail.star;
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
