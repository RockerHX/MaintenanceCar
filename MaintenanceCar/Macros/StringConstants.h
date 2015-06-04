//
//  StringConstant.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Third SDK Key
FOUNDATION_EXPORT NSString *const UMengAPPKEY;              // 友盟SDK对应的APPKEY
FOUNDATION_EXPORT NSString *const BaiDuMapKEY;              // 百度地图SDK对应的APPKEY
FOUNDATION_EXPORT NSString *const WeiXinKEY;                // 微信SDK对应的APPKEY

#pragma mark - Notification Name
FOUNDATION_EXPORT NSString *const kUserCarsDataNeedReloadSuccessNotification;       // 用户车辆数据加载成功的通知
FOUNDATION_EXPORT NSString *const kUserNeedLoginNotification;                       // 需要用户的通知，收到此通知，会跳转到登录页面
FOUNDATION_EXPORT NSString *const kUserLoginSuccessNotification;                    // 用户登录成功的通知，用于登录成功之后通知对应页面刷新数据
FOUNDATION_EXPORT NSString *const kWeiXinPaySuccessNotification;                    // 微信支付成功的通知
FOUNDATION_EXPORT NSString *const kWeiXinPayFailureNotification;                    // 微信支付失败的通知
FOUNDATION_EXPORT NSString *const kShowTicketNotification;                          // 查看团购券的通知

#pragma mark - App Custom Constant
FOUNDATION_EXPORT NSString *const MerchantCellReuseIdentifier;

FOUNDATION_EXPORT NSString *const DisplayNameKey;
FOUNDATION_EXPORT NSString *const RequestValueKey;

FOUNDATION_EXPORT NSString *const MerchantDetailViewControllerStoryBoardID;