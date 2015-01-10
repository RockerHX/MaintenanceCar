//
//  SCHomePageViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCHomePageViewController.h"
#import <UMengAnalytics/MobClick.h>
#import "SCAPIRequest.h"
#import "SCWeather.h"

@interface SCHomePageViewController ()

@end

@implementation SCHomePageViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[首页] - 首页"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页] - 首页"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
