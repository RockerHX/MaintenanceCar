//
//  SCView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface UIView (SCView)

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
