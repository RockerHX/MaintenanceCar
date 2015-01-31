//
//  SCMerchantDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCMerchantDetail.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"
#import "SCMerchant.h"
#import "SCMerchantDetailCell.h"
#import "SCCollectionItem.h"
#import "SCReservationViewController.h"
#import "SCReservatAlertView.h"

#define MerchantDetailCellIdentifier      @"SCMerchantDetailCell"

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
}
@property (weak, nonatomic) IBOutlet SCMerchantDetailCell *merchantBriefIntroductionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell      *merchantCustomersCell;
@property (weak, nonatomic) IBOutlet UILabel              *merchantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel              *merchantPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel              *merchantBusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel              *merchantIntroductionLabel;

@end

@implementation SCMerchantDetailViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商户] - 商户详情"];
    
    // 从登录页面登录成功后返回到当前页面并请求登录用户的当前商户收藏状态
    if ([SCUserInfo share].loginStatus && _needChecked)
        [self startCheckMerchantCollectionStutasRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商户] - 商户详情"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 页面数据初始化
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            
        }
        else if (indexPath.row == 1)
        {
            [self showAlertWithTitle:@"是否拨打"
                             message:_merchantDetail.contacts_mobile
                            delegate:self
                                type:SCAlertTypeReuqestCall
                   cancelButtonTitle:@"取消"
                    otherButtonTitle:@"拨打"];
        }
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
        [self showAlertWithTitle:nil
                         message:@"收藏商户需要您先登录"
                        delegate:self
                            type:SCAlertTypeNeedLogin
               cancelButtonTitle:@"取消"
                otherButtonTitle:@"登录"];
    }
}

#pragma mark - Private Methods
- (void)initConfig
{
    // 加载提示框，并开始数据请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startMerchantDetailRequestWithParameters];
    
    // 绑定kMerchantListReservationNotification通知，此通知的用途见定义文档
    [NOTIFICATION_CENTER addObserver:self selector:@selector(reservationButtonPressed) name:kMerchantDtailReservationNotification object:nil];
}

- (void)viewConfig
{
}

/**
 *  商户列表预约按钮点击触发事件通知方法
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
    _collectionItem.favorited                         = _merchantDetail.collected;
    _merchantBriefIntroductionCell.distanceLabel.text = _merchantDetail.distance;
    [_merchantBriefIntroductionCell hanleMerchantFlags:_merchant.merchantFlags];
    
    [self handleMerchantName:_merchantDetail.name onNameLabel:_merchantBriefIntroductionCell.merchantNameLabel];
    [self handleMerchantDetail:_merchantDetail.address onLabel:_merchantAddressLabel];
    [self handleMerchantDetail:_merchantDetail.contacts_mobile onLabel:_merchantPhoneLabel];
    [self handleMerchantDetail:_merchantDetail.zige onLabel:_merchantBusinessLabel];
    [self handleMerchantDetail:_merchantDetail.service onLabel:_merchantIntroductionLabel];
}

- (void)handleMerchantName:(NSString *)merchantName onNameLabel:(UILabel *)nameLabel
{
    if (IS_IPHONE_6Plus && (merchantName.length > 40))
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
    else if (IS_IPHONE_6 && (merchantName.length > 36))
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
    else if (merchantName.length > 30)
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
    
    nameLabel.text = merchantName;
}

- (void)handleMerchantDetail:(NSString *)detail onLabel:(UILabel *)label
{
    if (IS_IPHONE_6Plus && (detail.length > 30))
        label.font = [UIFont systemFontOfSize:14.0f];
    else if (IS_IPHONE_6 && (detail.length > 24))
        label.font = [UIFont systemFontOfSize:14.0f];
    else if (detail.length > 16)
        label.font = [UIFont systemFontOfSize:14.0f];
    
    label.text = detail;
}

/**
 *  商户详情请求，需要参数：id(商户id)，user_id(用户id，可选)
 */
- (void)startMerchantDetailRequestWithParameters
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"id": _merchant.company_id,
                           @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startMerchantDetailAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _merchantDetail = [[SCMerchantDetail alloc] initWithDictionary:responseObject error:nil];
            [weakSelf displayMerchantDetail];
        }
        else
            [weakSelf showRequestErrorAlert];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showRequestErrorAlert];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 *  检查商户详情接口，需要参数:company_id，user_id
 */
- (void)startCheckMerchantCollectionStutasRequest
{
    if ([SCUserInfo share].loginStatus)
    {
        NSDictionary *paramters = @{@"company_id": _merchant.company_id,
                                       @"user_id": [SCUserInfo share].userID};
        [[SCAPIRequest manager] startCheckMerchantCollectionStutasAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _collectionItem.favorited = (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _collectionItem.favorited = NO;
        }];
    }
    _needChecked = NO;
}

/**
 *  收藏商户，需要参数：company_id，user_id，type_id
 */
- (void)startCollectionMerchantRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"company_id": _merchantDetail.company_id,
                                @"user_id": [SCUserInfo share].userID,
                                @"type_id": @"1"};
    [[SCAPIRequest manager] startMerchantCollectionAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"收藏成功", 1.0f);
        }
        else
        {
            _collectionItem.favorited = NO;
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"收藏失败，请重试", 1.0f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _collectionItem.favorited = NO;
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"收藏失败，请检查网络", 1.0f);
    }];
}

/**
 *  取消收藏商户，需要参数：company_id，user_id
 */
- (void)startUnCollectionMerchantRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"company_id": _merchantDetail.company_id,
                                @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startCancelCollectionAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消收藏成功", 1.0f);
        }
        else
        {
            _collectionItem.favorited = YES;
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消收藏失败，请重试", 1.0f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _collectionItem.favorited = YES;
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消收藏失败，请检查网络", 1.0f);
    }];
}

/**
 *  弹出提示框
 *
 *  @param title             提示框标题
 *  @param message           提示框显示消息
 *  @param delegate          代理对象
 *  @param type              提示框类型
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其他按钮标题
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)delegate
                      type:(SCAlertType)type
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitle, nil];
    alertView.tag = type;
    [alertView show];
}

/**
 *  显示错误警告框
 */
- (void)showRequestErrorAlert
{
    [self showAlertWithTitle:@"商户详情获取失败"
                     message:@"是否重新获取"
                    delegate:self
                        type:SCAlertTypeReuqestError
           cancelButtonTitle:@"重新获取"
            otherButtonTitle:@"取消"];
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
            if (buttonIndex != alertView.cancelButtonIndex)
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _merchantDetail.contacts_mobile]]];
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
        reservationViewController.merchant = [[SCMerchant alloc] initWithMerchantName:_merchantDetail.name companyID:_merchantDetail.company_id];
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
