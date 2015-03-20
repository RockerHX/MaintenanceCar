//
//  SCMyReservationTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyReservationTableViewController.h"
#import "SCReservation.h"
#import "SCOderNormalCell.h"
#import "SCOderUnAppraisalCell.h"
#import "SCOderAppraisedCell.h"
#import "SCOderUnAppraisalCheckCell.h"
#import "SCOderAppraisedCheckCell.h"
#import "SCWebViewController.h"
#import "SCMerchant.h"
#import "SCMerchantDetailViewController.h"
#import "SCAppraiseViewController.h"

@interface SCMyReservationTableViewController () <SCOderUnAppraisalCellDelegate, SCAppraiseViewControllerDelegate>

@property (weak, nonatomic)           SCOderNormalCell *oderNormalCell;
@property (weak, nonatomic)      SCOderUnAppraisalCell *unappraisalCell;
@property (weak, nonatomic)        SCOderAppraisedCell *appraisedCell;
@property (weak, nonatomic) SCOderUnAppraisalCheckCell *unappraisalCheckCell;
@property (weak, nonatomic)   SCOderAppraisedCheckCell *appraisedCheckCell;

@end

@implementation SCMyReservationTableViewController

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
    SCOderCell *cell = nil;
    SCReservation *reservation = _dataList[indexPath.row];
    switch ([reservation oderType])
    {
        case SCOderTypeUnAppraisal:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SCOderUnAppraisalCell" forIndexPath:indexPath];
            ((SCOderUnAppraisalCell *)cell).delegate = self;
            [cell displayCellWithReservation:reservation];
        }
            break;
        case SCOderTypeAppraised:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SCOderAppraisedCell" forIndexPath:indexPath];
            [cell displayCellWithReservation:reservation];
        }
            break;
        case SCOderTypeUnAppraisalCheck:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SCOderUnAppraisalCheckCell" forIndexPath:indexPath];
            ((SCOderUnAppraisalCheckCell *)cell).delegate = self;
            [cell displayCellWithReservation:reservation];
        }
            break;
        case SCOderTypeAppraisedCheck:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SCOderAppraisedCheckCell" forIndexPath:indexPath];
            [cell displayCellWithReservation:reservation];
        }
            break;
            
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SCOderNormalCell" forIndexPath:indexPath];
            [cell displayCellWithReservation:reservation];
        }
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 自定义按钮必须要此方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCReservation *reservation = _dataList[indexPath.row];
    if ([reservation canUnReservation])
    {
        // 如果用户经行删除或者滑动删除操作，设置数据缓存，并进行相关删除操作请求，同步服务器数据
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            _deleteDataCache = _dataList[indexPath.row];        // 设置数据缓存
            [_dataList removeObjectAtIndex:indexPath.row];      // 清楚数据
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];   // 列表中删除相关数据行
            [self startCancelReservationRequestWithIndex:indexPath.row];                                    // 同步服务器
        }
    }
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = DOT_COORDINATE;
    CGFloat separatorHeight = 1.0f;
    if (_dataList.count)
    {
        SCReservation *reservation = _dataList[indexPath.row];
        switch ([reservation oderType])
        {
            case SCOderTypeUnAppraisal:
            {
                if(!_unappraisalCell)
                    _unappraisalCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCOderUnAppraisalCell"];
                [_unappraisalCell displayCellWithReservation:reservation];
                // Layout the cell
                [_unappraisalCell updateConstraintsIfNeeded];
                [_unappraisalCell layoutIfNeeded];
                height = [_unappraisalCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
                break;
            case SCOderTypeAppraised:
            {
                if(!_appraisedCell)
                    _appraisedCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCOderAppraisedCell"];
                [_appraisedCell displayCellWithReservation:reservation];
                // Layout the cell
                [_appraisedCell updateConstraintsIfNeeded];
                [_appraisedCell layoutIfNeeded];
                height = [_appraisedCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
                break;
            case SCOderTypeUnAppraisalCheck:
            {
                if(!_unappraisalCheckCell)
                    _unappraisalCheckCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCOderUnAppraisalCheckCell"];
                [_unappraisalCheckCell displayCellWithReservation:reservation];
                // Layout the cell
                [_unappraisalCheckCell updateConstraintsIfNeeded];
                [_unappraisalCheckCell layoutIfNeeded];
                height = [_unappraisalCheckCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
                break;
            case SCOderTypeAppraisedCheck:
            {
                if(!_appraisedCheckCell)
                    _appraisedCheckCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCOderAppraisedCheckCell"];
                [_appraisedCheckCell displayCellWithReservation:reservation];
                // Layout the cell
                [_appraisedCheckCell updateConstraintsIfNeeded];
                [_appraisedCheckCell layoutIfNeeded];
                height = [_appraisedCheckCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
                break;
                
            default:
            {
                if(!_oderNormalCell)
                    _oderNormalCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCOderNormalCell"];
                [_oderNormalCell displayCellWithReservation:reservation];
                // Layout the cell
                [_oderNormalCell updateConstraintsIfNeeded];
                [_oderNormalCell layoutIfNeeded];
                height = [_oderNormalCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
                break;
        }
    }
    
    return height + separatorHeight;
}

- (NSString *)deleteTitleWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *deleteTitle      = nil;
    SCReservation *reservation = _dataList[indexPath.row];
    switch (reservation.oderStatus)
    {
        case SCOderStatusMerchantUnAccepted:
            deleteTitle = @"未接受";
            break;
        case SCOderStatusInProgress:
            deleteTitle = @"进行中";
            break;
        case SCOderStatusServationCancel:
            deleteTitle = @"已取消";
            break;
        case SCOderStatusCompleted:
            deleteTitle = @"已完成";
            break;
        case SCOderStatusExpired:
            deleteTitle = @"已过期";
            break;
            
        default:
            deleteTitle = @"取消预约";
            break;
    }
    return deleteTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self deleteTitleWithIndexPath:indexPath];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCReservation *reservation = _dataList[indexPath.row];
    BOOL canUnreservation = [reservation canUnReservation];
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[self deleteTitleWithIndexPath:indexPath] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if (canUnreservation)
        {
            _deleteDataCache = reservation;                     // 设置数据缓存
            [_dataList removeObjectAtIndex:indexPath.row];      // 清楚数据
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];   // 列表中删除相关数据行
            [self startCancelReservationRequestWithIndex:indexPath.row];                                    // 同步服务器
        }
    }];
    button.backgroundColor = canUnreservation ? [UIColor redColor] : [UIColor grayColor];
    
    return @[button];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SCReservation *reservation = _dataList[indexPath.row];
    if ([reservation canShowResult])
    {
        // 列表被点击跳转到商家详情
        @try {
            SCWebViewController *webViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCWebViewController"];
            webViewController.title = @"检测结果";
            webViewController.loadURL = [NSString stringWithFormat:@"%@/%@/%@", InspectionURL, [SCUserInfo share].userID, reservation.user_car_id];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCMyReservationTableViewController Go to the SCWebViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
    else
    {
        // 跳转到预约页面
        @try {
            SCMerchantDetailViewController *merchantDetialViewControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:MerchantDetailViewControllerStoryBoardID];
            merchantDetialViewControler.merchant = [[SCMerchant alloc] initWithMerchantName:reservation.name companyID:reservation.company_id];
            [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCMyReservationTableViewController Go to the SCMerchantDetailViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
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
    [self startReservationListRequest];
}

/**
 *  上拉刷新，加载更多数据
 */
- (void)startUpRefreshRequest
{
    [super startUpRefreshRequest];
    
    // 设置刷新类型
    self.requestType = SCFavoriteListRequestTypeUp;
    [self startReservationListRequest];
}

#pragma mark - Private Methods
/**
 *  预约列表数据请求方法，必选参数：user_id，limit，offset
 */
- (void)startReservationListRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"limit"  : @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startGetMyReservationAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            // 如果是下拉刷新数据，先清空列表，在做数据处理
            if (weakSelf.requestType == SCFavoriteListRequestTypeDown)
                [weakSelf clearListData];
            
            // 遍历请求回来的订单数据，生成SCReservation用于订单列表显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCReservation *reservation = [[SCReservation alloc] initWithDictionary:obj error:nil];
                [_dataList addObject:reservation];
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
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"您还没有下过任何订单噢！" delay:0.5f];
        else
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:NetWorkError delay:0.5f];
    }];
}

/**
 *  取消预约请求方法，必选参数：company_id，user_id，reserve_id，status
 */
- (void)startCancelReservationRequestWithIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"user_id": [SCUserInfo share].userID,
                             @"company_id": ((SCReservation *)_deleteDataCache).company_id,
                             @"reserve_id": ((SCReservation *)_deleteDataCache).reserve_id,
                                 @"status": @"4"};
    [[SCAPIRequest manager] startUpdateReservationAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 根据返回结果进行相应提示
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            SCReservation *reservation = _deleteDataCache;
            reservation.status         = @"预约已取消";
            [weakSelf deleteFailureAtIndex:index];
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"您取消预约成功" delay:0.5f];
        }
        else
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"取消预约失败，请重试！" delay:0.5f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf deleteFailureAtIndex:index];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"取消预约失败，请重试！" delay:0.5f];
    }];
}

#pragma mark - SCOderUnAppraisalCellDelegate Methods
- (void)shouldAppraiseOderWithReservation:(SCReservation *)reservation
{
    // 跳转到预约页面
    @try {
        SCAppraiseViewController *appraiseViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCAppraiseViewController"];
        appraiseViewController.delegate = self;
        appraiseViewController.reservation = reservation;
        [self.navigationController pushViewController:appraiseViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMyReservationTableViewController Go to the SCAppraiseViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - SCAppraiseViewControllerDelegate Methods
- (void)appraiseSuccess
{
    [self startDownRefreshReuqest];
}

@end
