//
//  SCCommentListViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/16.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCommentListViewController.h"
#import "SCCommentCell.h"

@interface SCCommentListViewController ()

@property (nonatomic, weak) SCCommentCell *commentCell;

@end

@implementation SCCommentListViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[评价] - 商家评价列表"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[评价] - 商家评价列表"];
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
    SCCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCommentCell" forIndexPath:indexPath];
    [cell displayCellWithComment:_dataList[indexPath.row]];
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = DOT_COORDINATE;
    CGFloat separatorHeight = 1.0f;
    if (_dataList.count)
    {
        if(!_commentCell)
            _commentCell = [tableView dequeueReusableCellWithIdentifier:@"SCCommentCell"];
        [_commentCell displayCellWithComment:_dataList[indexPath.row]];
        // Layout the cell
        [_commentCell updateConstraintsIfNeeded];
        [_commentCell layoutIfNeeded];
        height = [_commentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    
    return height + separatorHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @try {
//        SCCoupon *coupon = _dataList[indexPath.row];
//        SCCouponDetailViewController *couponDetailViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCCouponDetailViewController"];
//        couponDetailViewController.coupon = coupon;
//        [self.navigationController pushViewController:couponDetailViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMyCouponViewController Go to the SCCouponDetailViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Public Methods
/**
 *  下拉刷新，请求最新数据
 */
- (void)startDownRefreshReuqest
{
    [super startDownRefreshReuqest];
    
    // 刷新前把数据偏移量offset设置为0，设置刷新类型，以便请求最新数据
    self.offset = Zero;
    self.requestType = SCFavoriteListRequestTypeDown;
    [self startCommentListRequest];
}

/**
 *  上拉刷新，加载更多数据
 */
- (void)startUpRefreshRequest
{
    [super startUpRefreshRequest];
    
    // 设置刷新类型
    self.requestType = SCFavoriteListRequestTypeUp;
    [self startCommentListRequest];
}

#pragma mark - Private Methods
- (void)startCommentListRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"company_id": _companyID,
                                 @"limit"  : @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startGetMerchantCommentListAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            // 如果是下拉刷新数据，先清空列表，在做数据处理
            if (weakSelf.requestType == SCFavoriteListRequestTypeDown)
                [weakSelf clearListData];
            
            // 遍历请求回来的订单数据，生成SCComment用于订单列表显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCComment *comment = [[SCComment alloc] initWithDictionary:obj error:nil];
                [_dataList addObject:comment];
            }];
            
            [weakSelf.tableView reloadData];        // 数据配置完成，刷新商家列表
            weakSelf.offset += MerchantListLimit;   // 偏移量请求参数递增
        }
        else
        {
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:responseObject[@"error"] delay:0.5f];
        }
        [weakSelf hiddenHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf hiddenHUD];
        if (operation.response.statusCode == SCAPIRequestStatusCodeNotFound)
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"该商家暂时还没有任何评价噢！" delay:0.5f];
        else
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:NetWorkError delay:0.5f];
    }];
}

@end
