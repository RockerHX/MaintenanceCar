//
//  SCMerchantDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
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

@interface SCMerchantDetailViewController () <SCReservatAlertViewDelegate, SCMerchantSummaryCellDelegate, SCMerchantDetailFlagCellDelegate, SCQuotedPriceCellDelegate>
{
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
    [NOTIFICATION_CENTER addObserver:self selector:@selector(merchantFlagsHandleCompleted) name:@"MerchantFlagsHandleCompleted" object:nil];
}

// TODO
- (void)merchantFlagsHandleCompleted
{
    [self.tableView reloadData];
}

- (void)viewConfig
{
    [self loadBlankView];
    [self.tableView reLayoutHeaderView];
    [self.tableView reLayoutFooterView];
    // 开始数据请求
    [self startMerchantDetailRequestWithParameters];
}

#pragma mark - Public Methods
+ (instancetype)instance
{
    return MAIN_VIEW_CONTROLLER(NSStringFromClass([self class]));
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
                [quotedPriceCell displayCellWithPrice:quotedPriceGroup.products[indexPath.row]];
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
                [_quotedPriceCell displayCellWithPrice:_merchantDetail.quotedPriceGroup.products[indexPath.row]];
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
    
    @try {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[SCGroupProductCell class]])
        {
            SCGroupProductDetailViewController *groupProductDetailViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCGroupProductDetailViewController"];
            groupProductDetailViewController.product = [cell isKindOfClass:[SCGroupProductCell class]] ? _merchantDetail.products[indexPath.row] : nil;
            [self.navigationController pushViewController:groupProductDetailViewController animated:YES];
        }
        if ([cell isKindOfClass:[SCQuotedPriceCell class]])
        {
            SCQuotedPrice *price = _merchantDetail.quotedPriceGroup.products[indexPath.row];
            price.merchantName   = _merchantDetail.name;
            price.companyID      = _merchantDetail.company_id;
            SCGroupProductDetailViewController *priceDetailViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCGroupProductDetailViewController"];
            priceDetailViewController.title = @"商品详情";
            priceDetailViewController.price = price;
            [self.navigationController pushViewController:priceDetailViewController animated:YES];
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
            SCCommentListViewController *commentListViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCCommentListViewController"];
            commentListViewController.companyID = _merchantDetail.company_id;
            [self.navigationController pushViewController:commentListViewController animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantDetailViewController Go to the SubViewController exception reasion:%@", exception.reason);
    }
    @finally {
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
            [self startCancelCollectionMerchantRequest];
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
    NSMutableArray *images     = [@[] mutableCopy];
    for (NSDictionary *image in _merchantDetail.merchantImages)
        [images addObject:[NSString stringWithFormat:@"%@%@", MerchantImageDoMain, image[@"name"]]];
    _merchantImagesView.defaultImage = [UIImage imageNamed:@"MerchantImageDefault"];
    _merchantImagesView.images = images;
    [_merchantImagesView show:nil finished:nil];
}

/**
 *  商家详情请求，需要参数：id(商家id)，user_id(用户id，可选)
 */
- (void)startMerchantDetailRequestWithParameters
{
    WEAK_SELF(weakSelf);
    [MBProgressHUD showHUDAddedTo:_blankView animated:YES];
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
 *  收藏商家，需要参数：company_id，user_id，type_id
 */
- (void)startCollectionMerchantRequest
{
    WEAK_SELF(weakSelf);
    NSDictionary *paramters = @{@"company_id": _merchantDetail.company_id,
                                   @"user_id": [SCUserInfo share].userID,
                                   @"type_id": @"1"};
    [[SCAPIRequest manager] startMerchantCollectionAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
        NSString *statusMessage = responseObject[@"status_message"];
        switch (statusCode)
        {
            case SCAPIRequestErrorCodeCollectionFailure:
                _collectionItem.favorited = NO;
                break;
        }
        if (statusMessage.length)
            [self showHUDAlertToViewController:self text:statusMessage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _collectionItem.favorited = NO;
        [weakSelf hanleFailureResponseWtihOperation:operation];
    }];
}

/**
 *  取消收藏商家，需要参数：company_id，user_id
 */
- (void)startCancelCollectionMerchantRequest
{
    WEAK_SELF(weakSelf);
    NSDictionary *paramters = @{@"company_id": _merchantDetail.company_id,
                                   @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startCancelCollectionAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
        NSString *statusMessage = responseObject[@"status_message"];
        switch (statusCode)
        {
            case SCAPIRequestErrorCodeNoError:
            {
                if (_delegate && [_delegate respondsToSelector:@selector(cancelCollectionSuccess)])
                    [_delegate cancelCollectionSuccess];
            }
                break;
            case SCAPIRequestErrorCodeCancelCollectionFailure:
                _collectionItem.favorited = YES;
                break;
        }
        if (statusMessage.length)
            [self showHUDAlertToViewController:self text:statusMessage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _collectionItem.favorited = YES;
        [weakSelf hanleFailureResponseWtihOperation:operation];
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

- (void)pushToReservationViewControllerWithServiceItem:(SCServiceItem *)serviceItem canChange:(BOOL)canChange price:(SCQuotedPrice *)price
{
    // 跳转到预约页面
    SCReservationViewController *reservationViewController = [SCReservationViewController instance];
    reservationViewController.merchant    = [[SCMerchant alloc] initWithMerchantName:_merchantDetail.name companyID:_merchantDetail.company_id];
    reservationViewController.serviceItem = serviceItem;
    reservationViewController.canChange   = canChange;
    reservationViewController.quotedPrice = price;
    [self.navigationController pushViewController:reservationViewController animated:YES];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 根据提示框的类型判断，用户需要登录进行页面跳转，数据请求失败提示刷新，取消则返回
    switch (alertView.tag) {
        case SCAlertTypeNeedLogin:
        {
            if (buttonIndex != alertView.cancelButtonIndex)
                [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
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
    if (_canSelectedReserve)
    {
        SCReservatAlertView *reservatAlertView = [[SCReservatAlertView alloc] initWithDelegate:self animation:SCAlertAnimationEnlarge];
        [reservatAlertView show];
    }
    else
    {
        [[SCUserInfo share] removeItems];
        [self pushToReservationViewControllerWithServiceItem:[[SCServiceItem alloc] initWithServiceID:_type] canChange:YES price:nil];
    }
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
    price.merchantName   = _merchantDetail.name;
    price.companyID      = _merchantDetail.company_id;
    
    [self pushToReservationViewControllerWithServiceItem:[[SCServiceItem alloc] initWithServiceID:price.type] canChange:NO price:price];
}

#pragma mark - SCReservatAlertViewDelegate Methods
- (void)selectedWithServiceItem:(SCServiceItem *)serviceItem
{
    [[SCUserInfo share] removeItems];
    [self pushToReservationViewControllerWithServiceItem:serviceItem canChange:YES price:nil];
}

@end
