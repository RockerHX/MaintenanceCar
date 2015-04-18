//
//  SCMileageView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMileageView.h"

#define BitsKey                 @"BitsKey"
#define TenKey                  @"TenKey"
#define HundredKey              @"HundredKey"
#define ThousandKey             @"ThousandKey"
#define TenThousandKey          @"TenThousandKey"
#define HundredThousandKey      @"HundredThousandKey"

@implementation SCMileageView

#pragma mark - Setter And Getter Methods
- (void)setMileage:(NSString *)mileage
{
    NSDictionary *mileageNumber = [self getMileageNumber:[mileage integerValue]];
    
    _bitsLabel.text            = mileageNumber[BitsKey];
    _tenLabel.text             = mileageNumber[TenKey];
    _hundredLabel.text         = mileageNumber[HundredKey];
    _thousandLabel.text        = mileageNumber[ThousandKey];
    _tenThousandLabel.text     = mileageNumber[TenThousandKey];
    _hundredThousandLabel.text = mileageNumber[HundredThousandKey];
}

#pragma mark - Private Methods
/**
 *  分解里程数
 *
 *  @param mileage 里程数据
 *
 *  @return 里程数据元素
 */
- (NSDictionary *)getMileageNumber:(NSInteger)mileage
{
    NSDictionary *defaultData = @{BitsKey: @"0",
                                   TenKey: @"0",
                               HundredKey: @"0",
                              ThousandKey: @"0",
                           TenThousandKey: @"0",
                       HundredThousandKey: @"0"};
    NSMutableDictionary *numbers = [defaultData mutableCopy];
    
    @try {
        NSString *bits            = [NSString stringWithFormat:@"%@", @(mileage%10)];
        NSString *ten             = [NSString stringWithFormat:@"%@", @(mileage/10)];
        NSString *hundred         = [NSString stringWithFormat:@"%@", @(mileage/100)];
        NSString *thousand        = [NSString stringWithFormat:@"%@", @(mileage/1000)];
        NSString *tenThousand     = [NSString stringWithFormat:@"%@", @(mileage/10000)];
        NSString *hundredThousand = [NSString stringWithFormat:@"%@", @(mileage/100000)];
        
        numbers[BitsKey]            = bits;
        numbers[TenKey]             = [ten substringWithRange:(NSRange){ten.length -1, 1}];
        numbers[HundredKey]         = [hundred substringWithRange:(NSRange){hundred.length -1, 1}];
        numbers[ThousandKey]        = [thousand substringWithRange:(NSRange){thousand.length -1, 1}];
        numbers[TenThousandKey]     = [tenThousand substringWithRange:(NSRange){tenThousand.length -1, 1}];
        numbers[HundredThousandKey] = [hundredThousand substringWithRange:(NSRange){hundredThousand.length -1, 1}];
    }
    @catch (NSException *exception) {
        NSLog(@"Create Mileage Number Error:%@", exception.reason);
    }
    @finally {
        return numbers;
    }
}

@end
