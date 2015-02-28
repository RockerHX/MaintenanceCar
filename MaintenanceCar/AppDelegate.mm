//
//  AppDelegate.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "AppDelegate.h"
#import "MicroCommon.h"
#import <UMengAnalytics/MobClick.h>
#import "UMFeedback.h"
#import "BMapKit.h"
#import "UMessage.h"
#import "SCUserInfo.h"

@interface AppDelegate ()
{
    BMKMapManager *_mapManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // 设置导航条和电池条颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:APPColor];
    [[UITabBar appearance] setSelectedImageTintColor:APPColor];
    
    // 设置导航条字体颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(245.0f, 245.0f, 245.0f, 1.0f),
                                                                      NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0f]}];
    
#pragma mark UMeng Analytics SDK
    // 启用[友盟反馈]
    [UMFeedback setAppkey:UMengAPPKEY];
    // 启动[友盟统计]，采用启动发送的方式 - BATCH
    [MobClick startWithAppkey:UMengAPPKEY reportPolicy:BATCH channelId:@"version:1.1.1 - test"];
    // 设置版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick checkUpdate];         // 集成友盟更新
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UMengAPPKEY launchOptions:launchOptions];
    
    //register remoteNotification types
    if (IS_IOS7)
    {
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                     UIRemoteNotificationTypeSound|
                                                     UIRemoteNotificationTypeAlert];
    }
    else if (IS_IOS8)
    {
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
    if (!userInfo.addAliasSuccess && userInfo.loginStatus)
    {
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
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"%s", __FUNCTION__);
}

@end
