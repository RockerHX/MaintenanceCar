//
//  SCMaintenanceViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCMaintenanceTypeView.h"
#import "SCMaintenanceItemCell.h"
#import "SCMerchantTableViewCell.h"
#import "SCLocationInfo.h"
#import "SCAPIRequest.h"
#import "SCMerchantDetailViewController.h"
#import "SCReservationViewController.h"
#import "SCUserInfo.h"
#import "SCUerCar.h"
#import "SCMileageView.h"
#import "SCAllDictionary.h"
#import "SCChangeMaintenanceDataViewController.h"

#define MaintenanceCellReuseIdentifier   @"MaintenanceCellReuseIdentifier"

@interface SCMaintenanceViewController () <MBProgressHUDDelegate, SCMaintenanceTypeViewDelegate, UIAlertViewDelegate, SCChangeMaintenanceDataViewControllerDelegate, SCMaintenanceItemCellDelegate>
{
    BOOL              _isPush;
    NSInteger         _reservationButtonIndex;
    NSArray           *_serviceItems;
    NSMutableArray    *_recommendMerchants;
    
    NSInteger         _carIndex;
    SCMaintenanceType _maintenanceType;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _isPush = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页] - 保养"];
    
    // 由于首页无导航栏设计，退出保养页面的时候隐藏导航栏
    if (!_isPush)
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 进入保养页面的时候显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self initConfig];
    [self performSelector:@selector(viewConfig) withObject:nil afterDelay:0.1f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    _isPush = YES;
    SCChangeMaintenanceDataViewController *changeMaintenanceDataViewController = segue.destinationViewController;
    changeMaintenanceDataViewController.delegate = self;
}

#pragma mark - Action Methods
- (IBAction)preCarButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (_carIndex > Zero)
    {
        _carIndex --;
        userInfo.currentCar = userInfo.cars[_carIndex];
        
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
        userInfo.currentCar = userInfo.cars[_carIndex];
        
        _preButton.enabled = YES;
        if (_carIndex == count)
            sender.enabled = NO;
        [self startMaintenanceDataRequest];
        [[SCUserInfo share] removeItems];
    }
}

#pragma mark - Private Methods
- (void)initConfig
{
    _recommendMerchants = [@[] mutableCopy];
    [[SCUserInfo share] refresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _maintenanceTypeView.delegate = self;
    
    // 绑定kMerchantListReservationNotification通知，此通知的用途见定义文档
    [NOTIFICATION_CENTER addObserver:self selector:@selector(reservationButtonPressed:) name:kMaintenanceReservationNotification object:nil];
}

- (void)viewConfig
{
    if (IS_IPHONE_6)
    {
        _headerView.frame = CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 270.0f);
        _heightConstraint.constant = _heightConstraint.constant + 15.0f;
        [self.view needsUpdateConstraints];
        [self.view layoutIfNeeded];
    }
    else if (IS_IPHONE_6Plus)
    {
        _headerView.frame = CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 280.0f);
        _heightConstraint.constant = _heightConstraint.constant + 30.0f;
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
    [self startDataRequest];
}

- (void)displayMaintenanceView
{
    SCUserInfo *userInfo                 = [SCUserInfo share];
    SCUerCar *userCar                    = userInfo.currentCar;
    _carNameLabel.text                   = userCar.model_name;
    _buyCarTimeLabel.text                = ([userCar.buy_car_year integerValue] && [userCar.buy_car_month integerValue]) ? [NSString stringWithFormat:@"%@年%@月", userCar.buy_car_year, userCar.buy_car_month] : @"";
    _labelView.mileage                   = userCar.run_distance;
    _driveHabitLabel.text                = [self handleHabitString:userCar.habit];
    _maintenanceTypeView.maintenanceType = _maintenanceType;
    
    if (userInfo.cars.count <= 1)
    {
        _preButton.enabled = NO;
        _nextButton.enabled = NO;
    }
    else
    {
        _preButton.enabled = YES;
        _nextButton.enabled = YES;
    }
}

- (NSString *)handleHabitString:(NSString *)habit
{
    if ([habit isEqualToString:@"2"])
        return @"市内高频使用";
    else if ([habit isEqualToString:@"3"])
        return @"经常长途使用";
    else
        return @"日常通勤";
}

/**
 *  商户列表预约按钮点击触发事件通知方法
 *
 *  @param notification 接受传递的参数
 */
- (void)reservationButtonPressed:(NSNotification *)notification
{
    // 跳转到预约页面
    @try {
        _isPush = YES;
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant = _recommendMerchants[[notification.object integerValue]];
        reservationViewController.serviceItem = [[SCServiceItem alloc] initWithServiceID:@"2" serviceName:@"保养"];
        reservationViewController.noServiceItems = YES;
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

/**
 *  用户提示方法
 *
 *  @param text     提示内容
 *  @param delay    提示消失时间
 *  @param delegate 代理对象
 */
- (void)showPromptHUDWithText:(NSString *)text delay:(NSTimeInterval)delay delegate:(id)delegate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = delegate;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = (SCREEN_HEIGHT/2 - 100.0f);
    hud.margin = 10.0f;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"user_car_id": [SCUserInfo share].currentCar.user_car_id};
    [[SCAPIRequest manager] startMaintenanceDataAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *normalItems  = responseObject[@"normal"];
            NSArray *carefulItems = responseObject[@"careful"];
            NSArray *allItems     = responseObject[@"all"];
            [weakSelf hanldeServiceDataWithNormalData:normalItems carefulData:carefulItems allData:allItems];
            
            SCUerCar *userCar    = [SCUserInfo share].currentCar;
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
            [weakSelf showPromptHUDWithText:@"网络出错了，请稍后再试>_<" delay:1.0f delegate:weakSelf];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showPromptHUDWithText:@"网络出错了，请稍后再试>_<" delay:1.0f delegate:weakSelf];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

/**
 *  商户列表数据请求方法，参数：query, limit, offset, radius, longtitude, latitude
 */
- (void)startRecommendMerchantRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    SCLocationInfo *locationInfo = [SCLocationInfo shareLocationInfo];
    NSDictionary *parameters     = @{@"query"     : @"default:'深圳'",
                                     @"limit"     : @(3),
                                     @"offset"    : @(0),
                                     @"radius"    : @(10),
                                     @"longtitude": locationInfo.longitude,
                                     @"latitude"  : locationInfo.latitude};
    [[SCAPIRequest manager] startMerchantListAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *list = [[responseObject objectForKey:@"result"] objectForKey:@"items"];
            // 遍历请求回来的商户数据，生成SCMerchant用于商户列表显示
            for (NSDictionary *data in list)
            {
                NSError *error       = nil;
                SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:data[@"fields"] error:&error];
                [_recommendMerchants addObject:merchant];
            }
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)hanldeServiceDataWithNormalData:(NSArray *)noralData carefulData:(NSArray *)carefulData allData:(NSArray *)allData
{
    NSMutableArray *normalItems = [@[] mutableCopy];
    NSMutableArray *carefulItems = [@[] mutableCopy];
    NSMutableArray *allItems = [@[] mutableCopy];
    
    for (NSDictionary *data in noralData)
    {
        SCServiceItem *item = [[SCServiceItem alloc] initWithDictionary:data error:nil];
        [normalItems addObject:item];
    }
    for (NSDictionary *data in carefulData)
    {
        SCServiceItem *item = [[SCServiceItem alloc] initWithDictionary:data error:nil];
        [carefulItems addObject:item];
    }
    for (NSDictionary *data in allData)
    {
        SCServiceItem *item = [[SCServiceItem alloc] initWithDictionary:data error:nil];
        [allItems addObject:item];
    }
    SCUerCar *userCar    = [SCUserInfo share].currentCar;
    userCar.normalItems  = normalItems;
    userCar.carefulItems = carefulItems;
    userCar.allItems     = allItems;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return _serviceItems.count;
            break;
            
        default:
            return _recommendMerchants.count;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return _recommendMerchants.count ? @"为您推荐最近可以保养车辆的商户" : @"";
    else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            SCMaintenanceItemCell *cell = [[SCMaintenanceItemCell alloc] init];
            cell.delegate               = self;
            cell.tag                    = indexPath.row;
            SCServiceItem *item         = _serviceItems[indexPath.row];
            cell.nameLabel.text         = item.service_name;
            cell.memoLabel.text         = item.memo;
            return cell;
        }
            break;
            
        default:
        {
            SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier forIndexPath:indexPath];
            // 刷新商户列表
            SCMerchant *merchant = _recommendMerchants[indexPath.row];
            cell.merchantNameLabel.text = merchant.name;
            cell.distanceLabel.text = merchant.distance;
            cell.reservationButton.tag = indexPath.row;
            
            return cell;
        }
            break;
    }
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        _isPush = YES;
        // 列表栏被点击，执行取消选中动画
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // 根据选中的商户，取到其商户ID，跳转到商户页面进行详情展示
        SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
        merchantDetialViewControler.companyID = ((SCMerchant *)_recommendMerchants[indexPath.row]).company_id;
        [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if (IS_IPHONE_6Plus)
                return 10.0f;
            else if (IS_IPHONE_6)
                return DOT_COORDINATE;
            else
                return 10.0f;
        }
            break;
        case 1:
        {
            return  20.0f;
        }
            break;
            
        default:
            return DOT_COORDINATE;
            break;
    }
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
    SCUerCar *userCar    = [SCUserInfo share].currentCar;
    [[SCUserInfo share] removeItems];
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
            _isPush = YES;
        }
    }
}

#pragma mark - SCChangeMaintenanceDataViewController Delegate Methods
- (void)dataSaveSuccess
{
    [self startMaintenanceDataRequest];
}

#pragma mark - SCMaintenanceItemCell Delegate Methods
- (void)didChangeMaintenanceItemWithIndex:(NSInteger)index check:(BOOL)check
{
    SCUserInfo *userInfo = [SCUserInfo share];
    NSString *serviceName = ((SCServiceItem *)_serviceItems[index]).service_name;
    if (check)
        [userInfo addMaintenanceItem:serviceName];
    else
        [userInfo removeItem:serviceName];
}

@end
