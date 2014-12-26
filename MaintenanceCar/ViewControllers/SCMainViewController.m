//
//  SCMainViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMainViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SCAPIRequest.h"
#import "SCWeather.h"

@interface SCMainViewController ()

@end

@implementation SCMainViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self startWeatherReuqest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
