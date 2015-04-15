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
    CGFloat height = ZERO_POINT;
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
- (void)startDropDownRefreshReuqest
{
    [super startDropDownRefreshReuqest];
    [self startCommentListRequest];
}

- (void)startPullUpRefreshRequest
{
    [super startPullUpRefreshRequest];
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
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
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
        [weakSelf endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        if (operation.response.statusCode == SCAPIRequestStatusCodeNotFound)
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"该商家暂时还没有任何评价噢！" delay:0.5f];
        else
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:NetWorkError delay:0.5f];
        [weakSelf endRefresh];
    }];
}

@end
