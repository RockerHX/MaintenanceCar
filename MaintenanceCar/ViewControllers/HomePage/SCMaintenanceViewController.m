//
//  SCMaintenanceViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceViewController.h"
#import "SCMaintenanceTypeView.h"
#import "SCMaintenanceItemCell.h"
#import "SCMerchantTableViewCell.h"
#import "SCLocationManager.h"
#import "SCMerchantDetailViewController.h"
#import "SCReservationViewController.h"
#import "SCUserCar.h"
#import "SCMileageView.h"
#import "SCAllDictionary.h"
#import "SCChangeMaintenanceDataViewController.h"
#import "SCServiceMerchantListViewController.h"

@interface SCMaintenanceViewController () <SCMaintenanceTypeViewDelegate, UIAlertViewDelegate, SCChangeMaintenanceDataViewControllerDelegate, SCMerchantTableViewCellDelegate>
{
    NSInteger           _reservationButtonIndex;
    NSArray             *_serviceItems;
    
    NSMutableDictionary *_checkData;
    NSMutableArray      *_recommendMerchants;
    
    NSInteger           _carIndex;
    SCMaintenanceType   _maintenanceType;
    
    SCUserCar           *_currentCar;
}

@end

@implementation SCMaintenanceViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[首页] - 保养"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页] - 保养"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self performSelector:@selector(viewConfig) withObject:nil afterDelay:0.1f];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _checkData          = [@{} mutableCopy];
    _recommendMerchants = [@[] mutableCopy];
    _currentCar         = [[SCUserInfo share].cars firstObject];
}

- (void)viewConfig
{
    if (IS_IPHONE_6Plus)
    {
        _headerView.frame = CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 280.0f);
        _heightConstraint.constant = _heightConstraint.constant + 30.0f;
        [self.view needsUpdateConstraints];
        [self.view layoutIfNeeded];
    }
    else if (IS_IPHONE_6)
    {
        _headerView.frame = CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 270.0f);
        _heightConstraint.constant = _heightConstraint.constant + 15.0f;
        [self.view needsUpdateConstraints];
        [self.view layoutIfNeeded];
    }
    else
    {
        _buyCarLabel.font     = [UIFont systemFontOfSize:12.0f];
        _buyCarTimeLabel.font = [UIFont systemFontOfSize:13.0f];
        _driveCarLabel.font   = [UIFont systemFontOfSize:12.0f];
        _driveHabitLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    NSArray *userCars = [SCUserInfo share].cars;
    if (userCars.count)
    {
        _nextButton.enabled = (userCars.count > 1) ? YES : NO;
        [self startDataRequest];
    }
    else
        [self showHUDAlertToViewController:self tag:Zero text:@"暂无车辆，请您添加" delay:0.5f];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Maintenance"])
    {
        SCServiceMerchantListViewController *maintenanceViewController = segue.destinationViewController;
        maintenanceViewController.query    = [DefaultQuery stringByAppendingString:@" AND service:'养'"];
        maintenanceViewController.title    = @"保养";
        maintenanceViewController.type     = @"2";
    }
}

#pragma mark - Action Methods
- (IBAction)preCarButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (_carIndex > Zero)
    {
        _carIndex --;
        _currentCar = userInfo.cars[_carIndex];
        
        _nextButton.enabled = YES;
        if (!_carIndex)
            sender.enabled = NO;
        [self startMaintenanceDataRequest];
        [[SCUserInfo share] removeItems];
    }
}

- (IBAction)nextButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    NSInteger count = userInfo.cars.count - 1;
    if (_carIndex < count)
    {
        _carIndex ++;
        _currentCar = userInfo.cars[_carIndex];
        
        _preButton.enabled = YES;
        if (_carIndex == count)
            sender.enabled = NO;
        [self startMaintenanceDataRequest];
        [[SCUserInfo share] removeItems];
    }
}

- (IBAction)infoViewPressed:(id)sender
{
    @try {
        SCChangeMaintenanceDataViewController *changeMaintenanceDataViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCChangeMaintenanceDataViewController"];
        changeMaintenanceDataViewController.delegate = self;
        changeMaintenanceDataViewController.car = _currentCar;
        [self.navigationController pushViewController:changeMaintenanceDataViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCHomePageViewController Go to the SCChangeMaintenanceDataViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Private Methods
- (void)displayMaintenanceView
{
    SCUserCar *userCar                   = _currentCar;
    _carNameLabel.text                   = [userCar.brand_name stringByAppendingString:userCar.model_name];
    _carFullNameLabel.text               = userCar.car_full_model;
    _buyCarTimeLabel.text                = ([userCar.buy_car_year integerValue] && [userCar.buy_car_month integerValue]) ? [NSString stringWithFormat:@"%@年%@月", userCar.buy_car_year, userCar.buy_car_month] : @"";
    _labelView.mileage                   = userCar.run_distance;
    _driveHabitLabel.text                = [self handleHabitString:userCar.habit];
    _maintenanceTypeView.maintenanceType = _maintenanceType;
}

- (NSString *)handleHabitString:(NSString *)habit
{
    if ([habit isEqualToString:@"1"])
        return @"市内高频使用";
    else if ([habit isEqualToString:@"2"])
        return @"经常长途使用";
    else
        return @"日常通勤";
}

- (void)startDataRequest
{
    [self startMaintenanceDataRequest];
    [self startRecommendMerchantRequest];
}

/**
 *  保养数据请求方法，参数：user_car_id
 */
- (void)startMaintenanceDataRequest
{
    __weak typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *parameters = @{@"user_car_id": _currentCar.user_car_id};
    [[SCAPIRequest manager] startMaintenanceDataAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *normalItems  = responseObject[@"normal"];
            NSArray *carefulItems = responseObject[@"careful"];
            NSArray *allItems     = responseObject[@"all"];
            [weakSelf hanldeServiceDataWithNormalData:normalItems carefulData:carefulItems allData:allItems];
            
            SCUserCar *userCar   = _currentCar;
            if (userCar.normalItems.count)
            {
                _serviceItems    = userCar.normalItems;
                _maintenanceType = SCMaintenanceTypeNormal;
            }
            else
            {
                _serviceItems    = userCar.allItems;
                _maintenanceType = SCMaintenanceTypeSelf;
            }
            [weakSelf displayMaintenanceView];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
        }
        else
            [weakSelf showHUDAlertToViewController:weakSelf tag:Zero text:NetWorkError delay:0.5f];
        [MBProgressHUD hideAllHUDsForView:weakSelf.navigationController.view animated:YES];
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showHUDAlertToViewController:weakSelf tag:Zero text:NetWorkError delay:0.5f];
        [MBProgressHUD hideAllHUDsForView:weakSelf.navigationController.view animated:YES];
    }];
}

/**
 *  商家列表数据请求方法，参数：query, limit, offset, radius, longtitude, latitude
 */
- (void)startRecommendMerchantRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        [weakSelf startRecommendMerchantListRequestWithLatitude:latitude longitude:longitude];
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        [weakSelf startRecommendMerchantListRequestWithLatitude:latitude longitude:longitude];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"定位失败，请检查您的定位服务是否打开：设置->隐私->定位服务"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

/**
 *  商家列表数据请求方法，参数：query, limit, offset, radius, longtitude, latitude
 */
- (void)startRecommendMerchantListRequestWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"query": @"default:'深圳' AND service:'养'",
                                 @"limit": @(3),
                                @"offset": @(0),
                                @"radius": @(MerchantListRadius).stringValue,
                              @"latitude": latitude,
                            @"longtitude": longitude};
    [[SCAPIRequest manager] startMerchantListAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *list = [[responseObject objectForKey:@"result"] objectForKey:@"items"];
            // 遍历请求回来的商家数据，生成SCMerchant用于商家列表显示
            for (NSDictionary *data in list)
            {
                NSError *error       = nil;
                SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:data[@"fields"] error:&error];
                [_recommendMerchants addObject:merchant];
            }
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
            [self performSelector:@selector(showFooterView:) withObject:@(list.count) afterDelay:0.2f];
        }
    } failure:nil];
}

- (void)showFooterView:(NSNumber *)show
{
    _footerView.hidden = ![show boolValue];
}

- (void)hanldeServiceDataWithNormalData:(NSArray *)noralData carefulData:(NSArray *)carefulData allData:(NSArray *)allData
{
    NSMutableArray *normalItems = [@[] mutableCopy];
    NSMutableArray *carefulItems = [@[] mutableCopy];
    NSMutableArray *allItems = [@[] mutableCopy];
    
    for (NSDictionary *data in noralData)
    {
        if (data[@"service_id"] && ([data[@"service_id"] integerValue] < 100))
        {
            SCServiceItem *item = [[SCServiceItem alloc] initWithDictionary:data error:nil];
            [normalItems addObject:item];
        }
    }
    for (NSDictionary *data in carefulData)
    {
        if (data[@"service_id"] && ([data[@"service_id"] integerValue] < 100))
        {
            SCServiceItem *item = [[SCServiceItem alloc] initWithDictionary:data error:nil];
            [carefulItems addObject:item];
        }
    }
    for (NSDictionary *data in allData)
    {
        if (data[@"service_id"] && ([data[@"service_id"] integerValue] < 100))
        {
            SCServiceItem *item = [[SCServiceItem alloc] initWithDictionary:data error:nil];
            [allItems addObject:item];
        }
    }
    SCUserCar *userCar   = _currentCar;
    userCar.normalItems  = normalItems;
    userCar.carefulItems = carefulItems;
    userCar.allItems     = allItems;
}

- (BOOL)cellCheckStatusWithIndex:(NSInteger)index
{
    return [_checkData[[@(index) stringValue]] boolValue];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? _recommendMerchants.count : _serviceItems.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section ?(_recommendMerchants.count ? @"为您推荐最近可以保养车辆的商家" : @"") : @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            SCServiceItem *item             = _serviceItems[indexPath.row];
            cell                            = [tableView dequeueReusableCellWithIdentifier:@"SCMaintenanceItemCell" forIndexPath:indexPath];
            SCMaintenanceItemCell *itemCell = (SCMaintenanceItemCell *)cell;
            itemCell.tag                    = indexPath.row;
            itemCell.check                  = [self cellCheckStatusWithIndex:indexPath.row];
            itemCell.nameLabel.text         = item.service_name;
            itemCell.memoLabel.text         = item.memo;
        }
            break;
            
        default:
        {
            cell                                  = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier forIndexPath:indexPath];
            SCMerchantTableViewCell *merchantCell = (SCMerchantTableViewCell *)cell;
            merchantCell.delegate                 = self;
            merchantCell.index                    = indexPath.row;
            [merchantCell handelWithMerchant:_recommendMerchants[indexPath.row]];
        }
            break;
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 列表栏被点击，执行取消选中动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        SCUserInfo *userInfo        = [SCUserInfo share];
        NSString *serviceName       = ((SCServiceItem *)_serviceItems[indexPath.row]).service_name;
        SCMaintenanceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMaintenanceItemCell" forIndexPath:indexPath];
        cell.check                  = ![self cellCheckStatusWithIndex:indexPath.row];
        if (cell.check)
        {
            [userInfo addMaintenanceItem:serviceName];
            [_checkData setObject:@(YES) forKey:[@(indexPath.row) stringValue]];
        }
        else
        {
            [userInfo removeItem:serviceName];
            [_checkData removeObjectForKey:[@(indexPath.row) stringValue]];
        }
        [self.tableView reloadData];
    }
    else if (indexPath.section == 1)
    {
        // 根据选中的商家，取到其商家ID，跳转到商家页面进行详情展示
        SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
        merchantDetialViewControler.merchant                        = (SCMerchant *)_recommendMerchants[indexPath.row];
        merchantDetialViewControler.type                            = @"2";
        [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? 20.0f : (IS_IPHONE_6Plus ? 40.0f : (IS_IPHONE_6 ? 20.0f : 10.0f));
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return 100.0f;
    return 44.0f;
}

#pragma mark - MBProgressHUD Delegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // 保存成功，返回上一页
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SCMaintenanceTypeView Delegate Methods
- (void)didSelectedMaintenanceType:(SCMaintenanceType)type
{
    SCUserCar *userCar = _currentCar;
    [[SCUserInfo share] removeItems];
    [_checkData removeAllObjects];
    switch (type)
    {
        case SCMaintenanceTypeAccurate:
        {
            _serviceItems    = userCar.carefulItems;
            _maintenanceType = SCMaintenanceTypeAccurate;
        }
            break;
        case SCMaintenanceTypeSelf:
        {
            _serviceItems    = userCar.allItems;
            _maintenanceType = SCMaintenanceTypeSelf;
        }
            break;
            
        default:
        {
            _serviceItems    = userCar.normalItems;
            _maintenanceType = SCMaintenanceTypeNormal;
            
            [_serviceItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [[SCUserInfo share] addMaintenanceItem:((SCServiceItem *)obj).service_name];
                [_checkData setObject:@(YES) forKey:[@(idx) stringValue]];
            }];
        }
            break;
    }
    if (!_serviceItems.count)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请您先完善保养数据！"
                                                            message:@"您要前往完善吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"完善"
                                                  otherButtonTitles:@"取消", nil];
        [alertView show];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        @try {
            SCChangeMaintenanceDataViewController *changeMaintenanceDataViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCChangeMaintenanceDataViewController"];
            changeMaintenanceDataViewController.delegate = self;
            [self.navigationController pushViewController:changeMaintenanceDataViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCMaintenanceViewController Go to the SCChangeMaintenanceDataViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
}

#pragma mark - SCChangeMaintenanceDataViewController Delegate Methods
- (void)dataSaveSuccess
{
    [self startMaintenanceDataRequest];
}

#pragma mark - SCMerchantTableViewCell Delegate Methods
- (void)shouldReservationWithIndex:(NSInteger)index
{
    // 跳转到预约页面
    @try {
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant                     = _recommendMerchants[index];
        reservationViewController.serviceItem                  = [[SCServiceItem alloc] initWithServiceID:@"2"];
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
