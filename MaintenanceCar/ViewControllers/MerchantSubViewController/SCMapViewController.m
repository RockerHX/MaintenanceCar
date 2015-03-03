//
//  SCMapViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMapViewController.h"
#import "SCLocationManager.h"
#import "SCMerchant.h"
#import "SCMapMerchantInfoView.h"
#import "SCMerchantDetailViewController.h"

#define MAP_REFRESH_TIME_INTERVAL   5.0f

@interface SCMapViewController () <BMKMapViewDelegate, SCMapMerchantInfoViewDelegate>
{
    NSMutableArray    *_annotations;            // 商家图钉数据集合
    SCMerchant        *_merchant;               // 当前点击商家的数据缓存
    BMKAnnotationView *_preAnnotationView;      // 地图图钉缓存
    
    NSTimer           *_timer;
    CGFloat           _zoomLevel;
    BMKCoordinateRegion _coordinateRegion;
}

@end

@implementation SCMapViewController

- (void)awakeFromNib
{
    _showInfoView = YES;
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商家] - 地图"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商家] - 地图"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
- (IBAction)listItemPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter Methods
- (void)setMerchants:(NSArray *)merchants
{
    _merchants = merchants;
    if (!_annotations)
        _annotations = [@[] mutableCopy];
    
    // 根据传入的商家数据，生成商家图钉需要的数据并添加到商家图钉集合(_annotations)
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
    BMKPointAnnotation *annotation = [_annotations lastObject];
    _coordinateRegion = [self getRegionWithLatitude:annotation.coordinate.latitude
                                          longitude:annotation.coordinate.longitude
                                             center:[SCLocationManager share].userLocation.location.coordinate];
}

#pragma mark - Private Methods
- (void)initConfig
{
    // 配置百度地图
    _mapView.frame             = self.view.bounds;          // 全屏显示
    _mapView.delegate          = self;                      // 设置百度地图代理
    _mapView.buildingsEnabled  = YES;                       // 允许双指上下滑动展示3D建筑
    _mapView.showsUserLocation = YES;                       // 显示定位图层
    _mapView.userTrackingMode  = BMKUserTrackingModeFollow; // 定位跟随模式
    [_mapView setRegion:_coordinateRegion animated:NO];
    
    if (!_showInfoView)
    {
        _mapMerchantInfoView.hidden   = YES;
        self.navigationItem.leftBarButtonItem = _leftItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        _mapMerchantInfoView.delegate = self;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:MAP_REFRESH_TIME_INTERVAL target:self selector:@selector(displayUserLocation) userInfo:nil repeats:YES];
}

- (void)viewConfig
{
    [_mapView updateLocationData:[SCLocationManager share].userLocation];   // 根据坐标在地图上显示位置
    [_mapView addAnnotations:_annotations];                                 // 把所有的商家图钉都显示到地图上
    
    // 进入地图的显示列表内第一个商家的数据
    [_mapView selectAnnotation:[_annotations firstObject] animated:YES];
    [_mapMerchantInfoView handelWithMerchant:[_merchants firstObject]];
}

- (BMKCoordinateRegion)getRegionWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude center:(CLLocationCoordinate2D)center
{
    BMKCoordinateRegion region = (BMKCoordinateRegion){};
    region.center              = center;
    region.span.latitudeDelta  = fabs(center.latitude - latitude)*2.03f;
    region.span.longitudeDelta = fabs(center.longitude - longitude)*2.03f;
    
    return region;
}

- (void)displayUserLocation
{
    __weak typeof(self)weakSelf = self;
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        [weakSelf.mapView updateLocationData:userLocation];     // 根据坐标在地图上显示位置
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        ShowPromptHUDWithText(weakSelf.view, @"定位失败，请检查您的定位服务是否打开：设置->隐私->定位服务", 0.5f);
    }];
}

#pragma mark - BMKMapView Delegate Methods
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView selectAnnotation:view.annotation animated:YES];
    _preAnnotationView.image = [UIImage imageNamed:@"map-red"];
    view.image = [UIImage imageNamed:@"map-blue"];
    // 刷新商家数据
    for (SCMerchant *merchant in _merchants)
    {
        if ([view.annotation.title isEqualToString:merchant.name])
        {
            [_mapMerchantInfoView handelWithMerchant:merchant];
            _merchant = merchant;
            break;
        }
    }
    _preAnnotationView = view;
}

#pragma mark - SCMapMerchantInfoViewDelegate Methods
- (void)shouldShowMerchantDetail
{
    if (_showInfoView)
    {
        // 跳转到预约页面
        @try {
            SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
            merchantDetialViewControler.merchant = _merchant;
            [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCMapViewController Go to the SCMerchantDetailViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
}

@end
