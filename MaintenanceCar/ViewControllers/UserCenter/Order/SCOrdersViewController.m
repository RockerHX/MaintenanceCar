//
//  SCOrdersViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrdersViewController.h"
#import "SCOrderCell.h"
#import "SCAppraiseViewController.h"
#import "SCOrderDetailViewController.h"

typedef NS_ENUM(NSUInteger, SCOrderAlertType) {
    SCOrderAlertTypeCallMerchant,
    SCOrderAlertTypeAppraiseAlert
};

@interface SCOrdersViewController () <SCOrderCellDelegate, SCAppraiseViewControllerDelegate, SCOrderDetailViewControllerDelegate>
@end

@implementation SCOrdersViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 订单"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 订单"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return ORDER_VIEW_CONTROLLER(CLASS_NAME(self));
}

#pragma mark - Config Methods
- (void)initConfig
{
    _progressDataList = [@[] mutableCopy];
    _finishedDateList = [@[] mutableCopy];
}

#pragma mark - Setter And Getter Methods
- (void)setOffset:(NSInteger)offset
{
    switch (_ordersRequest)
    {
        case SCOrdersReuqestProgress:
            _progressOffset = offset;
            break;
        case SCOrdersReuqestFinished:
            _finishedOffset = offset;
            break;
    }
}

- (NSInteger)offset
{
    switch (_ordersRequest)
    {
        case SCOrdersReuqestProgress:
            return _progressOffset;
            break;
        case SCOrdersReuqestFinished:
            return _finishedOffset;
            break;
    }
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self dataList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCOrderCell" forIndexPath:indexPath];
    
    NSArray *dataList = [self dataList];
    if (dataList.count)
        [cell displayCellWithOrder:dataList[indexPath.row] index:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ZERO_POINT;
    NSArray *dataList = [self dataList];
    if (dataList.count)
    {
        if(!_orderCell)
            _orderCell = [tableView dequeueReusableCellWithIdentifier:@"SCOrderCell"];
        height = [_orderCell displayCellWithOrder:dataList[indexPath.row] index:indexPath.row];
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SCOrderDetailViewController *orderDetailViewController = [SCOrderDetailViewController instance];
    orderDetailViewController.delegate  = self;
    orderDetailViewController.reserveID = ((SCOrder *)[self dataList][indexPath.row]).reserveID;
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
}

#pragma mark - Public Methods
- (void)startDropDownRefreshReuqest
{
    [super startDropDownRefreshReuqest];
    [self startOrdersReuqest];
}

- (void)startPullUpRefreshRequest
{
    [super startPullUpRefreshRequest];
    [self startOrdersReuqest];
}

- (void)startOrdersReuqest
{
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                   @"limit": @(SearchLimit),
                                 @"offset" : @(self.offset)};
    switch (_ordersRequest)
    {
        case SCOrdersReuqestProgress:
        {
            self.navigationTab.secondButton.enabled = NO;
            [self startProgressOrdersRequestWithParameters:parameters];
        }
            break;
        case SCOrdersReuqestFinished:
        {
            self.navigationTab.firstButton.enabled = NO;
            [self startFinishedOrdersRequestWithParameters:parameters];
        }
            break;
    }
}

- (void)clearListData
{
    [[self dataList] removeAllObjects];
}

#pragma mark - Private Methods
- (NSMutableArray *)dataList
{
    switch (_ordersRequest)
    {
        case SCOrdersReuqestProgress:
            return _progressDataList;
            break;
        case SCOrdersReuqestFinished:
            return _finishedDateList;
            break;
    }
}

/**
 *  进行中的列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startProgressOrdersRequestWithParameters:(NSDictionary *)parameters
{
    WEAK_SELF(weakSelf);
    [[SCAPIRequest manager] startProgressOrdersAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf requestSuccessWithOperation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf requestFailureWithOperation:operation];
    }];
}

/**
 *  已完成的列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startFinishedOrdersRequestWithParameters:(NSDictionary *)parameters
{
    WEAK_SELF(weakSelf);
    [[SCAPIRequest manager] startFinishedOrdersAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf requestSuccessWithOperation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf requestFailureWithOperation:operation];
    }];
}

- (void)requestSuccessWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject
{
    [self endRefresh];
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
                    SCOrder *order = [[SCOrder alloc] initWithDictionary:obj error:nil];
                    [[self dataList] addObject:order];
                }];
                
                self.offset += SearchLimit;               // 偏移量请求参数递增
                [self addRefreshHeader];
                if ([self dataList].count)
                {
                    self.tableView.hidden = NO;
                    self.promptView.hidden = YES;
                    [self displayRefreshFooter];
                }
                else
                {
                    self.tableView.hidden = YES;
                    self.promptView.hidden = NO;
                    [self removeRefreshFooter];
                }
                [self reloadListWithAnimation:(self.requestType == SCRequestRefreshTypeDropDown)];
            }
                break;
                
            case SCAPIRequestErrorCodeListNotFoundMore:
            {
                [self.tableView reloadData];
                [self addFooter];
                [self addRefreshHeader];
                [self removeRefreshFooter];
            }
                break;
        }
        if (statusMessage.length)
            [self showHUDAlertToViewController:self text:statusMessage];
    }
    switch (_ordersRequest)
    {
        case SCOrdersReuqestProgress:
            self.navigationTab.secondButton.enabled = YES;
            break;
        case SCOrdersReuqestFinished:
            self.navigationTab.firstButton.enabled = YES;
            break;
    }
}

- (void)requestFailureWithOperation:(AFHTTPRequestOperation *)operation
{
    [self hanleFailureResponseWtihOperation:operation];
    [self endRefresh];
}

- (void)pushToAppraiseViewController
{
    SCAppraiseViewController *appraiseViewController = [SCAppraiseViewController instance];
    appraiseViewController.delegate = self;
    appraiseViewController.order    = _order;
    [self.navigationController pushViewController:appraiseViewController animated:YES];
}

- (void)reloadListWithAnimation:(BOOL)animation
{
    if (animation)
    {
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionReveal;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.fillMode = kCAFillModeForwards;
        transition.duration = 0.3f;
        transition.subtype = kCATransitionFromBottom;
        [[self.tableView layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
    }
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(ZERO_POINT, ZERO_POINT)];
}

- (void)displayRefreshFooter
{
    if ([self dataList].count > 2)
        [self addRefreshFooter];
    else
        [self removeRefreshFooter];
}

#pragma mark - SCNavigationTabDelegate Methods
- (void)didSelectedItemAtIndex:(NSInteger)index title:(NSString *)title
{
    _ordersRequest = index;
    _promptLabel.text = title;
    self.tableView.hidden = NO;
    self.promptView.hidden = YES;
    if ([self dataList].count)
    {
        [self displayRefreshFooter];
        [self reloadListWithAnimation:YES];
    }
    else
    {
        [self.tableView reloadData];
        [self.tableView.header beginRefreshing];
    }
}

#pragma mark - SCOrderCellDelegate Methods
- (void)shouldCallMerchantWithPhone:(NSString *)phone
{
    [self showAlertWithTitle:@"是否拨打商家电话？" message:phone delegate:self tag:SCOrderAlertTypeCallMerchant cancelButtonTitle:@"取消" otherButtonTitle:@"拨打"];
}

- (void)shouldAppraiseWithOrder:(SCOrder *)order
{
    _order = order;
    if (_ordersRequest == SCOrdersReuqestProgress)
        [self showAlertWithTitle:@"确认要评价进行中的订单吗？" message:@"进行中订单被评价后会被自动标记为已完成，我确认这个订单实际已经完成" delegate:self tag:SCOrderAlertTypeAppraiseAlert cancelButtonTitle:@"取消" otherButtonTitle:@"继续评价"];
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
            case SCOrderAlertTypeCallMerchant:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
                break;
            case SCOrderAlertTypeAppraiseAlert:
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

#pragma mark - SCOrderDetailViewControllerDelegate Methods
- (void)shouldRefresh
{
    [self startDropDownRefreshReuqest];
}

@end
