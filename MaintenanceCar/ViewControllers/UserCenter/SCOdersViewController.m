//
//  SCOdersViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOdersViewController.h"
#import "SCOderCell.h"
#import "SCAppraiseViewController.h"
#import "SCOderDetailViewController.h"

typedef NS_ENUM(NSUInteger, SCOderAlertType) {
    SCOderAlertTypeCallMerchant,
    SCOderAlertTypeAppraiseAlert
};

@interface SCOdersViewController () <SCOderCellDelegate, SCAppraiseViewControllerDelegate, SCOderDetailViewControllerDelegate>
@end

@implementation SCOdersViewController

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

#pragma mark - Config Methods
- (void)initConfig
{
    _progressDataList = [@[] mutableCopy];
    _finishedDateList = [@[] mutableCopy];
}

#pragma mark - Setter And Getter Methods
- (void)setOffset:(NSInteger)offset
{
    switch (_odersRequest)
    {
        case SCOdersReuqestProgress:
            _progressOffset = offset;
            break;
        case SCOdersReuqestFinished:
            _finishedOffset = offset;
            break;
    }
}

- (NSInteger)offset
{
    switch (_odersRequest)
    {
        case SCOdersReuqestProgress:
            return _progressOffset;
            break;
        case SCOdersReuqestFinished:
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
    SCOderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCOderCell" forIndexPath:indexPath];
    
    NSArray *dataList = [self dataList];
    if (dataList.count)
        [cell displayCellWithOder:dataList[indexPath.row] index:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ZERO_POINT;
    NSArray *dataList = [self dataList];
    if (dataList.count)
    {
        if(!_oderCell)
            _oderCell = [tableView dequeueReusableCellWithIdentifier:@"SCOderCell"];
        height = [_oderCell displayCellWithOder:dataList[indexPath.row] index:indexPath.row];
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SCOderDetailViewController *oderDetailViewController = USERCENTER_VIEW_CONTROLLER(@"SCOderDetailViewController");
    oderDetailViewController.delegate  = self;
    oderDetailViewController.reserveID = ((SCOder *)[self dataList][indexPath.row]).reserveID;
    [self.navigationController pushViewController:oderDetailViewController animated:YES];
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
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                   @"limit": @(SearchLimit),
                                 @"offset" : @(self.offset)};
    switch (_odersRequest)
    {
        case SCOdersReuqestProgress:
            [self startProgressOdersRequestWithParameters:parameters];
            break;
        case SCOdersReuqestFinished:
            [self startFinishedOdersRequestWithParameters:parameters];
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
    switch (_odersRequest)
    {
        case SCOdersReuqestProgress:
            return _progressDataList;
            break;
        case SCOdersReuqestFinished:
            return _finishedDateList;
            break;
    }
}

/**
 *  进行中的列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startProgressOdersRequestWithParameters:(NSDictionary *)parameters
{
    __weak typeof(self) weakSelf = self;
    [[SCAPIRequest manager] startMyProgressOdersAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf requestSuccessWithOperation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf requestFailureWithOperation:operation];
    }];
}

/**
 *  已完成的列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startFinishedOdersRequestWithParameters:(NSDictionary *)parameters
{
    __weak typeof(self) weakSelf = self;
    [[SCAPIRequest manager] startMyFinishedOdersAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                    SCOder *oder = [[SCOder alloc] initWithDictionary:obj error:nil];
                    [[self dataList] addObject:oder];
                }];
                
                self.offset += SearchLimit;               // 偏移量请求参数递增
                [self addRefreshHeader];
                if ([self dataList].count)
                {
                    self.tableView.hidden = NO;
                    self.promptView.hidden = YES;
                    if ([self dataList].count > 2)
                        [self addRefreshFooter];
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
        if (![statusMessage isEqualToString:@"success"])
            [self showHUDAlertToViewController:self text:statusMessage];
    }
}

- (void)requestFailureWithOperation:(AFHTTPRequestOperation *)operation
{
    [self hanleFailureResponseWtihOperation:operation];
    [self endRefresh];
}

- (void)pushToAppraiseViewController
{
    SCAppraiseViewController *appraiseViewController = USERCENTER_VIEW_CONTROLLER(@"SCAppraiseViewController");
    appraiseViewController.delegate                  = self;
    appraiseViewController.oder                      = _oder;
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

#pragma mark - SCNavigationTabDelegate Methods
- (void)didSelectedItemAtIndex:(NSInteger)index title:(NSString *)title
{
    _odersRequest = index;
    _promptLabel.text = title;
    self.tableView.hidden = NO;
    self.promptView.hidden = YES;
    if (![self dataList].count)
    {
        [self.tableView reloadData];
        [self.tableView.header beginRefreshing];
    }
    else
        [self reloadListWithAnimation:YES];
}

#pragma mark - SCOderCellDelegate Methods
- (void)shouldCallMerchantWithPhone:(NSString *)phone
{
    [self showAlertWithTitle:@"是否拨打商家电话？" message:phone delegate:self tag:SCOderAlertTypeCallMerchant cancelButtonTitle:@"取消" otherButtonTitle:@"拨打"];
}

- (void)shouldAppraiseWithOder:(SCOder *)oder
{
    _oder = oder;
    if (_odersRequest == SCOdersReuqestProgress)
        [self showAlertWithTitle:@"确认要评价进行中的订单吗？" message:@"进行中订单被评价后会被自动标记为已完成，我确认这个订单实际已经完成" delegate:self tag:SCOderAlertTypeAppraiseAlert cancelButtonTitle:@"取消" otherButtonTitle:@"继续评价"];
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
            case SCOderAlertTypeCallMerchant:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
                break;
            case SCOderAlertTypeAppraiseAlert:
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

#pragma mark - SCOderDetailViewControllerDelegate Methods
- (void)shouldRefresh
{
    [self startDropDownRefreshReuqest];
}

@end
