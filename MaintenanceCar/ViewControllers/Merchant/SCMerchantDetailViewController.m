//
//  SCMerchantDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailViewController.h"
#import "SCMerchantDetail.h"
#import "SCMerchant.h"
#import "SCMerchantDetailCell.h"
#import "SCGroupProductCell.h"
#import "SCMerchantDetailItemCell.h"
#import "SCCollectionItem.h"
#import "SCReservationViewController.h"
#import "SCReservatAlertView.h"
#import "SCMapViewController.h"
#import "SCAllDictionary.h"
#import "SCGroupProductDetailViewController.h"

typedef NS_ENUM(NSInteger, SCMerchantDetailCellSection) {
    SCMerchantDetailCellSectionMerchantBaseInfo = 0,
    SCMerchantDetailCellSectionPurchaseInfo,
    SCMerchantDetailCellSectionMerchantInfo
};
typedef NS_ENUM(NSInteger, SCMerchantDetailCellRow) {
    SCMerchantDetailCellRowAddress = 0,
    SCMerchantDetailCellRowPhone,
    SCMerchantDetailCellRowBusiness,
    SCMerchantDetailCellRowIntroduce
};
typedef NS_ENUM(NSInteger, SCAlertType) {
    SCAlertTypeNeedLogin    = 100,
    SCAlertTypeReuqestError,
    SCAlertTypeReuqestCall
};

@interface SCMerchantDetailViewController () <UIAlertViewDelegate, SCReservatAlertViewDelegate>
{
    BOOL _needChecked;      // 检查收藏标识
    BOOL _hasGroupProducts;
    BOOL _loadFinish;
}
@property (weak, nonatomic)    SCMerchantDetailCell *briefIntroductionCell;
@property (weak, nonatomic) SCMerchantDetailItemCell *detailItemCell;

@end

@implementation SCMerchantDetailViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商家] - 商家详情"];
    
    // 从登录页面登录成功后返回到当前页面并请求登录用户的当前商家收藏状态
    if ([SCUserInfo share].loginStatus && _needChecked)
        [self startCheckMerchantCollectionStutasRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商家] - 商家详情"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 页面数据初始化
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
    if (IS_IOS8)
    {
        self.tableView.estimatedRowHeight = 120.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    _loadFinish = YES;
    _needChecked = YES;
    // 加载提示框，并开始数据请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startMerchantDetailRequestWithParameters];
    
    // 绑定kMerchantListReservationNotification通知，此通知的用途见定义文档
    [NOTIFICATION_CENTER addObserver:self selector:@selector(reservationButtonPressed) name:kMerchantDtailReservationNotification object:nil];
}

- (void)viewConfig
{
    [self.tableView reLayoutHeaderView];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _merchantDetail ? (_hasGroupProducts ? 3: 2) : Zero;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 1:
            return _merchantDetail ? (_hasGroupProducts ? 1: 6) : Zero;
            break;
        case 2:
            return _merchantDetail ? 6 : Zero;
            break;
            
        default:
            return _merchantDetail ? 1 : Zero;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (_merchantDetail)
    {
        switch (indexPath.section)
        {
            case 1:
            {
                if (_hasGroupProducts)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupProductCell" forIndexPath:indexPath];
                    [(SCGroupProductCell *)cell displayCellWithMerchantDetail:_merchantDetail];
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailItemCell" forIndexPath:indexPath];
                    [(SCMerchantDetailItemCell *)cell displayCellWithIndex:indexPath detail:_merchantDetail];
                }
            }
                break;
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailItemCell" forIndexPath:indexPath];
                [(SCMerchantDetailItemCell *)cell displayCellWithIndex:indexPath detail:_merchantDetail];
            }
                break;
                
            default:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailCell" forIndexPath:indexPath];
                [(SCMerchantDetailCell *)cell displayCellWithDetail:_merchantDetail];
            }
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IOS8)
    {
        if (_hasGroupProducts && indexPath.section == 1)
            return 72.0f;
        return UITableViewAutomaticDimension;
    }
    else
    {
        CGFloat height = DOT_COORDINATE;
        CGFloat separatorHeight = 1.0f;
        if (_merchantDetail)
        {
            switch (indexPath.section)
            {
                case 1:
                {
                    if (_hasGroupProducts)
                        return 72.0f;
                    else
                        height = [self calculateCellHeightWithIndexPath:indexPath];
                }
                    break;
                case 2:
                    height = [self calculateCellHeightWithIndexPath:indexPath];
                    break;
                    
                default:
                {
                    if(!_briefIntroductionCell)
                        _briefIntroductionCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailCell"];
                    [_briefIntroductionCell displayCellWithDetail:_merchantDetail];
                    
                    height = [_briefIntroductionCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                }
                    break;
            }
        }
        
        return height + separatorHeight;
    }
}

- (CGFloat)calculateCellHeightWithIndexPath:(NSIndexPath *)indexPath
{
    if(!self.detailItemCell)
        self.detailItemCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailItemCell"];
    [self.detailItemCell displayCellWithIndex:indexPath detail:_merchantDetail];
    
    return [self.detailItemCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 1:
        {
            if (_hasGroupProducts)
            {
                if ([SCUserInfo share].loginStatus)
                {
                    @try {
                        SCGroupProductDetailViewController *groupProductDetailViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCGroupProductDetailViewController"];
                        SCGroupProduct *product = [_merchantDetail.products lastObject];
                        groupProductDetailViewController.product = product;
                        [self.navigationController pushViewController:groupProductDetailViewController animated:YES];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"SCMerchantDetailViewController Go to the SCGroupProductViewController exception reasion:%@", exception.reason);
                    }
                    @finally {
                    }
                }
                else
                    [self showShoulLoginAlert];
            }
            else
                [self cellSelectedWithIndexPath:indexPath];
        }
            break;
            
        default:
            [self cellSelectedWithIndexPath:indexPath];
            break;
    }
}

- (void)cellSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        _merchant.latitude = _merchantDetail.latitude;
        _merchant.longtitude = _merchantDetail.longtitude;
        // 地图按钮被点击，跳转到地图页面
        UINavigationController *mapNavigationController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMapViewNavigationController"];
        SCMapViewController *mapViewController          = (SCMapViewController *)mapNavigationController.topViewController;
        mapViewController.showInfoView                  = NO;
        mapViewController.isMerchantMap                 = YES;
        mapViewController.merchants                     = @[_merchant];
        mapViewController.leftItem.title                = @"详情";
        mapNavigationController.modalTransitionStyle    = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mapNavigationController animated:YES completion:nil];
    }
    else if (indexPath.row == 1)
    {
        if (_merchantDetail.telephone.length)
        {
            NSArray *phones = [_merchantDetail.telephone componentsSeparatedByString:@" "];
            UIAlertView *alertView = nil;
            if (phones.count > 1)
            {
                alertView = [[UIAlertView alloc] initWithTitle:@"是否拨打商家电话"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:[phones firstObject], [phones lastObject], nil];
            }
            else
            {
                alertView = [[UIAlertView alloc] initWithTitle:@"是否拨打商家电话"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:[phones firstObject], nil];
            }
            alertView.tag = SCAlertTypeReuqestCall;
            [alertView show];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ((indexPath.row == 5 && indexPath.section == _hasGroupProducts ? 2 : 1) && _loadFinish && IS_IOS8)
    {
        [self.tableView scrollRectToVisible:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 1.0f, 1.0f) animated:NO];
        _loadFinish = NO;
    }
}

#pragma mark - Action Methods
- (IBAction)collectionItemPressed:(SCCollectionItem *)sender
{
    // 是否需要用户登录，已登录经行收藏请求或者取消收藏请求，否则弹出警告提示框
    if ([SCUserInfo share].loginStatus)
    {
        if (sender.favorited)
            [self startUnCollectionMerchantRequest];
        else
            [self startCollectionMerchantRequest];
        sender.favorited = !sender.favorited;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"收藏商家需要您先登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登录", nil];
        alertView.tag = SCAlertTypeNeedLogin;
        [alertView show];
    }
}

#pragma mark - Private Methods
/**
 *  商家列表预约按钮点击触发事件通知方法
 *
 *  @param notification 接受传递的参数
 */
- (void)reservationButtonPressed
{
    SCReservatAlertView *reservatAlertView = [[SCReservatAlertView alloc] initWithDelegate:self animation:SCAlertAnimationEnlarge];
    [reservatAlertView show];
}

- (void)displayMerchantDetail
{
    [_merchantImageView setImageWithURL:[NSString stringWithFormat:@"%@%@_1.jpg", MerchantImageDoMain, _merchant.company_id] defaultImage:@"MerchantImageDefault"];
    _collectionItem.favorited = _merchantDetail.collected;
    _hasGroupProducts         = _merchantDetail.products.count;
}

/**
 *  商家详情请求，需要参数：id(商家id)，user_id(用户id，可选)
 */
- (void)startMerchantDetailRequestWithParameters
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"id": _merchant.company_id,
                           @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startMerchantDetailAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _merchantDetail = [[SCMerchantDetail alloc] initWithDictionary:responseObject error:nil];
            [weakSelf displayMerchantDetail];
            
            [weakSelf.tableView reloadData];
            if (IS_IOS8)
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
            [weakSelf showRequestErrorAlert];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showRequestErrorAlert];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

/**
 *  检查商家详情接口，需要参数:company_id，user_id
 */
- (void)startCheckMerchantCollectionStutasRequest
{
    if ([SCUserInfo share].loginStatus)
    {
        NSDictionary *paramters = @{@"company_id": _merchant.company_id,
                                       @"user_id": [SCUserInfo share].userID};
        [[SCAPIRequest manager] startCheckMerchantCollectionStutasAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _collectionItem.favorited = (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _collectionItem.favorited = NO;
        }];
    }
    _needChecked = NO;
}

/**
 *  收藏商家，需要参数：company_id，user_id，type_id
 */
- (void)startCollectionMerchantRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"company_id": _merchantDetail.company_id,
                                   @"user_id": [SCUserInfo share].userID,
                                   @"type_id": @"1"};
    [[SCAPIRequest manager] startMerchantCollectionAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"收藏成功", 0.5f);
        }
        else
        {
            _collectionItem.favorited = NO;
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"收藏失败，请重试", 0.5f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _collectionItem.favorited = NO;
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"收藏失败，请检查网络", 0.5f);
    }];
}

/**
 *  取消收藏商家，需要参数：company_id，user_id
 */
- (void)startUnCollectionMerchantRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"company_id": _merchantDetail.company_id,
                                   @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startCancelCollectionAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消收藏成功", 0.5f);
        }
        else
        {
            _collectionItem.favorited = YES;
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消收藏失败，请重试", 0.5f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _collectionItem.favorited = YES;
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消收藏失败，请检查网络", 0.5f);
    }];
}

/**
 *  显示错误警告框
 */
- (void)showRequestErrorAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"商家详情获取失败"
                                                        message:@"是否重新获取"
                                                       delegate:self
                                              cancelButtonTitle:@"重新获取"
                                              otherButtonTitles:@"取消", nil];
    alertView.tag = SCAlertTypeReuqestError;
    [alertView show];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 根据提示框的类型判断，用户需要登录进行页面跳转，数据请求失败提示刷新，取消则返回
    switch (alertView.tag) {
        case SCAlertTypeNeedLogin:
        {
            if (buttonIndex != alertView.cancelButtonIndex)
            {
                _needChecked = YES;
                [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
            }
        }
            break;
        case SCAlertTypeReuqestError:
        {
            if (buttonIndex != alertView.cancelButtonIndex)
                [self.navigationController popViewControllerAnimated:YES];
            else
                [self startMerchantDetailRequestWithParameters];
        }
            break;
        case SCAlertTypeReuqestCall:
        {
            NSArray *phones = [_merchantDetail.telephone componentsSeparatedByString:@" "];
            if (buttonIndex == 1)
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [phones firstObject]]]];
            else if (buttonIndex == 2)
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [phones lastObject]]]];
        }
            break;
    }
}

#pragma mark - SCReservatAlertViewDelegate Methods
- (void)selectedWithServiceItem:(SCServiceItem *)serviceItem
{
    // 跳转到预约页面
    @try {
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant = [[SCMerchant alloc] initWithMerchantName:_merchantDetail.name
                                                                            companyID:_merchantDetail.company_id];
        reservationViewController.serviceItem = serviceItem;
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
