//
//  SCCommentsViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/16.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCommentsViewController.h"
#import "SCCommentCell.h"

@interface SCCommentsViewController ()

@property (nonatomic, weak) SCCommentCell *commentCell;

@end

@implementation SCCommentsViewController

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

#pragma mark - Init Methods
+ (instancetype)instance
{
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameComment];
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
    WEAK_SELF(weakSelf);
    // 配置请求参数
    NSDictionary *parameters = @{@"company_id": _companyID,
                                      @"limit": @(SearchLimit),
                                     @"offset": @(self.offset)};
    [[SCAPIRequest manager] startGetMerchantCommentListAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode)
            {
                case SCAPIRequestErrorCodeNoError:
                {
                    if (weakSelf.requestType == SCRequestRefreshTypeDropDown)
                        [weakSelf clearListData];
                    // 遍历请求回来的订单数据，生成SCComment用于订单列表显示
                    [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SCComment *comment = [[SCComment alloc] initWithDictionary:obj error:nil];
                        [_dataList addObject:comment];
                    }];
                    
                    weakSelf.offset += SearchLimit;               // 偏移量请求参数递增
                    [weakSelf.tableView reloadData];                    // 数据配置完成，刷新商家列表
                    [weakSelf addRefreshHeader];
                    [weakSelf addRefreshFooter];
                }
                    break;
                    
                case SCAPIRequestErrorCodeListNotFoundMore:
                {
                    [weakSelf addRefreshHeader];
                    [weakSelf removeRefreshFooter];
                }
                    break;
            }
            if (statusMessage.length)
                [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
        }
        [weakSelf endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hanleFailureResponseWtihOperation:operation];
        [weakSelf endRefresh];
    }];
}

@end
