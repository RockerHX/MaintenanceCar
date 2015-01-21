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
#import "SCMaintenanceTypeCell.h"
#import "SCMaintenanceItemCell.h"
#import "SCMerchantTableViewCell.h"
#import "SCLocationInfo.h"
#import "SCAPIRequest.h"
#import "SCMerchant.h"
#import "SCMerchantDetailViewController.h"
#import "SCReservatAlertView.h"
#import "SCReservationViewController.h"
#import "SCUserInfo.h"
#import "SCUerCar.h"
#import "SCMileageView.h"

#define MaintenanceCellReuseIdentifier   @"MaintenanceCellReuseIdentifier"

@interface SCMaintenanceViewController () <SCReservatAlertViewDelegate, MBProgressHUDDelegate>
{
    BOOL           _isPush;
    NSInteger      _reservationButtonIndex;
    NSMutableArray *_recommendMerchants;
    
    NSInteger      _carIndex;
}

@property (nonatomic, assign) BOOL loadMerhcantItemFinish;
@property (nonatomic, assign) BOOL loadUserCarFinish;

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
    
    if (!_isPush)
        // 由于首页无导航栏设计，退出保养页面的时候隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self performSelector:@selector(viewConfig) withObject:nil afterDelay:0.1f];
    
    // 进入保养页面的时候显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
}

#pragma mark - Action Methods
- (IBAction)preCarButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (_carIndex > Zero)
    {
        _carIndex --;
        userInfo.currentCar = userInfo.cars[_carIndex];
    }
    else
        _carIndex = Zero;
    
    [self displayMaintenanceView];
}

- (IBAction)nextButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (_carIndex < userInfo.cars.count - 1)
    {
        _carIndex ++;
        userInfo.currentCar = userInfo.cars[_carIndex];
    }
    else
        _carIndex = userInfo.cars.count - 1;
    
    [self displayMaintenanceView];
}

#pragma mark - Private Methods
- (void)initConfig
{
    _recommendMerchants = [@[] mutableCopy];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 绑定kMerchantListReservationNotification通知，此通知的用途见定义文档
    [NOTIFICATION_CENTER addObserver:self selector:@selector(reservationButtonPressed:) name:kMerchantListReservationNotification object:nil];
}

- (void)viewConfig
{
    if (IS_IPHONE_6)
    {
        _headerView.frame = CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 210.0f);
        _heightConstraint.constant = _heightConstraint.constant + 15.0f;
        [self.view needsUpdateConstraints];
        [self.view layoutIfNeeded];
    }
    else if (IS_IPHONE_6Plus)
    {
        _headerView.frame = CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 220.0f);
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
    [self displayMaintenanceView];
}

- (void)displayMaintenanceView
{
    [[SCUserInfo share] cars];
    SCUserInfo *userInfo = [SCUserInfo share];
    _carNameLabel.text = userInfo.currentCar.model_name;
    _labelView.mileage = userInfo.currentCar.run_distance;
}

/**
 *  商户列表预约按钮点击触发事件通知方法
 *
 *  @param notification 接受传递的参数
 */
- (void)reservationButtonPressed:(NSNotification *)notification
{
    _reservationButtonIndex = [notification.object integerValue];       // 设置index，用于在_merchantList里取出SCMerchant对象设置到SCReservationViewController
    
    // 显示预约框
    SCReservatAlertView *reservatAlertView = [[SCReservatAlertView alloc] initWithDelegate:self animation:SCAlertAnimationEnlarge];
    [reservatAlertView show];
}

/**
 *  用户提示方法
 *
 *  @param text     提示内容
 *  @param delay    提示消失时间
 *  @param delegate 代理对象
 */
- (void)showPromptHUDWithText:(NSString *)text delay:(NSTimeInterval)delay delegate:(id<MBProgressHUDDelegate>)delegate
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
//    [self startMaintenanceItemRequest];
    [self startRecommendMerchantRequest];
}

- (void)startMaintenanceItemRequest
{
    
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
            [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error       = nil;
                SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj[@"fields"] error:&error];
                [_recommendMerchants addObject:merchant];
            }];
            [weakSelf.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
            
        default:
            return _recommendMerchants.count;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2)
        return @"为您推荐以下可以维修追尾事故的商户";
    else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            SCMaintenanceTypeCell *cell = [[SCMaintenanceTypeCell alloc] init];
            return cell;
        }
            break;
        case 1:
        {
            SCMaintenanceItemCell *cell = [[SCMaintenanceItemCell alloc] init];
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
    if (indexPath.section == 2)
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
            if (IS_IPHONE_6)
                return 25.0f;
            else if (IS_IPHONE_6Plus)
                return 35.0f;
            else
                return 15.0f;
        }
            break;
        case 1:
        {
            return DOT_COORDINATE;
        }
            break;
        case 2:
        {
            return  _recommendMerchants.count ? 30.0f : DOT_COORDINATE;
        }
            break;
            
        default:
            return DOT_COORDINATE;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
        return 100.0f;
    return 44.0f;
}

#pragma mark - SCReservatAlertViewDelegate Methods
- (void)selectedAtButton:(SCAlertItemType)type
{
    // 跳转到预约页面
    @try {
        _isPush = YES;
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant = _recommendMerchants[_reservationButtonIndex];
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
    
}

@end
