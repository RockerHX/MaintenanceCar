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
#import "SCMerchantDetail.h"
#import "SCComment.h"
#import "SCMerchantSummaryCell.h"
#import "SCMerchantDetailFlagCell.h"
#import "SCGroupProductCell.h"
#import "SCQuotedPriceCell.h"
#import "SCShowMoreProductCell.h"
#import "SCMerchantDetailItemCell.h"
#import "SCMerchantServiceCell.h"
#import "SCCommentCell.h"
#import "SCCollectionItem.h"
#import "SCReservationViewController.h"
#import "SCReservatAlertView.h"
#import "SCMapViewController.h"
#import "SCAllDictionary.h"
#import "SCGroupProductDetailViewController.h"
#import "SCViewCategory.h"
#import "SCCommentListViewController.h"

typedef NS_ENUM(NSInteger, SCAlertType) {
    SCAlertTypeNeedLogin    = 100,
    SCAlertTypeReuqestError,
    SCAlertTypeReuqestCall
};

@interface SCMerchantDetailViewController () <UIAlertViewDelegate, SCReservatAlertViewDelegate, SCMerchantSummaryCellDelegate, SCMerchantDetailFlagCellDelegate, SCQuotedPriceCellDelegate>
{
    BOOL    _needChecked;      // 检查收藏标识
    UIView *_blankView;
}
@property (weak, nonatomic)    SCMerchantSummaryCell *summaryCellCell;
@property (weak, nonatomic)       SCGroupProductCell *productCell;
@property (weak, nonatomic)        SCQuotedPriceCell *quotedPriceCell;
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
    [self.tableView reLayoutFooterView];
    // 开始数据请求
    [self startMerchantDetailRequestWithParameters];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _merchantDetail.cellDisplayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_merchantDetail)
    {
        id dataClass = _merchantDetail.cellDisplayData[section];
        return [[dataClass valueForKey:@"displayRow"] integerValue];
    }
    return Zero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_merchantDetail)
    {
        id dataClass = _merchantDetail.cellDisplayData[indexPath.section];
        if ([dataClass isKindOfClass:[SCMerchantSummary class]])
        {
            if (indexPath.row)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailFlagCell" forIndexPath:indexPath];
                [(SCMerchantDetailFlagCell *)cell displayCellWithMerchangFlag:((SCMerchantSummary *)dataClass).flags[indexPath.row-1]];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantSummaryCell" forIndexPath:indexPath];
                [(SCMerchantSummaryCell *)cell displayCellWithSummary:dataClass];
            }
        }
        else if ([dataClass isKindOfClass:[SCMerchantProductGroup class]])
        {
            SCMerchantProductGroup *merchantGroup = dataClass;
            if (merchantGroup.canOpen && (indexPath.row == merchantGroup.products.count))
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCShowMoreProductCell" forIndexPath:indexPath];
                ((SCShowMoreProductCell *)cell).cellType = SCGroupCellTypeGroupProduct;
                [((SCShowMoreProductCell *)cell) displayCellWithMerchantGroup:dataClass];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupProductCell" forIndexPath:indexPath];
                [(SCGroupProductCell *)cell displayCellWithProduct:merchantGroup.products[indexPath.row]];
            }
        }
        else if ([dataClass isKindOfClass:[SCQuotedPriceGroup class]])
        {
            SCQuotedPriceGroup *quotedPriceGroup = dataClass;
            if (quotedPriceGroup.canOpen && (indexPath.row == quotedPriceGroup.products.count))
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCShowMoreProductCell" forIndexPath:indexPath];
                ((SCShowMoreProductCell *)cell).cellType = SCGroupCellTypeQuotedPrice;
                [((SCShowMoreProductCell *)cell) displayCellWithMerchantGroup:dataClass];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCQuotedPriceCell" forIndexPath:indexPath];
                SCQuotedPriceCell *quotedPriceCell = (SCQuotedPriceCell *)cell;
                quotedPriceCell.delegate = self;
                quotedPriceCell.tag = indexPath.row;
                [quotedPriceCell displayCellWithProduct:quotedPriceGroup.products[indexPath.row]];
            }
        }
        else if ([dataClass isKindOfClass:[SCMerchantInfo class]])
        {
            if (indexPath.row != 3)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailItemCell" forIndexPath:indexPath];
                [(SCMerchantDetailItemCell *)cell displayCellWithItem:_merchantDetail.info.infoItems[indexPath.row]];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantServiceCell" forIndexPath:indexPath];
                [(SCMerchantServiceCell *)cell displayCellWithDetail:_merchantDetail];
            }
        }
        else if ([dataClass isKindOfClass:[SCCommentMore class]])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SCShowMoreCell" forIndexPath:indexPath];
            ((SCShowMoreCell *)cell).count = _merchantDetail.comments_num;
        }
        else if ([dataClass isKindOfClass:[SCCommentGroup class]])
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
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 43.0f;
    CGFloat separatorHeight = 1.0f;
    if (_merchantDetail)
    {
        id dataClass = _merchantDetail.cellDisplayData[indexPath.section];
        if ([dataClass isKindOfClass:[SCMerchantSummary class]])
        {
            if (!indexPath.row)
            {
                if(!_summaryCellCell)
                    _summaryCellCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCMerchantSummaryCell"];
                [_summaryCellCell displayCellWithSummary:_merchantDetail.summary];
                height = [_summaryCellCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
        }
        else if ([dataClass isKindOfClass:[SCMerchantProductGroup class]])
        {
            SCMerchantProductGroup *merchantGroup = dataClass;
            if (!(merchantGroup.canOpen && (indexPath.row == merchantGroup.products.count)))
            {
                if(!_productCell)
                    _productCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCGroupProductCell"];
                [_productCell displayCellWithProduct:_merchantDetail.productGroup.products[indexPath.row]];
                height = [_productCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
        }
        else if ([dataClass isKindOfClass:[SCQuotedPriceGroup class]])
        {
            SCQuotedPriceGroup *quotedPriceGroup = dataClass;
            if (!(quotedPriceGroup.canOpen && (indexPath.row == quotedPriceGroup.products.count)))
            {
                if(!_quotedPriceCell)
                    _quotedPriceCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCQuotedPriceCell"];
                [_quotedPriceCell displayCellWithProduct:_merchantDetail.quotedPriceGroup.products[indexPath.row]];
                height = [_quotedPriceCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
        }
        else if ([dataClass isKindOfClass:[SCMerchantInfo class]])
        {
            if (indexPath.row != 3)
            {
                if(!_detailItemCell)
                    _detailItemCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetailItemCell"];
                [_detailItemCell displayCellWithItem:_merchantDetail.info.infoItems[indexPath.row]];
                height = [_detailItemCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
            else
                height = 120.0f;
        }
        else if ([dataClass isKindOfClass:[SCCommentGroup class]])
        {
            if(!_commentCell)
                _commentCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCCommentCell"];
            [_commentCell displayCellWithComment:_merchantDetail.commentGroup.comments[indexPath.row]];
            height =  [_commentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
    }
    
    return height + separatorHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SCGroupProductCell class]] || [cell isKindOfClass:[SCQuotedPriceCell class]])
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
    else if ([cell isKindOfClass:[SCShowMoreProductCell class]])
    {
        if (((SCShowMoreProductCell *)cell).cellType == SCGroupCellTypeGroupProduct)
            _merchantDetail.productGroup.isOpen = !((SCShowMoreProductCell *)cell).state;
        else
            _merchantDetail.quotedPriceGroup.isOpen = !((SCShowMoreProductCell *)cell).state;
        [self.tableView reloadData];
    }
    else if ([cell isKindOfClass:[SCMerchantDetailItemCell class]])
    {
        [self cellSelectedWithIndexPath:indexPath];
    }
    else if ([cell isKindOfClass:[SCShowMoreCell class]])
    {
        @try {
            SCCommentListViewController *commentListViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCCommentListViewController"];
            commentListViewController.companyID = _merchantDetail.company_id;
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
        mapViewController.merchants                     = @[_merchant];
        mapViewController.isMerchantMap                 = YES;
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
    id dataClass = _merchantDetail.cellDisplayData[section];
    NSString *headerTitle = [dataClass valueForKey:@"headerTitle"];
    return headerTitle ? 30.0f : ZERO_POINT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id dataClass = _merchantDetail.cellDisplayData[section];
    NSString *headerTitle = [dataClass valueForKey:@"headerTitle"];
    
    UIView *view;
    if (headerTitle)
    {
        view    = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 30.0f)];
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, ZERO_POINT, 100.0f, 30.0f)];
        label.font      = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor grayColor];
        label.text      = headerTitle;
        [view addSubview:label];

    }
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
        _blankView = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _blankView.backgroundColor = [UIColor whiteColor];
    }
    [self.navigationController.view addSubview:_blankView];
}

- (void)removeBlankView
{
    [MBProgressHUD hideAllHUDsForView:_blankView animated:YES];
    
    [UIView animateWithDuration:0.3f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _blankView.alpha = ZERO_POINT;
    } completion:^(BOOL finished) {
        [_blankView removeFromSuperview];
        _blankView = nil;
    }];
}

- (void)displayMerchantDetail
{
    _collectionItem.favorited = _merchantDetail.collected;
    NSMutableArray *items     = [@[] mutableCopy];
    for (NSDictionary *image in _merchantDetail.merchantImages)
    {
        UIImageView *carView = [[UIImageView alloc] init];
        [carView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MerchantImageDoMain, image[@"name"]]]
                placeholderImage:[UIImage imageNamed:@"MerchantImageDefault"]];
        [items addObject:carView];
    }
    _merchantImagesView.items = items;
    [_merchantImagesView begin:nil finished:nil];
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
            [self removeBlankView];
        }
        else
            [weakSelf showRequestErrorAlert];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showRequestErrorAlert];
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
    [self showAlertWithTitle:@"商家详情获取失败"
                     message:@"是否重新获取"
                    delegate:self
                         tag:SCAlertTypeReuqestError
           cancelButtonTitle:@"重新获取"
            otherButtonTitle:@"取消"];
}

- (void)pushToReservationViewControllerWithServiceItem:(SCServiceItem *)serviceItem canChange:(BOOL)canChange price:(NSString *)price
{
    // 跳转到预约页面
    @try {
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant                     = [[SCMerchant alloc] initWithMerchantName:_merchantDetail.name companyID:_merchantDetail.company_id];
        reservationViewController.serviceItem                  = serviceItem;
        reservationViewController.canChange                    = canChange;
        reservationViewController.price                        = price;
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
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

#pragma mark - SCMerchantSummaryCellDelegate Methods
- (void)shouldNormalReservation
{
    SCReservatAlertView *reservatAlertView = [[SCReservatAlertView alloc] initWithDelegate:self animation:SCAlertAnimationEnlarge];
    [reservatAlertView show];
}

#pragma mark - SCMerchantDetailFlagCellDelegate Methods
- (void)flagPressedWithMessage:(NSString *)message
{
    [self showAlertWithMessage:message];
}

#pragma mark - SCQuotedPriceCellDelegate Methods
- (void)shouldSpecialReservationWithIndex:(NSInteger)index
{
    SCQuotedPrice *price = _merchantDetail.quotedPriceGroup.products[index];
    NSString *type = price.type;
    
    SCUserInfo *userInfo = [SCUserInfo share];
    [userInfo removeItems];
    [userInfo addMaintenanceItem:price.title];
    
    [self pushToReservationViewControllerWithServiceItem:[[SCServiceItem alloc] initWithServiceID:type] canChange:NO price:price.final_price];
}

#pragma mark - SCReservatAlertViewDelegate Methods
- (void)selectedWithServiceItem:(SCServiceItem *)serviceItem
{
    [[SCUserInfo share] removeItems];
    [self pushToReservationViewControllerWithServiceItem:serviceItem canChange:YES price:nil];
}

@end
