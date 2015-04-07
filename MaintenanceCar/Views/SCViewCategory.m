//
//  SCView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewCategory.h"
#import "UIConstants.h"

@implementation UIView (SCView)

#pragma mark - Public Methods

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
