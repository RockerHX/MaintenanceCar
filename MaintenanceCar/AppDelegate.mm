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
#import "WXApi.h"
#import "SCUserInfo.h"

@interface AppDelegate () <WXApiDelegate>
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
    // 设置版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick checkUpdate];         // 集成友盟更新
    
    // 启动[友盟统计]，采用启动发送的方式 - BATCH
//    [MobClick startWithAppkey:UMengAPPKEY reportPolicy:BATCH channelId:[NSString stringWithFormat:@"AppStore:%@", version]];
#warning @"发布时更改测试统计"
    [MobClick startWithAppkey:UMengAPPKEY reportPolicy:BATCH channelId:[NSString stringWithFormat:@"TestVersion:%@", version]];
    
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
    
#pragma mark - WeiXin SDK
#warning @"微信SDK"只支持真机调试
    [WXApi registerApp:WeiXinKEY];
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
#warning @"微信SDK"只支持真机调试
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
#warning @"微信SDK"只支持真机调试
    return  [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - Wei Xin Pay Delegate Methods
#warning @"微信SDK"只支持真机调试
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功， retcode=%d",resp.errCode);
                NSLog(@"支付成功， type=%d",resp.type);
                NSLog(@"支付成功， errStr=%@",resp.errStr);
                NSLog(@"支付成功， returnKey=%@",response.returnKey);
            }
                break;
            default:
            {
                NSLog(@"支付失败， retcode=%d",resp.errCode);
                NSLog(@"支付失败， type=%d",resp.type);
                NSLog(@"支付失败， errStr=%@",resp.errStr);
                NSLog(@"支付失败， returnKey=%@",response.returnKey);
            }
                break;
        }
    }
}

@end
