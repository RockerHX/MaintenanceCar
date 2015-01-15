//
//  SCMainViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MicroCommon.h"
#import "BMapKit.h"
#import "SCLocationInfo.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"
#import "SCCarBrand.h"
#import "SCCarBrandDisplayModel.h"

@interface SCMainViewController () <BMKLocationServiceDelegate>
{
    BMKLocationService *_locationService;
}

@end

@implementation SCMainViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initConfig];
    [self startLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Methods
/**
 *  开启定位
 */
- (void)startLocation
{
    if (!_locationService)
    {
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        
        //初始化BMKLocationService
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
    }
    //启动LocationService
    [_locationService startUserLocationService];
}

#pragma mark - BMKLocationService Delegate Methods
// 当定位到用户的位置时，就会调用（调用的频率比较频繁）
// 实现相关delegate 处理位置信息更新
// 处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    SCLog(@"didUpdateUserHeading lat %f,long %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    SCLog(@"didUpdateUserLocation lat %f,long %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    [SCLocationInfo shareLocationInfo].userLocation = userLocation;
    [_locationService stopUserLocationService];
}

// 定位失败，设置相关操作
- (void)didFailToLocateUserWithError:(NSError *)error
{
    SCFailure(@"Location error:%@", error);
    [SCLocationInfo shareLocationInfo].userLocation = nil;
    [SCLocationInfo shareLocationInfo].locationFailure = YES;
}

#pragma mark - Private Methods
- (void)initConfig
{
    [self userLog];                         // 开启用户日志
    [self startUpdateCarBrandReuqest];      // 开始车辆品牌数据刷新
    
    // 监听登陆通知，收到通知会触发页面跳转方法
    [NOTIFICATION_CENTER addObserver:self selector:@selector(shouldLogin) name:kUserNeedLoginNotification object:nil];
}

/**
 *  记录用户数据 - 如果有用户登陆，获取数据返回给服务器，没有用户登陆则不管
 */
- (void)userLog
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (userInfo.loginStatus)
    {
        // 本地日志记录
        SCLog(@"登陆成功");
        SCLog(@"userID:%@", userInfo.userID);
        SCLog(@"phoneNmber:%@", userInfo.phoneNmber);
        
        // 获取用户设备数据，进行远程日志记录
        NSString *os = [UIDevice currentDevice].systemName;
        NSString *osVersion = [UIDevice currentDevice].systemVersion;
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *paramters = @{@"user_id": userInfo.userID,
                                    @"os": os,
                                    @"version": appVersion,
                                    @"os_version": osVersion};
        [[SCAPIRequest manager] startUserLogAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
            {
                SCLog(@"log_id:%@", responseObject[@"log_id"]);
            }
            else
            {
                SCLog(@"log error:%@", responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            SCLog(@"log error:%@", error);
        }];
    }
}

/**
 *  收到登陆通知，跳转到登陆页面
 */
- (void)shouldLogin
{
    @try {
        UINavigationController *loginViewNavigationController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCLoginViewNavigationController"];
        loginViewNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:loginViewNavigationController animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        SCException(@"Go to the SCLoginViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

/**
 *  车辆品牌数据同步
 */
- (void)startUpdateCarBrandReuqest
{
    [SCCarBrandDisplayModel share];
}

#pragma mark - Public Methods

@end
