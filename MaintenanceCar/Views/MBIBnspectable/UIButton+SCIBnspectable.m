//
//  UIButton+SCIBnspectable.m
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "UIButton+SCIBnspectable.h"
#import "SCIBnsepectableManager.h"

@implementation UIButton (SCIBnspectable)

- (void)setTitleHexColor:(NSString *)titleHexColor
{
    [self setTitleColor:[SCIBnsepectableManager colorWithRGBHexString:titleHexColor] forState:UIControlStateNormal];
}

- (NSString *)titleHexColor
{
    return @"0xffffff";
}

@end
