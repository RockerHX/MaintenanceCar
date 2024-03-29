//
//  AppDelegate.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "AppDelegate.h"
//#import <AFNetworking/UIKit+AFNetworking.h>
//#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <BaiduMapAPI/BMapKit.h>
#import <UMengMessage/UMessage.h>
#import <UMengFeedback/UMFeedback.h>
#import <UMengFeedback/UMOpus.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import <Weixin/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "AllMicroConstants.h"
#import "SCUserInfo.h"

@interface AppDelegate () <WXApiDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#pragma mark 网络日志
    //    [[AFNetworkActivityLogger sharedLogger] startLogging];
    //    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // 设置导航条和电池条颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:ThemeColor];
    [[UITabBar appearance] setSelectedImageTintColor:ThemeColor];
    
    // 设置导航条字体颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(245.0f, 245.0f, 245.0f, 1.0f),
                                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0f]}];
    
    NSString *appVersion = [SCVersion appVersion];
#pragma mark UMeng Analytics SDK
    // 启用[友盟反馈]
    [UMFeedback setAppkey:UMengAPPKEY];
    [UMOpus setAudioEnable:YES];
    // 设置版本号
    [MobClick setAppVersion:appVersion];
    [MobClick checkUpdate];                 // 集成友盟更新
    
    // 启动[友盟统计]，采用启动发送的方式 - BATCH
    //    [MobClick startWithAppkey:UMengAPPKEY reportPolicy:BATCH channelId:[NSString stringWithFormat:@"AppStore:%@", appVersion]];
#warning @"发布时更改测试统计"
    [MobClick startWithAppkey:UMengAPPKEY reportPolicy:BATCH channelId:[NSString stringWithFormat:@"TestVersion:%@", appVersion]];
    [MobClick setEncryptEnabled:YES];       // 日志加密
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UMengAPPKEY launchOptions:launchOptions];
    //register remoteNotification types
    SCSystemVersion systemVersion = [SCVersion systemVersion];
    if (systemVersion == SCSystemVersionIOS7) {
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
         UIRemoteNotificationTypeSound|
         UIRemoteNotificationTypeAlert];
    } else if (systemVersion == SCSystemVersionIOS8) {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;                        //当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;                        //当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;                                                       //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";                                                        //这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|
                                                    UIUserNotificationTypeSound|
                                                    UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
    //for log（optional）
    [UMessage setLogEnabled:YES];
    
    SCUserInfo *userInfo = [SCUserInfo share];
    if (!userInfo.addAliasSuccess && userInfo.loginState) {
        [UMessage addAlias:userInfo.phoneNmber type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
            if ([responseObject[@"success"] isEqualToString:@"ok"])
                [SCUserInfo share].addAliasSuccess = YES;
        }];
    }
    
#pragma mark - Baidu Map SDK
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:BaiDuMapKEY generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
#pragma mark - WeiXin SDK
    [WXApi registerApp:WeiXinKEY];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];    //当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];     //当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    NSLog(@"%s:%@", __FUNCTION__, userInfo);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@", resultDic);
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - Wei Xin Pay Delegate Methods
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [NOTIFICATION_CENTER postNotificationName:kWeiXinPaySuccessNotification object:nil];
            }
                break;
            default: {
                [NOTIFICATION_CENTER postNotificationName:kWeiXinPayFailureNotification object:nil];
            }
                break;
        }
    }
}

@end
