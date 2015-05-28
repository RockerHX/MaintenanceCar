//
//  SCHomePageDetailView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCHomePageDetailView.h"
#import "MicroConstants.h"
#import "AppMicroConstants.h"
#import "SCUserInfo.h"
#import "SCAPIRequest.h"
#import "SCReservation.h"
#import "SCAllDictionary.h"
#import "SCSpecial.h"
#import <SCLoopScrollView/SCLoopScrollView.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SCHomePageDetailView
{
    BOOL            _canTap;
    
    NSMutableArray *_opratADs;
    SCReservation  *_reservation;
    SCUserCar      *_currentCar;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _canTap   = YES;
    _opratADs = [@[] mutableCopy];
    
    [self startOperatADReuqet];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(refresh) name:kUserLoginSuccessNotification object:nil];
}

#pragma Action Methods
- (IBAction)promptTap:(id)sender
{
    if (_canTap)
    {
        if ([SCUserInfo share].loginStatus)
        {
            if (!_reservation)
            {
                if (_currentCar)
                {
                    if (_delegate && [_delegate respondsToSelector:@selector(shouldChangeCarData:)])
                        [_delegate shouldChangeCarData:_currentCar];
                }
                else
                {
                    if (_delegate && [_delegate respondsToSelector:@selector(shouldAddCar)])
                        [_delegate shouldAddCar];
                }
            }
        }
        else
            [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
    }
}

#pragma mark - Private Methods
- (void)startOperatADReuqet
{
    __weak typeof(self)weakSelf = self;
    [[SCAPIRequest manager] startGetOperatADAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            [responseObject[@"ad"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCSpecial *operatAD = [[SCSpecial alloc] initWithDictionary:responseObject error:nil];
                [_opratADs addObject:operatAD];
            }];
        }
        [weakSelf refreshOperatAD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf refreshOperatAD];
    }];
}

- (void)refreshOperatAD
{
    NSMutableArray *images = [@[] mutableCopy];
    if (_opratADs.count)
    {
        for (SCSpecial *special in _opratADs)
            [images addObject:special.pic_url];
    }
    
    _operatADView.defaultImage = [UIImage imageNamed:@"MerchantImageDefault"];
    _operatADView.images = images;
    [_operatADView show:^(NSInteger index) {
        if (_opratADs.count)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(shouldShowOperatAd:)])
                [_delegate shouldShowOperatAd:_opratADs[index]];
        }
    } finished:nil];
}

- (void)displayDetailView
{
    if (_reservation)
    {
        [self handelReservationInfo];
    }
    else if (_currentCar)
    {
        [self displayCarData];
    }
    else
    {
        [self handleInfoViewWithCanTap:YES];
        _promptLabel.text = @"点击加车";
    }
}

- (void)handelReservationInfo
{
    [self handleInfoViewWithCanTap:NO];

    _merchantNameLabel.text    = _reservation.company_name;
    _serviceDaysLabel.text     = [self expiredPrompt];
    [self refreshServiceNameLabel];
}

- (void)handleInfoViewWithCanTap:(BOOL)canTap
{
    _canTap                    = canTap;
    _promptLabel.hidden        = !canTap;
    
    _merchantNameLabel.hidden  = canTap;
    _serviceNameLabel.hidden   = canTap;
    _servicePromptLabel.hidden = canTap;
    _serviceDaysLabel.hidden   = canTap;
}

- (void)refreshServiceNameLabel
{
    [[SCAllDictionary share] requestWithType:SCDictionaryTypeReservationType finfish:^(NSArray *items) {
        for (SCDictionaryItem *item in items)
        {
            if ([item.dict_id isEqualToString:_reservation.type])
                _serviceNameLabel.text = item.name;
        }
    }];
}

- (NSString *)expiredPrompt
{
    NSTimeInterval expiredInterval = [self expiredInterval] / (60*60*24);
    return [NSString stringWithFormat:@"%@天", @((NSInteger)expiredInterval)];
}

- (NSTimeInterval)expiredInterval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *expiredDate = [formatter dateFromString:_reservation.update_time];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval expiredInterval = [nowDate timeIntervalSinceDate:expiredDate];
    
    return expiredInterval;
}

- (void)showPrompt
{
    if ([SCUserInfo share].loginStatus)
    {
        _canTap = NO;
        _promptLabel.text = @"数据获取中...";
    }
    else
    {
        _canTap                    = YES;
        _promptLabel.hidden        = NO;
        _merchantNameLabel.hidden  = YES;
        _serviceNameLabel.hidden   = YES;
        _servicePromptLabel.hidden = YES;
        _serviceDaysLabel.hidden   = YES;
        _promptLabel.text = @"请点击登录";
    }
}

- (void)displayCarData
{
    _canTap                    = YES;
    _promptLabel.hidden        = NO;
    if (_currentCar.brand_name && _currentCar.model_name)
    {
        _merchantNameLabel.hidden  = YES;
        _serviceNameLabel.hidden   = YES;
        _servicePromptLabel.hidden = YES;
        _serviceDaysLabel.hidden   = YES;
        _promptLabel.text          = [NSString stringWithFormat:@"%@ %@ %@", _currentCar.brand_name, _currentCar.model_name, _currentCar.car_full_model];
    }
    else
        _promptLabel.text = @"点击加车";
}

#pragma mark - Public Methods
- (void)getUserCar
{
    __weak typeof(self)weakSelf = self;
    [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
        if (finish)
            _currentCar = [userInfo.cars firstObject];
        [weakSelf displayDetailView];
    }];
}

- (void)refresh
{
    [self showPrompt];
    if ([SCUserInfo share].loginStatus)
    {
        __weak typeof(self)weakSelf = self;
        NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID};
        [[SCAPIRequest manager] startHomePageReservationAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
            {
                if ([responseObject[@"status_code"] integerValue] == SCAPIRequestErrorCodeNoError)
                {
                    _reservation = [[SCReservation alloc] initWithDictionary:responseObject[@"data"] error:nil];
                    [weakSelf displayDetailView];
                }
                else
                {
                    _reservation = nil;
                    [weakSelf getUserCar];
                }
            }
            else
            {
                _reservation = nil;
                [weakSelf getUserCar];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _reservation = nil;
            [weakSelf getUserCar];
        }];
    }
}

@end
