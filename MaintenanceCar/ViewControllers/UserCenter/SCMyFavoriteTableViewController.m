//
//  SCMyFavoriteTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyFavoriteTableViewController.h"
#import "SCMerchantTableViewCell.h"
#import "SCMerchantDetailViewController.h"
#import "SCReservatAlertView.h"
#import "SCReservationViewController.h"
#import "SCLocationManager.h"

@interface SCMyFavoriteTableViewController () <SCReservatAlertViewDelegate>
{
    NSInteger _index;
}

@end

@implementation SCMyFavoriteTableViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 我的收藏"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 我的收藏"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchant *merchant = _dataList[indexPath.row];
    SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier forIndexPath:indexPath];
    cell.reservationButton.tag    = indexPath.row;
    cell.reservationButton.hidden = !merchant.serviceItems.count;
    
    // 刷新商家列表，设置相关数据
    [cell handelWithMerchant:merchant];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;     // 允许列表编辑
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果用户经行删除或者滑动删除操作，设置数据缓存，并进行相关删除操作请求，同步服务器数据
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _deleteDataCache = _dataList[indexPath.row];        // 设置数据缓存
        [_dataList removeObjectAtIndex:indexPath.row];      // 清楚数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];   // 列表中删除相关数据行
        [self startCancelCollectionMerchantRequestWithIndex:indexPath.row];                             // 同步服务器
    }
}

#pragma mark - Table View Delegate Methods
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消收藏";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 跳转到预约页面
    @try {
        SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
        merchantDetialViewControler.merchant                        = (SCMerchant *)_dataList[indexPath.row];
        merchantDetialViewControler.canSelectedReserve              = YES;
        [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMyFavoriteTableViewController Go to the SCMerchantDetailViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Public Methods
- (void)startDropDownRefreshReuqest
{
    [super startDropDownRefreshReuqest];
    [self refreshCollectionListMerchantList];
}

- (void)startPullUpRefreshRequest
{
    [super startPullUpRefreshRequest];
    [self refreshCollectionListMerchantList];
}

- (void)refreshCollectionListMerchantList
{
    __weak typeof(self) weakSelf = self;
    [[SCLocationManager share] getLocationSuccess:^(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude) {
        [weakSelf startMerchantCollectionListRequest:latitude longitude:longitude];
    } failure:^(NSString *latitude, NSString *longitude, NSError *error) {
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"定位失败，采用当前城市中心坐标！" delay:0.5f];
        [weakSelf startMerchantCollectionListRequest:latitude longitude:longitude];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"定位失败，请检查您的定位服务是否打开：设置->隐私->定位服务"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

#pragma mark - Private Methods
/**
 *  收藏列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startMerchantCollectionListRequest:(NSString *)latitude longitude:(NSString *)longitude
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"limit"  : @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startGetCollectionMerchantAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            if (weakSelf.requestType == SCRequestRefreshTypeDropDown)
                [weakSelf clearListData];
            // 遍历请求回来的商家数据，生成SCMerchant用于商家列表显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj error:nil];
                [_dataList addObject:merchant];
            }];
            
            weakSelf.offset += MerchantListLimit;               // 偏移量请求参数递增
            [weakSelf.tableView reloadData];                    // 数据配置完成，刷新商家列表
            [weakSelf addRefreshHeader];
            [weakSelf addRefreshFooter];
        }
        else
        {
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:responseObject[@"error"] delay:0.5f];
            [weakSelf addRefreshHeader];
            [weakSelf removeRefreshFooter];
        }
        [weakSelf endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        if (operation.response.statusCode == SCAPIRequestStatusCodeNotFound)
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"您还没有收藏过任何店铺噢！" delay:0.5f];
        else
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:NetWorkError delay:0.5f];
        [weakSelf endRefresh];
    }];
}

/**
 *  取消收藏商家请求方法，必选参数：company_id，user_id
 */
- (void)startCancelCollectionMerchantRequestWithIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"company_id": ((SCMerchant *)_deleteDataCache).company_id,
                                   @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startCancelCollectionAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 根据返回结果进行相应提示
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"删除成功" delay:0.5f];
        }
        else
        {
            [weakSelf deleteFailureAtIndex:index];
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"删除失败，请重试！" delay:0.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf deleteFailureAtIndex:index];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"删除失败，请检查网络！" delay:0.5f];
    }];
}

/**
 *  商家列表预约按钮点击触发事件通知方法
 *
 *  @param notification 接受传递的参数
 */
- (void)reservationButtonPressed:(NSNotification *)notification
{
    _index = [notification.object integerValue];
    SCReservatAlertView *reservatAlertView = [[SCReservatAlertView alloc] initWithDelegate:self animation:SCAlertAnimationEnlarge];
    [reservatAlertView show];
}

#pragma mark - SCReservatAlertViewDelegate Methods
- (void)selectedWithServiceItem:(SCServiceItem *)serviceItem
{
    // 跳转到预约页面
    @try {
        [[SCUserInfo share] removeItems];
        SCMerchant *merchant = _dataList[_index];
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.merchant = [[SCMerchant alloc] initWithMerchantName:merchant.name
                                                                            companyID:merchant.company_id];
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
