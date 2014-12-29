//
//  MicroCommon.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/24.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#ifndef MaintenanceCar_MicroCommon_h
#define MaintenanceCar_MicroCommon_h

#pragma mark - System Framework Singleton Define
#define mark -
#define APP_DELEGATE_INSTANCE               ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define USER_DEFAULT                        [NSUserDefaults standardUserDefaults]
#define MAIN_STORY_BOARD(Name)              [UIStoryboard storyboardWithName:Name bundle:nil]
#define NS_NOTIFICATION_CENTER              [NSNotificationCenter defaultCenter]


#pragma mark - APP Custom Common Define
#pragma mark -
#define UMengAPPKEY             @"54995e36fd98c5b910000cc6"     // 友盟SDK对应的APPKey

#define MerchantListLimit       20                              // 商户列表搜索返回结果条数限制
#define MerchantListRadius      10                              // 商户列表搜索半径, 用于搜索距离当前位置多少公里范围内的商户. 单位公里(千米)

#endif


#pragma mark - Notification Key Define
#pragma mark -
#define kMerchantListReservationNotification        @"kMerchantListReservationNotification"     // 商户列表内[预约]按钮点击触发的通知 - 用于传递tag，得到所点击按钮是位于列表内的index

#pragma mark - Debug Define
#pragma mark -
#ifdef DEBUG

#define DEBUG_SCLOG             NO                              // 日志输出开关
#define DEBUG_SCERROR           NO                              // 错误输出开关
#define DEBUG_SCEXCEPTION       YES                             // 异常输出开关

#define SCLog(fmt, ...)         if(DEBUG_SCLOG){NSLog( @"%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);}           // 日志输出宏
#define SCError(fmt, ...)       if(DEBUG_SCERROR){NSLog( @"%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);}         // 错误输出宏
#define SCException(fmt, ...)   if(DEBUG_SCEXCEPTION){NSLog( @"%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);}     // 异常输出宏

#endif