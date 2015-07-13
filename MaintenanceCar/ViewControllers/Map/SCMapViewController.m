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
#import "GPSTransform.h"

#define MAP_REFRESH_TIME_INTERVAL   5.0f

@interface SCMapViewController () <BMKMapViewDelegate, SCMapMerchantInfoViewDelegate, UIActionSheetDelegate>
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

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商家] - 地图"];
    
     _mapView.delegate = self;  // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商家] - 地图"];
    
    _mapView.delegate = nil;    // 不用时，置nil
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

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance
{
    return MAP_VIEW_CONTROLLER(@"SCMapViewNavigationController");
}

+ (instancetype)instance
{
    return MAP_VIEW_CONTROLLER(CLASS_NAME(self));
}

#pragma mark - Config Methods
- (void)initConfig
{
    // 配置百度地图
    _mapView.frame             = self.view.bounds;          // 全屏显示
    _mapView.buildingsEnabled  = YES;                       // 允许双指上下滑动展示3D建筑
    _mapView.showsUserLocation = YES;                       // 显示定位图层
    _mapView.userTrackingMode  = BMKUserTrackingModeFollow; // 定位跟随模式
    [_mapView setRegion:_coordinateRegion animated:NO];
    
    if (_isMerchantMap)
    {
        _mapMerchantInfoView.hidden   = YES;
        UIBarButtonItem *item = self.navigationItem.leftBarButtonItem;
        self.navigationItem.leftBarButtonItem = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = item;
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

#pragma mark - Action Methods
- (IBAction)mapNavigaitonItemPressed:(UIBarButtonItem *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择导航应用"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"苹果地图"
                                              otherButtonTitles:@"百度地图", @"高德地图", nil];
    [sheet showInView:self.view];
}

- (IBAction)listItemPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter Methods
- (void)setMerchants:(NSArray *)merchants
{
    _merchants = merchants;
    _merchant  = [merchants firstObject];
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
    WEAK_SELF(weakSelf);
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        [weakSelf.mapView updateLocationData:userLocation];     // 根据坐标在地图上显示位置
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        [weakSelf showHUDAlertToViewController:weakSelf text:@"定位失败，请检查您的定位服务是否打开：设置->隐私->定位服务！" delay:1.0f];
    }];
}

#pragma mark - BMKMapView Delegate Methods
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView selectAnnotation:view.annotation animated:YES];
    _preAnnotationView.image = [UIImage imageNamed:@"MapPinIcon-Red"];
    view.image = [UIImage imageNamed:@"MapPinIcon-Blue"];
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

#pragma mark - SCMapMerchantInfoView Delegate Methods
- (void)shouldShowMerchantDetail
{
    if (!_isMerchantMap)
    {
        SCMerchantDetailViewController *merchantDetialViewControler = [SCMerchantDetailViewController instance];
        merchantDetialViewControler.merchant = _merchant;
        [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
    }
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CLLocationCoordinate2D bdLocCoor = [SCLocationManager share].userLocation.location.coordinate;
    CLLocationDegrees bdLocLat = bdLocCoor.latitude;
    CLLocationDegrees bdLocLng = bdLocCoor.longitude;
    CLLocationDegrees bdMerchantLat = [_merchant.latitude doubleValue];
    CLLocationDegrees bdMerchantLng = [_merchant.longtitude doubleValue];
    CLLocationDegrees gcjLocLat, gcjLocLng, gcjMerchantLat, gcjMerchantLng;
    
    bd_decrypt(bdLocLat, bdLocLng, &gcjLocLat, &gcjLocLng);
    bd_decrypt(bdMerchantLat, bdMerchantLng, &gcjMerchantLat, &gcjMerchantLng);
    
    NSString *urlString = nil;
    if (buttonIndex == actionSheet.destructiveButtonIndex)
        urlString = [[NSString alloc] initWithFormat:@"http://maps.apple.com/maps?saddr=%@,%@&daddr=%@,%@&dirfl=d", @(gcjLocLat), @(gcjLocLng), @(gcjMerchantLat), @(gcjMerchantLng)];
    else if (buttonIndex == 1)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
        {
            urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%@,%@|name:我的位置&destination=latlng:%@,%@|name:%@&mode=transit", [SCLocationManager share].latitude, [SCLocationManager share].longitude, _merchant.latitude, _merchant.longtitude, _merchant.name];
        }
        else
        {
            [self showAlertWithTitle:@"温馨提示" message:@"您还未安装百度地图"];
            return;
        }
    }
    else if (buttonIndex == 2)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        {
            urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%@&lon=%@&dev=0&style=3", _merchant.name, @(gcjMerchantLat), @(gcjMerchantLng)];
        }
        else
        {
            [self showAlertWithTitle:@"温馨提示" message:@"您还未安装高德地图"];
            return;
        }
    }
    else
        return;
    urlString   = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *aURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:aURL];
}

@end
