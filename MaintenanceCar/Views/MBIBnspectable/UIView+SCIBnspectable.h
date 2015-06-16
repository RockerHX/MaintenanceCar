//
//  UIView+SCIBnspectable.h
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import <UIKit/UIKit.h>

// If you want to renders that should copy this define to you custom view class
//IB_DESIGNABLE
@interface UIView (SCIBnspectable)

// Basic
@property (assign, nonatomic) IBInspectable      BOOL  masksToBounds;
@property (assign, nonatomic) IBInspectable NSInteger  cornerRadius;
@property (assign, nonatomic) IBInspectable  NSString *hexRGBColor;

// Border
@property (assign, nonatomic) IBInspectable NSInteger  borderWidth;
@property (strong, nonatomic) IBInspectable   UIColor *borderColor;
@property (strong, nonatomic) IBInspectable  NSString *borderHexRGBColor;

//// Shadow
//@property (assign, nonatomic) IBInspectable   CGSize  shadowOffset;
//@property (assign, nonatomic) IBInspectable  CGFloat  shadowOpacity;
//@property (assign, nonatomic) IBInspectable  CGFloat  shadowRadius;
//@property (strong, nonatomic) IBInspectable  UIColor *shadowColor;
//@property (strong, nonatomic) IBInspectable NSString *shadowHexRGBColor;

@end
