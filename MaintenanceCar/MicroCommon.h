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


#define CURRENT_SYSTEM_VERSION              [[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS5                             ((CURRENT_SYSTEM_VERSION >= 5.0f && CURRENT_SYSTEM_VERSION < 6.0f) ? YES : NO)
#define IS_IOS6                             ((CURRENT_SYSTEM_VERSION >= 6.0f && CURRENT_SYSTEM_VERSION < 7.0f) ? YES : NO)
#define IS_IOS7                             ((CURRENT_SYSTEM_VERSION >= 7.0f && CURRENT_SYSTEM_VERSION < 8.0f) ? YES : NO)
#define IS_IOS8                             ((CURRENT_SYSTEM_VERSION >= 8.0f) ? YES : NO)

#define IS_WIDESCREEN_4                     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < __DBL_EPSILON__)
#define IS_WIDESCREEN_5                     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6                     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6Plus                 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < __DBL_EPSILON__)
#define IS_IPHONE                           ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone"] || [[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"])
#define IS_IPOD                             ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"])
#define IS_IPHONE_4                         (IS_IPHONE && IS_WIDESCREEN_4)
#define IS_IPHONE_5_PRIOR                   (IS_IPHONE && (IS_WIDESCREEN_5 || IS_WIDESCREEN_4))
#define IS_IPHONE_5                         (IS_IPHONE && IS_WIDESCREEN_5)
#define IS_IPHONE_6                         (IS_IPHONE && IS_WIDESCREEN_6)
#define IS_IPHONE_6Plus                     (IS_IPHONE && IS_WIDESCREEN_6Plus)

#pragma mark - APP Custom Common Define
#pragma mark -
#define UMengAPPKEY                     @"54995e36fd98c5b910000cc6"     // 友盟SDK对应的APPKEY
#define BaiDuMapKEY                     @"wNZGKBVyuCobA8GcksWWx9xD"     // 百度地图SDK对应的APPKEY
#define WeiXinKEY                       @"wx6194bafa9ae065cc"           // 微信SDK对应的APPKEY

#define MerchantListLimit               10                              // 商家列表搜索返回结果条数限制
#define MerchantListRadius              @"100"                          // 商家列表搜索半径, 用于搜索距离当前位置多少公里范围内的商家. 单位公里(千米)

#define VerificationCodeTimeExpire      1                               // 验证码过期时间，单位为分钟


#define MerchantDetailViewControllerStoryBoardID    @"SCMerchantDetailViewController"
#define ReservationViewControllerStoryBoardID       @"SCReservationViewController"
#define MerchantCellReuseIdentifier                 @"SCMerchantTableViewCell"

#define DisplayNameKey                  @"DisplayName"
#define RequestValueKey                 @"RequestValue"

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)       // 获取屏幕宽度
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)      // 获取屏幕高度

#define Zero                            0
#define DOT_COORDINATE                  0.0f        // 原点值
#define STATUS_BAR_HEIGHT               20.0f       // 电池条固定高度
#define BAR_ITEM_WIDTH_HEIGHT           30.0f       // BarItem固定高度
#define NAVIGATION_BAR_HEIGHT           44.0f       // 导航条(NavigationBar)固定高度
#define TAB_TAB_HEIGHT                  49.0f       // Tabbar固定高度

// 通过十六进制的rgb值来返回一个UIColor实例
#define UIColorFromRGB(rgbHexValue)     [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbHexValue & 0xFF))/255.0f alpha:1.0f]
// 通过R,G,B,A四个原生值来返回一个UIColor实例
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#endif


#pragma mark - Notification Name Define
#pragma mark -
#define kUserNeedLoginNotification                  @"kUserNeedLoginNotification"               // 需要用户的通知，收到此通知，会跳转到登录页面
#define kUserLoginSuccessNotification               @"kUserLoginSuccessNotification"            // 用户登录成功的通知，用于登录成功之后通知对应页面刷新数据
#define kMaintenanceReservationNotification         @"kMaintenanceReservationNotification"      // 保养页面内[预约]按钮点击触发的通知 - 用于传递tag，得到所点击按钮是位于列表内的index
#define kMerchantDtailReservationNotification       @"kMerchantDtailReservationNotification"    // 商家详情内[预约]按钮点击触发的通知 - 用于传递tag，得到所点击按钮是位于列表内的index
#define kWeiXinPaySuccessNotification               @"kWeiXinPaySuccessNotification"            // 微信支付成功的通知
#define kWeiXinPayFailureNotification               @"kWeiXinPayFailureNotification"            // 微信支付失败的通知
#define kGenerateCouponSuccessNotification          @"kGenerateCouponSuccessNotification"       // 生成团购券成功的通知


#pragma mark - Define Methods
#pragma mark -
#define ShowPromptHUDWithText(view, text, delay)          ({\
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];\
hud.mode = MBProgressHUDModeText;\
hud.yOffset = SCREEN_HEIGHT/2 - 100.0f;\
hud.margin = 10.f;\
hud.labelText = text;\
hud.removeFromSuperViewOnHide = YES;\
[hud hide:YES afterDelay:delay];\
})

#define ThemeColor        UIColorWithRGBA(44.0f, 124.0f, 185.0f, 1.0f)


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