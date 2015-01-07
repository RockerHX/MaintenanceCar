//
//  SCMapViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMapViewController.h"
#import "SCLocationInfo.h"
#import "SCMerchant.h"
#import "MicroCommon.h"
#import "SCMapMerchantInfoView.h"

@interface SCMapViewController () <BMKMapViewDelegate>
{
    NSMutableArray *_annotations;       // 商户图钉数据集合
}

@end

@implementation SCMapViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
#pragma mark -
- (IBAction)listItemPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter Methods
#pragma mark -
- (void)setMerchants:(NSArray *)merchants
{
    if (!_annotations)
    {
        _annotations = [@[] mutableCopy];
    }
    
    // 根据传入的商户数据，生成商户图钉需要的数据并添加到商户图钉集合(_annotations)
    [merchants enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SCMerchant *merchant = obj;
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = [merchant.latitude doubleValue];
        coor.longitude = [merchant.longtitude doubleValue];
        annotation.coordinate = coor;
        annotation.title = merchant.name;
        [_annotations addObject:annotation];
    }];
    _merchants = merchants;
}

#pragma mark - Private Methods
#pragma mark -
- (void)viewConfig
{
    // 配置百度地图
    _mapView.frame = self.view.bounds;                      // 全屏显示
    _mapView.delegate = self;                               // 设置百度地图代理
    _mapView.buildingsEnabled = YES;                        // 允许双指上下滑动展示3D建筑
    _mapView.showsUserLocation = YES;                       // 显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;  // 定位跟随模式
    _mapView.zoomLevel = 15.0f;                             // 比例尺为：500米
    [_mapView updateLocationData:[SCLocationInfo shareLocationInfo].userLocation];      // 根据坐标在地图上显示位置
    
    [_mapView addAnnotations:_annotations];                 // 把所有的商户图钉都显示到地图上
    
    // 进入地图的显示列表内第一个商户的数据
    @try {
        [_mapView selectAnnotation:_annotations[0] animated:YES];
        
        SCMerchant *merchant = _merchants[0];
        _mapMerchantInfoView.merchantNameLabel.text = merchant.name;
        _mapMerchantInfoView.distanceLabel.text = merchant.distance;
    }
    @catch (NSException *exception) {
        SCException(@"Select Annotation Error:%@", exception.reason);
        _mapMerchantInfoView.hidden = YES;
    }
    @finally {
        
    }
}

#pragma mark - BMKMapView Delegate Methods
#pragma mark -
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    // 刷新商户数据
    for (SCMerchant *merchant in _merchants)
    {
        if ([view.annotation.title isEqualToString:merchant.name])
        {
            _mapMerchantInfoView.merchantNameLabel.text = merchant.name;
            _mapMerchantInfoView.distanceLabel.text = merchant.distance;
        }
    }
    
    ;
}

@end
