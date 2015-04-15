//
//  SCViewController.h
//
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCViewControllerCategory.h"

#define HUDDelay        0.5f

@implementation UIViewController (SCViewController)

#pragma mark - Public Methods
#pragma mark -
#pragma mark - Alert Methods
- (void)showAlertWithMessage:(NSString *)message
{
    [self showAlertWithTitle:@"温馨提示" message:message];
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
{
    [self showAlertWithTitle:title
                     message:message
                    delegate:nil
                         tag:Zero
           cancelButtonTitle:@"确定"
            otherButtonTitle:nil];
}

- (void)showShoulLoginAlert
{
    [self showAlertWithTitle:@"您还没有登录"
                     message:nil
                    delegate:self
                         tag:Zero
           cancelButtonTitle:@"取消"
            otherButtonTitle:@"登录"];
}

- (void)checkShouldLogin
{
    if (![SCUserInfo share].loginStatus)
        [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)delegate
                       tag:(NSInteger)tag
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitle, nil];
    alertView.tag = tag;
    [alertView show];
}

#pragma mark - HUD Methods
- (void)showHUDOnViewController:(UIViewController *)viewController
{
    [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
}

- (void)hideHUDOnViewController:(UIViewController *)viewController
{
    [MBProgressHUD hideAllHUDsForView:viewController.view animated:YES];
}

- (void)showHUDAlertToViewController:(UIViewController *)viewController
                                text:(NSString *)text
{
    [self showHUDAlertToViewController:viewController text:text delay:HUDDelay];
}

- (void)showHUDAlertToViewController:(UIViewController *)viewController
                                text:(NSString *)text
                               delay:(NSTimeInterval)delay
{
    [self showHUDAlertToViewController:viewController delegate:nil text:text delay:delay];
}

- (void)showHUDAlertToViewController:(UIViewController *)viewController
                                 tag:(NSInteger)tag
                                text:(NSString *)text
{
    [self showHUDAlertToViewController:viewController tag:tag text:text delay:HUDDelay];
}

- (void)showHUDAlertToViewController:(UIViewController *)viewController
                                 tag:(NSInteger)tag
                                text:(NSString *)text
                               delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self showTextHUDToViewController:viewController text:text];
    hud.delegate       = self;
    hud.tag            = tag;
    [hud hide:YES afterDelay:delay];
}

- (void)showHUDAlertToViewController:(UIViewController *)viewController
                            delegate:(id)delegate
                                text:(NSString *)text
                               delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self showTextHUDToViewController:viewController text:text];
    hud.delegate       = delegate;
    [hud hide:YES afterDelay:delay];
}

- (void)showHUDPromptToViewController:(UIViewController *)viewController
                                  tag:(NSInteger)tag
                                 text:(NSString *)text
                                delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self showHUDToViewController:viewController text:text];
    hud.delegate       = self;
    hud.mode           = MBProgressHUDModeIndeterminate;
    [hud hide:YES afterDelay:delay];
}

#pragma mark - Private Methods
#pragma mark -
- (MBProgressHUD *)showHUDToViewController:(UIViewController *)viewController
                                      text:(NSString *)text
{
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    hud.labelText                 = text;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

- (MBProgressHUD *)showTextHUDToViewController:(UIViewController *)viewController
                                      text:(NSString *)text
{
    MBProgressHUD *hud = [self showHUDToViewController:viewController text:text];
    hud.mode           = MBProgressHUDModeText;
    hud.yOffset        = SCREEN_HEIGHT/2 - 100.0f;
    hud.margin         = 10.0f;
    return hud;
}

@end


@implementation UITableView (SCTableView)

#pragma mark - Public Methods
#pragma mark -
- (void)reLayoutHeaderView
{
    if (IS_IPHONE_6)
        self.tableHeaderView.frame = CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 281.25f);
    else if (IS_IPHONE_6Plus)
        self.tableHeaderView.frame = CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 300.0f);
    [self.tableHeaderView needsUpdateConstraints];
    [self.tableHeaderView layoutIfNeeded];
}

- (void)reLayoutFooterView
{
    if (IS_IPHONE_6)
        self.tableFooterView.frame = CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 180.0f);
    else if (IS_IPHONE_6Plus)
        self.tableFooterView.frame = CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 200.0f);
    [self.tableHeaderView needsUpdateConstraints];
    [self.tableHeaderView layoutIfNeeded];
}

@end
