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
#import "SCMerchantTableViewCell.h"
#import "SCMerchantPurchaseTableViewCell.h"
#import "SCMerchantDetialInfoTableViewCell.h"
#import "SCCollectionItem.h"
#import "SCReservationViewController.h"
#import "SCReservatAlertView.h"

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
    SCAlertTypeReuqestError = 101
};

@interface SCMerchantDetailViewController () <UIAlertViewDelegate, SCReservatAlertViewDelegate>
{
    BOOL _needChecked;
}

@end

@implementation SCMerchantDetailViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商户] - 商户详情"];
    
    if ([SCUserInfo share].loginStatus && _needChecked)
    {
        [self startCheckMerchantCollectionStutasRequest];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商户] - 商户详情"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case SCMerchantDetailCellSectionMerchantBaseInfo:
            return 1;
            break;
        case SCMerchantDetailCellSectionPurchaseInfo:
            return 1;
            break;
        case SCMerchantDetailCellSectionMerchantInfo:
            return 4;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantCellReuseIdentifier"];
    switch (indexPath.section)
    {
        case SCMerchantDetailCellSectionMerchantBaseInfo:
        {
            SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier];
            cell.merchantNameLabel.text = _merchantDetail.name;
            cell.distanceLabel.text = _merchantDetail.distance;
            return cell;
        }
            break;
        case SCMerchantDetailCellSectionPurchaseInfo:
        {
            SCMerchantPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantPurchaseTableViewCell"];
            return cell;
        }
            break;
        case SCMerchantDetailCellSectionMerchantInfo:
        {
            switch (indexPath.row)
            {
                case SCMerchantDetailCellRowAddress:
                {
                    SCMerchantDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetialInfoTableViewCellAddress"];
                    cell.contentLabel.text = _merchantDetail.address;
                    return cell;
                }
                    break;
                case SCMerchantDetailCellRowPhone:
                {
                    SCMerchantDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetialInfoTableViewCellPhone"];
                    cell.contentLabel.text = _merchantDetail.telephone;
                    return cell;
                }
                    break;
                case SCMerchantDetailCellRowBusiness:
                {
                    SCMerchantDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetialInfoTableViewCellBusiness"];
                    cell.contentLabel.text = _merchantDetail.zige;
                    return cell;
                }
                    break;
                case SCMerchantDetailCellRowIntroduce:
                {
                    SCMerchantDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetialInfoTableViewCellIntroduce"];
                    return cell;
                }
                    break;
                    
                default:
                    return cell;
                    break;
            }
        }
            break;
            
        default:
            return cell;
            break;
    }
}

#pragma mark - Action Methods
#pragma mark -
- (IBAction)favoriteItemPressed:(SCCollectionItem *)sender
{
    if ([SCUserInfo share].loginStatus)
    {
        if (sender.favorited)
        {
            [self startUnCollectionMerchantRequest];
        }
        else
        {
            [self startCollectionMerchantRequest];
        }
        sender.favorited = !sender.favorited;
    }
    else
    {
        [self showAlertWithTitle:nil
                         message:@"收藏商户需要您先登陆"
                        delegate:self
                            type:SCAlertTypeNeedLogin
               cancelButtonTitle:@"取消"
                otherButtonTitle:@"登陆"];
    }
}

#pragma mark - Private Methods
#pragma mark -
- (void)initConfig
{
    // 开启cell高度预估，自动适配cell高度
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startMerchantDetailRequestWithParameters];
    
    // 绑定kMerchantListReservationNotification通知，此通知的用途见定义文档
    [NOTIFICATION_CENTER addObserver:self selector:@selector(reservationButtonPressed) name:kMerchantDtailReservationNotification object:nil];
}

/**
 *  商户列表预约按钮点击触发事件通知方法
 *
 *  @param notification 接受传递的参数
 */
- (void)reservationButtonPressed
{
    SCReservatAlertView *reservatAlertView = [[SCReservatAlertView alloc] initWithDelegate:self];
    [reservatAlertView show];
}

- (void)displayMerchantDetail
{
    [self startCheckMerchantCollectionStutasRequest];
    [self.tableView reloadData];
}

/**
 *  商户详情请求，需要参数：id(商户id)
 */
- (void)startMerchantDetailRequestWithParameters
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"id": _companyID};
    [[SCAPIRequest manager] startMerchantDetailAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _merchantDetail = [[SCMerchantDetail alloc] initWithDictionary:responseObject error:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [weakSelf displayMerchantDetail];
        }
        else
        {
            [weakSelf showRequestErrorAlert];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
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
        NSDictionary *paramters = @{@"company_id": _companyID,
                                    @"user_id": [SCUserInfo share].userID};
        [[SCAPIRequest manager] startCheckMerchantCollectionStutasAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _favoriteItem.favorited = (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _favoriteItem.favorited = NO;
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
            _favoriteItem.favorited = NO;
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"收藏失败，请重试", 1.0f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _favoriteItem.favorited = NO;
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
    [[SCAPIRequest manager] startMerchantUnCollectionAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消收藏成功", 1.0f);
        }
        else
        {
            _favoriteItem.favorited = YES;
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"取消收藏失败，请重试", 1.0f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _favoriteItem.favorited = YES;
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
                  delegate:(id /*<UIAlertViewDelegate>*/)delegate
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

- (void)showRequestErrorAlert
{
    [self showAlertWithTitle:@"商户详情获取失败"
                     message:@"是否重新获取"
                    delegate:self
                        type:SCAlertTypeReuqestError
           cancelButtonTitle:@"取消"
            otherButtonTitle:@"重新获取"];
}

#pragma mark - Alert View Delegate Methods
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self startMerchantDetailRequestWithParameters];
            }
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - SCReservatAlertViewDelegate Methods
#pragma mark -
- (void)selectedAtButton:(SCAlertItemType)type
{
    // 跳转到预约页面
    @try {
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant = [[SCMerchant alloc] initWithMerchantName:_merchantDetail.name companyID:_merchantDetail.company_id];
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        SCException(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
