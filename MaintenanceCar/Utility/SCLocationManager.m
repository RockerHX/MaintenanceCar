//
//  SCLocationManager.h
//
//  Copyright (c) 2014年 ShiCang. All rights reserved.
//

#import "SCLocationManager.h"

typedef void(^SuccessBlock)(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude);
typedef void(^FailureBlock)(NSString *latitude, NSString *longitude, NSError *error);

static SCLocationManager *locationManager = nil;

@interface SCLocationManager () <BMKLocationServiceDelegate>
{
    SuccessBlock _successBlock;
    FailureBlock _failureBlock;
}

@property (nonatomic, strong) BMKLocationService *locationService;

@end

@implementation SCLocationManager

#pragma mark - Init Methods
- (id)init
{
    self = [super init];
    if (self) {
        _city = @"深圳";          // 第一版针对深圳市场，默认为深圳
        
        [self startLocation];
    }
    return self;
}

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[SCLocationManager alloc] init];
    });
    return locationManager;
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
        [BMKLocationService setLocationDistanceFilter:10.0f];
        
        //初始化BMKLocationService
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
    }
    //启动LocationService
    [_locationService startUserLocationService];
}

#pragma mark - Private Methods
/**
 *  得到用于APP上显示的实际距离（实际距离小于1000米时显示单位为米M，精确度为10米；大于1000米是显示单位为千米KM）
 *
 *  @param serverDistance 从服务器上请求得到的距离
 *
 *  @return 用于APP显示的距离
 */
- (NSString *)displayDistance:(CLLocationDistance)distance
{
    NSString *displayDistance = @"";
    if (distance == 0)
    {
        displayDistance = @" - ";
    }
    else if (distance < 500.f)
    {
        displayDistance = @"500米以内";
    }
    else if (distance < 1000.f)
    {
        displayDistance = @"1千米以内";
    }
    else
    {
        NSInteger remainder = (NSInteger)distance % 1000;
        NSInteger integer   = (NSInteger)distance / 1000;
        if (remainder > 500)
        {
            displayDistance = [NSString stringWithFormat:@"%@km", @(integer +1)];
        }
        else
        {
            displayDistance = [NSString stringWithFormat:@"%@km", @(integer)];
        }
    }
    return displayDistance;
}

#pragma mark - Setter And Getter Methods
// 重构经纬度getter方法，处理经纬度数据
- (NSString *)latitude
{
    NSString *latitude = _userLocation ? [@(_userLocation.location.coordinate.latitude) stringValue] : nil;
    if (!latitude)
    {
        latitude = @"";
    }
    return latitude;
}

- (NSString *)longitude
{
    NSString *longitude = _userLocation ? [@(_userLocation.location.coordinate.longitude) stringValue] : nil;
    if (!longitude)
    {
        longitude = @"";
    }
    return longitude;
}

#pragma mark - Public Methods
- (NSString *)distanceWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    // 本地处理位置距离
    CLLocation *merchantLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [_userLocation.location distanceFromLocation:merchantLocation];
    return [self displayDistance:distance];
}

- (void)getLocationSuccess:(void (^)(BMKUserLocation *, NSString *, NSString *))success
                   failure:(void (^)(NSString *, NSString *, NSError *))failure
{
    _successBlock = success;
    _failureBlock = failure;
    [_locationService startUserLocationService];
}

#pragma mark - BMKLocationService Delegate Methods
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    _userLocation = userLocation;
    if ((_userLocation.location.coordinate.latitude == userLocation.location.coordinate.latitude) &&
        (_userLocation.location.coordinate.longitude == userLocation.location.coordinate.longitude))
    {
        [_locationService stopUserLocationService];
        if (_successBlock)
            _successBlock(userLocation, self.latitude, self.longitude);
    }
}

// 定位失败，设置相关操作
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locationService stopUserLocationService];
    NSLog(@"Location error:%@", error);
    _userLocation = nil;
    _locationFailure = YES;
    
    if (_failureBlock)
        _failureBlock(@"", @"", error);
}

@end
