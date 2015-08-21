//
//  SCViewController.h
//
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry/Masonry.h>
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "AllMicroConstants.h"
#import "SCAppApiRequest.h"
#import "SCUserInfo.h"
#import "SCStoryBoardManager.h"

typedef NS_ENUM(NSInteger, SCRequestRefreshType) {
    SCRequestRefreshTypeDropDown,
    SCRequestRefreshTypePullUp
};

typedef NS_ENUM(NSUInteger, SCViewControllerAlertType) {
    SCViewControllerAlertTypeNeedLogin = 1000
};

@interface UIViewController (SCViewController) <UIAlertViewDelegate, MBProgressHUDDelegate>

#pragma mark - Alert Methods
/**
 *  显示温馨提示警告框（警告框只有[确定]按钮）
 *
 *  @param message 提示信息
 */
- (void)showAlertWithMessage:(NSString *)message;

/**
 *  显示简单提示警告框（警告框只有[确定]按钮）
 *
 *  @param title   提示标题
 *  @param message 提示信息
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message;

/**
 *  提示用户登录的警告框
 */
- (void)showShoulLoginAlert;

/**
 *  提示用户登录的警告框
 *
 *  @param title 提示标题
 */
- (void)showShoulLoginAlertWithTitle:(NSString *)title;

/**
 *  根据登陆路径显示登陆提示
 *
 *  @param path 登陆路径
 */
- (void)showShoulLoginAlertWithPath:(SCLoginPath)path;

/**
 *  提示用户需要重新登录
 */
- (void)showShoulReLoginAlert;

/**
 *  检查用户是否需要登录，需要则跳转到登录页面
 */
- (void)checkShouldLogin;

/**
 *  显示警告框
 *
 *  @param title             警告框标题
 *  @param message           警告框消息
 *  @param delegate          警告框代理对象
 *  @param tag               警告框显示类型
 *  @param cancelButtonTitle 警告框取消按钮标题
 *  @param otherButtonTitle  警告框其他按钮标题
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)delegate
                       tag:(NSInteger)tag
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle;

#pragma mark - HUD Methods
- (void)showHUDOnViewController:(UIViewController *)viewController;
- (void)hideHUDOnViewController:(UIViewController *)viewController;

/**
 *  显示简单HUD提示（0.5s）
 *
 *  @param viewController 需要显示提示的View
 *  @param text           提示文本
 */
- (void)showHUDAlertToViewController:(UIViewController *)viewController
                                text:(NSString *)text;

/**
 *  显示简单HUD提示
 *
 *  @param viewController 需要显示提示的View
 *  @param text           提示文本
 *  @param delay          提示显示的时间
 */
- (void)showHUDAlertToViewController:(UIViewController *)viewController
                                text:(NSString *)text
                               delay:(NSTimeInterval)delay;

/**
 *  显示定制的HUD提示（显示类型请设置到tag，延时0.5s消失）
 *
 *  @param viewController 需要显示提示的View
 *  @param tag            HUD显示类型
 *  @param text           提示文本
 */
- (void)showHUDAlertToViewController:(UIViewController *)viewController
                                 tag:(NSInteger)tag
                                text:(NSString *)text;

/**
 *  显示定制的HUD提示（显示类型请设置到tag）
 *
 *  @param viewController 需要显示提示的View
 *  @param tag            HUD显示类型
 *  @param text           提示文本
 *  @param delay          提示显示的时间
 */
- (void)showHUDAlertToViewController:(UIViewController *)viewController
                                 tag:(NSInteger)tag
                                text:(NSString *)text
                               delay:(NSTimeInterval)delay;

/**
 *  显示简单HUD提示（可设置代理）
 *
 *  @param viewController 需要显示提示的View
 *  @param delegate       代理对象
 *  @param text           提示文本
 *  @param delay          提示显示的时间
 */
- (void)showHUDAlertToViewController:(UIViewController *)viewController
                            delegate:(id)delegate
                                text:(NSString *)text
                               delay:(NSTimeInterval)delay;

/**
 *  显示定制的等待HUD提示（显示类型请设置到tag）
 *
 *  @param viewController 需要显示提示的View
 *  @param tag            HUD显示类型
 *  @param text           提示文本
 *  @param delay          提示显示的时间
 */
- (void)showHUDPromptToViewController:(UIViewController *)viewController
                                  tag:(NSInteger)tag
                                 text:(NSString *)text
                                delay:(NSTimeInterval)delay;

- (void)hanleFailureResponseWtihOperation:(AFHTTPRequestOperation *)operation;

@end


@interface UITableView (SCTableView)

- (void)reLayoutHeaderView;
- (void)reLayoutFooterView;

@end
