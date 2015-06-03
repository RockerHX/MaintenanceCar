//
//  SCView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIConstants.h"

#define SHADOW_OFFSET   0.5f
#define SELF_WIDTH        (self.frame.size.width)       // 获取屏幕宽度
#define SELF_HEIGHT       (self.frame.size.height)      // 获取屏幕高度

@interface UIView (SCView)

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)point;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)tail;
- (void)setTail:(CGFloat)tail;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

- (void)showHUD;
- (void)hideHUD;

/**
 *  显示简单HUD提示
 *
 *  @param text           提示文本
 *  @param delay          提示显示的时间
 */
- (void)showHUDAlertWithText:(NSString *)text
                       delay:(NSTimeInterval)delay;

@end
