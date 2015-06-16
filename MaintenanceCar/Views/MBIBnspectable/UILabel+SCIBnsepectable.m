//
//  UILabel+SCIBnsepectable.m
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "UILabel+SCIBnsepectable.h"
#import "SCIBnsepectableManager.h"

@implementation UILabel (SCIBnsepectable)

- (void)setTextHexColor:(NSString *)textHexColor
{
    self.textColor = [SCIBnsepectableManager colorWithRGBHexString:textHexColor];
}

- (NSString *)textHexColor
{
    return @"0xffffff";
}

@end
