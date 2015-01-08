//
//  SCMyFavoriteTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyFavoriteTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MJRefresh.h"
#import "MicroCommon.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"
#import "SCMerchant.h"
#import "SCMerchantTableViewCell.h"
#import "SCMerchantDetailViewController.h"
#import "SCLocationInfo.h"

typedef NS_ENUM(NSInteger, SCFavoriteListRequestType) {
    SCFavoriteListRequestTypeUp = 100,
    SCFavoriteListRequestTypeDown = 101
};

@interface SCMyFavoriteTableViewController ()
{
    SCMerchant        *_deleteMerchant;    // 删除数据的缓存
    NSMutableArray    *_merchantList;      // 收藏的商户数据缓存
}

@property (nonatomic, assign) NSInteger                 offset;         // 商户列表请求偏移量，用户上拉刷新的分页请求操作
@property (nonatomic, assign) SCFavoriteListRequestType requestType;    // 请求类型，是上拉刷新还是下拉刷新

@end

@implementation SCMyFavoriteTableViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];      // 加载响应式控件
    
    [self initConfig];
    
    if ([SCLocationInfo shareLocationInfo].userLocation)
    {
        [self startMerchantCollectionListRequest];
    }

    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新控件
    [self.tableView addHeaderWithCallback:^{
        weakSelf.offset = 0;
        weakSelf.requestType = SCFavoriteListRequestTypeDown;
        [weakSelf startMerchantCollectionListRequest];
    }];
    // 添加上拉刷新控件
    [self.tableView addFooterWithCallback:^{
        weakSelf.requestType = SCFavoriteListRequestTypeUp;
        [weakSelf startMerchantCollectionListRequest];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _merchantList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier forIndexPath:indexPath];
    
    // 刷新商户列表
    SCMerchant *merchant = _merchantList[indexPath.row];
    cell.merchantNameLabel.text = merchant.name;
    cell.distanceLabel.text = merchant.distance;
    cell.reservationButton.tag = indexPath.row;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _deleteMerchant = _merchantList[indexPath.row];
        [_merchantList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self startUnCollectionMerchantRequestWithIndex:indexPath.row];
    }
}

#pragma mark - Table View Delegate Methods
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到预约页面
    @try {
        SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
        merchantDetialViewControler.companyID = ((SCMerchant *)_merchantList[indexPath.row]).company_id;
        [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
    }
    @catch (NSException *exception) {
        SCException(@"SCMyFavoriteTableViewController Go to the SCMerchantDetailViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Action Methods
#pragma mark -
- (IBAction)deleteFavoriteMerchant:(UIBarButtonItem *)sender
{
    [self changeListEditStatus];
}

#pragma mark - KVO Methods
#pragma makr -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userLocation"])
    {
        if ([SCLocationInfo shareLocationInfo].userLocation && change[NSKeyValueChangeNewKey])
        {
            [self startMerchantCollectionListRequest];
        }
        else if ([SCLocationInfo shareLocationInfo].locationFailure)
        {
            [self startMerchantCollectionListRequest];
        }
    }
}

#pragma mark - Private Methods
#pragma mark -
- (void)initConfig
{
    _merchantList = [@[] mutableCopy];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 监听SCLocationInfo单例的userLocation属性，观察定位是否成功
    [[SCLocationInfo shareLocationInfo] addObserver:self forKeyPath:@"userLocation" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)clearList
{
    [_merchantList removeAllObjects];
}

- (void)changeListEditStatus
{
    self.tableView.editing = !self.tableView.editing;
}

- (void)deleteFailureWithIndex:(NSInteger)index
{
    self.tableView.editing = NO;
    [_merchantList insertObject:_deleteMerchant atIndex:index];
    [self.tableView reloadData];
}

/**
 *  收藏列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startMerchantCollectionListRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"limit"  : @(MerchantListLimit),
                                 @"offset" : @(_offset)};
    
    [[SCAPIRequest manager] startGetCollectionMerchantAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            // 如果是下拉刷新数据，先清空列表，在做数据处理
            if (weakSelf.requestType == SCFavoriteListRequestTypeDown)
            {
                [weakSelf clearList];
            }
            
            SCLog(@"Collection Merchent List Request Data:%@", responseObject);
            // 遍历请求回来的商户数据，生成SCMerchant用于商户列表显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error       = nil;
                SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj error:&error];
                SCFailure(@"weather model parse error:%@", error);
                [_merchantList addObject:merchant];
            }];
            
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];              // 请求完成，移除响应式控件
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:_offset ? UITableViewRowAnimationTop : UITableViewRowAnimationFade];                                   // 数据配置完成，刷新商户列表
            _offset += MerchantListLimit;                                       // 偏移量请求参数递增
        }
        else
        {
            SCFailure(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
            ShowPromptHUDWithText(weakSelf.navigationController.view, responseObject[@"error"], 1.0f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCFailure(@"Get merchant list request error:%@", error);
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"网络错误，请重试！", 1.0f);
    }];
}

/**
 *  取消收藏商户，必选参数：company_id，user_id
 */
- (void)startUnCollectionMerchantRequestWithIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"company_id": _deleteMerchant.company_id,
                                   @"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startMerchantUnCollectionAPIRequestWithParameters:paramters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 根据返回结果进行相应提示
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"删除成功", 1.0f);
        }
        else
        {
            [self deleteFailureWithIndex:index];
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"删除失败，请重试", 1.0f);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self deleteFailureWithIndex:index];
        ShowPromptHUDWithText(weakSelf.navigationController.view, @"删除失败，请检查网络", 1.0f);
    }];
}

@end
