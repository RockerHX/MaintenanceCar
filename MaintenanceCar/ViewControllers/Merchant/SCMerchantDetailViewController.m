//
//  SCMerchantDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <SCLoopScrollView/SCLoopScrollView.h>
#import "SCMerchant.h"
#import "SCMerchantDetail.h"
#import "SCComment.h"
#import "SCMerchantDetailCell.h"
#import "SCGroupProductCell.h"
#import "SCShowMoreProductCell.h"
#import "SCMerchantDetailItemCell.h"
#import "SCCommentCell.h"
#import "SCCollectionItem.h"
#import "SCReservationViewController.h"
#import "SCReservatAlertView.h"
#import "SCMapViewController.h"
#import "SCAllDictionary.h"
#import "SCGroupProductDetailViewController.h"
#import "SCView.h"
#import "SCCommentListViewController.h"

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

@interface SCMerchantDetailViewController () <UIAlertViewDelegate, SCReservatAlertViewDelegate, SCMerchantDetailCellDelegate>
{
    BOOL           _needChecked;      // 检查收藏标识
    BOOL           _hasGroupProducts;
    BOOL           _productOpen;
    
    NSInteger      _productCellCount;
    
    UIView         *_blankView;
}
@property (weak, nonatomic)     SCMerchantDetailCell *briefIntroductionCell;
@property (weak, nonatomic) SCMerchantDetailItemCell *detailItemCell;
@property (weak, nonatomic)            SCCommentCell *commentCell;

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
    _needChecked = YES;
}

- (void)viewConfig
{
    [self loadBlankView];
    [self.tableView reLayoutHeaderView];
    // 开始数据请求
    [self startMerchantDetailRequestWithParameters];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _merchantDetail ? (_hasGroupProducts ? 5: 4) : Zero;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_merchantDetail)
    {
        switch (section)
        {
            case 1:
                return (_hasGroupProducts ? _productCellCount : 6);
                break;
            case 2:
                return (_hasGroupProducts ? 6 : 1);
                break;
            case 3:
                return (_hasGroupProducts ? 1 : (_merchantDetail.comments.count ? _merchantDetail.comments.count : 1));
                break;
            case 4:
                return (_merchantDetail.comments.count ? _merchantDetail.comments.count : 1);
                break;
                
            default:
                return 1;
                break;
        }
    }
    return Zero;
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
                    if (((indexPath.row == _merchantDetail.products.count) && _productOpen) || ((indexPath.row == 2) && !_productOpen))
                    {
                        cell = [tableView dequeueReusableCellWithIdentifier:@"SCShowMoreProductCell" forIndexPath:indexPath];
                        [((SCShowMoreProductCell *)cell) displayCellWithProductCount:_merchantDetail.products.count];
                    }
                    else
                    {
                        cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupProductCell" forIndexPath:indexPath];
                        [(SCGroupProductCell *)cell displayCellWithProduct:_merchantDetail.products[indexPath.row]];
                    }
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
                if (_hasGroupProducts)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailItemCell" forIndexPath:indexPath];
                    [(SCMerchantDetailItemCell *)cell displayCellWithIndex:indexPath detail:_merchantDetail];
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCShowMoreCell" forIndexPath:indexPath];
                    ((SCShowMoreCell *)cell).count = _merchantDetail.comments_num;
                }
            }
                break;
            case 3:
            {
                if (_hasGroupProducts)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCShowMoreCell" forIndexPath:indexPath];
                    ((SCShowMoreCell *)cell).count = _merchantDetail.comments_num;
                }
                else
                {
                    if (_merchantDetail.comments.count)
                    {
                        cell = [tableView dequeueReusableCellWithIdentifier:@"SCCommentCell" forIndexPath:indexPath];
                        [(SCCommentCell *)cell displayCellWithComment:_merchantDetail.comments[indexPath.row]];
                    }
                    else
                        cell = [tableView dequeueReusableCellWithIdentifier:@"SCNoneCommentCell" forIndexPath:indexPath];
                }
            }
                break;
            case 4:
            {
                if (_merchantDetail.comments.count)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCCommentCell" forIndexPath:indexPath];
                    [(SCCommentCell *)cell displayCellWithComment:_merchantDetail.comments[indexPath.row]];
                }
                else
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCNoneCommentCell" forIndexPath:indexPath];
            }
                break;
                
            default:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailCell" forIndexPath:indexPath];
                ((SCMerchantDetailCell *)cell).delegate = self;
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
    CGFloat height = DOT_COORDINATE;
    CGFloat separatorHeight = 1.0f;
    if (_merchantDetail)
    {
        switch (indexPath.section)
        {
            case 1:
            {
                if (_hasGroupProducts)
                {
                    if (((indexPath.row == _merchantDetail.products.count) && _productOpen) || ((indexPath.row == 2) && !_productOpen))
                        return 44.0f;
                    else
                        return 72.0f;
                }
                height = [self calculatedetailItemCellHeightWithIndexPath:indexPath];
            }
                break;
            case 2:
            {
                if (!_hasGroupProducts)
                    return 44.0f;
                height = [self calculatedetailItemCellHeightWithIndexPath:indexPath];
            }
                break;
            case 3:
            {
                if (_hasGroupProducts)
                    return 44.0f;
                height = [self calculateCommentCellHeightWithIndexPath:indexPath];
            }
                break;
            case 4:
            {
                height = [self calculateCommentCellHeightWithIndexPath:indexPath];
            }
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

- (CGFloat)calculatedetailItemCellHeightWithIndexPath:(NSIndexPath *)indexPath
{
    if(!_detailItemCell)
        _detailItemCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailItemCell"];
    [_detailItemCell displayCellWithIndex:indexPath detail:_merchantDetail];
    
    return [_detailItemCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (CGFloat)calculateCommentCellHeightWithIndexPath:(NSIndexPath *)indexPath
{
    if (_merchantDetail.comments.count)
    {
        if(!_commentCell)
            _commentCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCCommentCell"];
        [_commentCell displayCellWithComment:_merchantDetail.comments[indexPath.row]];
        
        return [_commentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    else
        return 44.0f;
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
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if ([cell isKindOfClass:[SCShowMoreProductCell class]])
                {
                    SCShowMoreProductCell *showMoreProductCell = (SCShowMoreProductCell *)cell;
                    if (showMoreProductCell.state == SCSCShowMoreCellStateDown)
                    {
                        _productCellCount         = _merchantDetail.products.count + 1;
                        showMoreProductCell.state = SCSCShowMoreCellStateUp;
                        _productOpen              = YES;
                    }
                    else
                    {
                        _productCellCount         = 3;
                        showMoreProductCell.state = SCSCShowMoreCellStateDown;
                        _productOpen              = NO;
                    }
                    [self.tableView reloadData];
                }
                else
                {
                    if ([SCUserInfo share].loginStatus)
                    {
                        @try {
                            SCGroupProductDetailViewController *groupProductDetailViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCGroupProductDetailViewController"];
                            groupProductDetailViewController.product = _merchantDetail.products[indexPath.row];
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
            }
            else
                [self cellSelectedWithIndexPath:indexPath];
        }
            break;
        case 2:
        {
            if (_hasGroupProducts)
                [self cellSelectedWithIndexPath:indexPath];
        }
            break;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SCShowMoreCell class]])
    {
        @try {
            SCCommentListViewController *commentListViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCCommentListViewController"];
            commentListViewController.companyID = _merchantDetail.company_id;
            commentListViewController.showTrashItem = NO;
            [self.navigationController pushViewController:commentListViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCMerchantDetailViewController Go to the SCCommentListViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
}

- (void)cellSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        _merchant.latitude   = _merchantDetail.latitude;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((_hasGroupProducts && (section == 3)) || (!_hasGroupProducts && (section == 2)) || !section || section == 4)
        return DOT_COORDINATE;
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *text  = @"";
    switch (section)
    {
        case 1:
            text = _hasGroupProducts ? @"团购" : @"商家信息";
            break;
        case 2:
        {
            if (!_hasGroupProducts)
                return nil;
            text = @"商家信息";
        }
            break;
            
        default:
            return nil;
            break;
    }
    UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 30.0f)];
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, DOT_COORDINATE, 100.0f, 30.0f)];
    label.font      = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor grayColor];
    label.text = text;
    [view addSubview:label];
    return view;
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
- (void)loadBlankView
{
    if (!_blankView)
    {
        _blankView = [[UIView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _blankView.backgroundColor = [UIColor whiteColor];
    }
    [self.navigationController.view addSubview:_blankView];
}

- (void)removeBlankView
{
    [MBProgressHUD hideAllHUDsForView:_blankView animated:YES];
    
    [UIView animateWithDuration:0.3f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _blankView.alpha = DOT_COORDINATE;
    } completion:^(BOOL finished) {
        [_blankView removeFromSuperview];
        _blankView = nil;
    }];
}

- (void)displayMerchantDetail
{
    NSMutableArray *items = [@[] mutableCopy];
    for (NSDictionary *image in _merchantDetail.merchantImages)
    {
        UIImageView *carView = [[UIImageView alloc] init];
        [carView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MerchantImageDoMain, image[@"name"]]]
                placeholderImage:[UIImage imageNamed:@"MerchantImageDefault"]];
        [items addObject:carView];
    }
    _merchantImagesView.items = items;
    [_merchantImagesView begin:nil finished:nil];
    
    _collectionItem.favorited = _merchantDetail.collected;
    _hasGroupProducts         = _merchantDetail.products.count;
    _productCellCount         = ((_merchantDetail.products.count > 2) ? 3 : _merchantDetail.products.count);
}

/**
 *  商家详情请求，需要参数：id(商家id)，user_id(用户id，可选)
 */
- (void)startMerchantDetailRequestWithParameters
{
    [MBProgressHUD showHUDAddedTo:_blankView animated:YES];
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"id": _merchant.company_id,
                           @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startMerchantDetailAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _merchantDetail = [[SCMerchantDetail alloc] initWithDictionary:responseObject error:nil];
            [weakSelf displayMerchantDetail];
            
            [weakSelf.tableView reloadData];
        }
        else
            [weakSelf showRequestErrorAlert];
        [self removeBlankView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showRequestErrorAlert];
        [self removeBlankView];
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
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"收藏成功" delay:0.5f];
        }
        else
        {
            _collectionItem.favorited = NO;
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"收藏失败，请重试！" delay:0.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _collectionItem.favorited = NO;
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"收藏失败，请检查网络！" delay:0.5f];
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
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"取消收藏成功" delay:0.5f];
        }
        else
        {
            _collectionItem.favorited = YES;
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"取消收藏失败，请重试！" delay:0.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _collectionItem.favorited = YES;
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"取消收藏失败，请检查网络！" delay:0.5f];
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

#pragma mark - SCMerchantDetailCell Delegate Methods
- (void)shouldReservation
{
    SCReservatAlertView *reservatAlertView = [[SCReservatAlertView alloc] initWithDelegate:self animation:SCAlertAnimationEnlarge];
    [reservatAlertView show];
}

@end
