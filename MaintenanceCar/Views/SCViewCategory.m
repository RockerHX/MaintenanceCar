//
//  SCView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewCategory.h"

#define SELF_WIDTH        (self.frame.size.width)       // 获取屏幕宽度
#define SELF_HEIGHT       (self.frame.size.height)      // 获取屏幕高度

@implementation UIView (SCView)

#pragma mark - Public Methods
#pragma mark - Frame Methods
- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)point
{
    self.frame = CGRectMake(point.x, point.y, SELF_WIDTH, SELF_HEIGHT);
}

- (CGSize)size
{
    return self.frame.size;
}
- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat)x
{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)height
{
    return SELF_HEIGHT;
}
- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)width
{
    return SELF_WIDTH;
}
- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)tail
{
    return self.y + self.height;
}
- (void)setTail:(CGFloat)tail
{
    self.frame = CGRectMake(self.x, tail - self.height, self.width, self.height);
}

- (CGFloat)bottom
{
    return self.tail;
}
- (void)setBottom:(CGFloat)bottom
{
    [self setTail:bottom];
}

- (CGFloat)right
{
    return self.x + self.width;
}
- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}

#pragma mark - HUD Methods
- (void)showHUD
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

- (void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

- (void)showHUDAlertWithText:(NSString *)text
                       delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = SCREEN_HEIGHT/2 - 100.0f;
    hud.margin = 10.0f;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

@end
