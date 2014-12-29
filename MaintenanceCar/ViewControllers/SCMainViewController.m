//
//  SCMainViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMainViewController.h"
#import "MicroCommon.h"
#import <CoreLocation/CoreLocation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "SCAPIRequest.h"
#import "SCWeather.h"
#import "SCLocationInfo.h"

@interface SCMainViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong)   CLLocationManager *locationManager;

@end

@implementation SCMainViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self startWeatherReuqest];
    
    [self startLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Methods
#pragma mark -
- (void)startLocation
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //每隔多少米定位一次（这里的设置为任何的移动）
        _locationManager.distanceFilter = 50.0f;                                    // 设置移动位置50米更新一次
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;     // 精准度设置为10米
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled])
    {
        [_locationManager startUpdatingLocation];                                   // 开始定位用户的位置
    }
    else
    {
        //不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
    }
}

#pragma mark - CoreLocation Delegate Methods
#pragma mark -
/**
 *  当定位到用户的位置时，就会调用（调用的频率比较频繁）
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    CLLocation *loction = [locations firstObject];
    [SCLocationInfo shareLocationInfo].location = loction;
    
    //维度：loction.coordinate.latitude
    //经度：loction.coordinate.longitude
    SCLog(@"latitude=%f，longitude=%f", loction.coordinate.latitude, loction.coordinate.longitude);
    
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    SCError(@"Location error:%@", error);
}

#pragma mark - Private Methods
#pragma mark -
- (void)startWeatherReuqest
{
    [[SCAPIRequest manager] startWearthAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSError *error = nil;
        SCWeather *weather = [[SCWeather alloc] initWithDictionary:responseObject error:&error];
        NSLog(@"weather model parse error:%@", error);
        NSLog(@"title:%@", weather.title);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Public Methods
#pragma mark -

@end
