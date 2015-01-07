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
#define STORY_BOARD(Name)                   [UIStoryboard storyboardWithName:Name bundle:nil]
#define NOTIFICATION_CENTER                 [NSNotificationCenter defaultCenter]


#pragma mark - APP Custom Common Define
#pragma mark -
#define UMengAPPKEY                     @"54995e36fd98c5b910000cc6"     // 友盟SDK对应的APPKEY
#define BaiDuMapKEY                     @"RzgQD0OsEmWp9LdMGFUR66f5"     // 百度地图SDK对应的APPKEY

#define MerchantListLimit               20                              // 商户列表搜索返回结果条数限制
#define MerchantListRadius              10                              // 商户列表搜索半径, 用于搜索距离当前位置多少公里范围内的商户. 单位公里(千米)

#define VerificationCodeTimeExpire      1                               // 验证码过期时间，单位为分钟

#define Zero                            0


#define MerchantDetailViewControllerStoryBoardID    @"SCMerchantDetailViewController"
#define ReservationViewControllerStoryBoardID       @"SCReservationViewController"
#define MerchantCellReuseIdentifier                 @"MerchantCellReuseIdentifier"

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)       // 获取屏幕宽度
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)      // 获取屏幕高度

// 通过十六进制的rgb值来返回一个UIColor实例
#define UIColorFromRGB(rgbHexValue)     [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbHexValue & 0xFF))/255.0f alpha:1.0f]
// 通过R,G,B,A四个原生值来返回一个UIColor实例
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#endif


#pragma mark - Notification Name Define
#pragma mark -
#define kUserNeedLoginNotification                  @"kUserNeedLoginNotification"               // 需要用户的通知，收到此通知，会跳转到登陆页面
#define kMerchantListReservationNotification        @"kMerchantListReservationNotification"     // 商户列表内[预约]按钮点击触发的通知 - 用于传递tag，得到所点击按钮是位于列表内的index
#define kMerchantDtailReservationNotification       @"kMerchantDtailReservationNotification"    // 商户详情内[预约]按钮点击触发的通知 - 用于传递tag，得到所点击按钮是位于列表内的index


#pragma mark - Define Methods
#pragma mark -
#define ShowPromptHUDWithText(view, text, delay)          ({MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];hud.mode = MBProgressHUDModeText;hud.yOffset = SCREEN_HEIGHT/2 - 100.0f;hud.margin = 10.f;hud.labelText = text;hud.removeFromSuperViewOnHide = YES;[hud hide:YES afterDelay:delay];})


#pragma mark - Debug Define
#pragma mark -
#ifdef DEBUG

#define DEBUG_SCLOG             NO                              // 日志输出开关
#define DEBUG_FAILURE           NO                              // 错误输出开关
#define DEBUG_SCEXCEPTION       YES                             // 异常输出开关

#define SCLog(fmt, ...)         if(DEBUG_SCLOG){NSLog( @"%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);}           // 日志输出宏
#define SCFailure(fmt, ...)     if(DEBUG_FAILURE){NSLog( @"%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);}         // 错误输出宏
#define SCException(fmt, ...)   if(DEBUG_SCEXCEPTION){NSLog( @"%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);}     // 异常输出宏

#endif