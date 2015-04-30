//
//  SCMyOderViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOderViewController.h"
#import "SCMyOderCell.h"
#import "SCAppraiseViewController.h"
#import "SCMyOderDetailViewController.h"

typedef NS_ENUM(NSUInteger, SCMyOderAlertType) {
    SCMyOderAlertTypeCallMerchant,
    SCMyOderAlertTypeAppraiseAlert
};

@interface SCMyOderViewController () <SCMyOderCellDelegate, SCAppraiseViewControllerDelegate, SCMyOderDetailViewControllerDelegate>
@end

@implementation SCMyOderViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 我的订单"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 我的订单"];
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
    SCMyOderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMyOderCell" forIndexPath:indexPath];;
    if (_dataList.count)
        [cell displayCellWithOder:_dataList[indexPath.row] index:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (_dataList.count)
    {
        if(!_myOderCell)
            _myOderCell = [tableView dequeueReusableCellWithIdentifier:@"SCMyOderCell"];
        height = [_myOderCell displayCellWithOder:_dataList[indexPath.row] index:indexPath.row];
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @try {
        SCMyOder *oder = _dataList[indexPath.row];
        SCMyOderDetailViewController *myOderDetailViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMyOderDetailViewController"];
        myOderDetailViewController.delegate  = self;
        myOderDetailViewController.reserveID = oder.reserveID;
        [self.navigationController pushViewController:myOderDetailViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMyOderViewController Go to the SCMyOderDetailViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Public Methods
- (void)startDropDownRefreshReuqest
{
    [super startDropDownRefreshReuqest];
    [self startOdersReuqest];
}

- (void)startPullUpRefreshRequest
{
    [super startPullUpRefreshRequest];
    [self startOdersReuqest];
}

- (void)startOdersReuqest
{
    switch (_myOderRequest)
    {
        case SCMyOderReuqestProgress:
            [self startProgressOdersRequest];
            break;
        case SCMyOderReuqestFinished:
            [self startFinishedOdersRequest];
            break;
    }
}

#pragma mark - Private Methods
/**
 *  进行中的列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startProgressOdersRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"limit": @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startMyProgressOdersAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf requestSuccessWithOperation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf requestFailureWithOperation:operation];
    }];
}

/**
 *  已完成的列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startFinishedOdersRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                   @"limit": @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startMyFinishedOdersAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf requestSuccessWithOperation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf requestFailureWithOperation:operation];
    }];
}

- (void)requestSuccessWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject
{
    if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
    {
        NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
        NSString *statusMessage = responseObject[@"status_message"];
        switch (statusCode)
        {
            case SCAPIRequestErrorCodeNoError:
            {
                if (self.requestType == SCRequestRefreshTypeDropDown)
                    [self clearListData];
                [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCMyOder *oder = [[SCMyOder alloc] initWithDictionary:obj error:nil];
                    [_dataList addObject:oder];
                }];
                
                self.offset += MerchantListLimit;               // 偏移量请求参数递增
                [self.tableView reloadData];                    // 数据配置完成，刷新商家列表
                [self addRefreshHeader];
                [self addRefreshFooter];
            }
                break;
                
            case SCAPIRequestErrorCodeListNotFoundMore:
            {
                [self addFooter];
                [self addRefreshHeader];
                [self removeRefreshFooter];
            }
                break;
        }
        if (![statusMessage isEqualToString:@"success"])
            [self showHUDAlertToViewController:self text:statusMessage];
    }
    [self endRefresh];
}

- (void)requestFailureWithOperation:(AFHTTPRequestOperation *)operation
{
    [self hanleFailureResponseWtihOperation:operation];
    [self endRefresh];
}

- (void)pushToAppraiseViewController
{
    // 跳转到评论页面
    @try {
        SCAppraiseViewController *appraiseViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCAppraiseViewController"];
        appraiseViewController.delegate                  = self;
        appraiseViewController.oder                      = _oder;
        [self.navigationController pushViewController:appraiseViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMyOderViewController Go to the SCAppraiseViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - SCNavigationTabDelegate Methods
- (void)didSelectedItemAtIndex:(NSInteger)index
{
    _myOderRequest = index;
    [self restartDropDownRefreshRequest];
}

#pragma mark - SCMyOderCellDelegate Methods
- (void)shouldCallMerchantWithPhone:(NSString *)phone
{
    [self showAlertWithTitle:@"是否拨打商家电话？" message:phone delegate:self tag:SCMyOderAlertTypeCallMerchant cancelButtonTitle:@"取消" otherButtonTitle:@"拨打"];
}

- (void)shouldAppraiseWithOder:(SCMyOder *)oder
{
    _oder = oder;
    if (_myOderRequest == SCMyOderReuqestProgress)
        [self showAlertWithTitle:@"确认要评价进行中的订单吗？" message:@"进行中订单被评价后会被自动标记为已完成，我确认这个订单实际已经完成" delegate:self tag:SCMyOderAlertTypeAppraiseAlert cancelButtonTitle:@"取消" otherButtonTitle:@"继续评价"];
    else
        [self pushToAppraiseViewController];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        switch (alertView.tag)
        {
            case SCMyOderAlertTypeCallMerchant:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
                break;
            case SCMyOderAlertTypeAppraiseAlert:
                [self pushToAppraiseViewController];
                break;
            case SCViewControllerAlertTypeNeedLogin:
                [self checkShouldLogin];
                break;
        }
    }
}

#pragma mark - SCAppraiseViewControllerDelegate Methods
- (void)appraiseSuccess
{
    [self startDropDownRefreshReuqest];
}

#pragma mark - SCMyOderDetailViewControllerDelegate Methods
- (void)shouldRefresh
{
    [self startDropDownRefreshReuqest];
}

@end
