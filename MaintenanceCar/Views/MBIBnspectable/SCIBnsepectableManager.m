//
//  SCIBnsepectableManager.m
//
//  Created by ShiCang on 15/6/16.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCIBnsepectableManager.h"

@implementation SCIBnsepectableManager

+ (UIColor *)colorWithRGBHexString:(NSString *)hex
{
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum])
        return nil;
    return [SCIBnsepectableManager colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end
