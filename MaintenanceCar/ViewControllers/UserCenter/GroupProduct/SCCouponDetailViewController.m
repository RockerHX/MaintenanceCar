//
//  SCCouponDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponDetailViewController.h"
#import "SCCoupon.h"
#import "SCGroupProductDetail.h"
#import "SCCouponCell.h"
#import "SCBuyGroupProductCell.h"
#import "SCGroupProductMerchantCell.h"
#import "SCGroupProductDetailCell.h"
#import "SCBuyGroupProductViewController.h"

@interface SCCouponDetailViewController ()
{
    
    BOOL                 _loadFinish;
    SCGroupProductDetail *_detail;
}
@property (weak, nonatomic) SCGroupProductMerchantCell *merchantCell;
@property (weak, nonatomic)   SCGroupProductDetailCell *detailCell;

@end

@implementation SCCouponDetailViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 团购券详情"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 团购券详情"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
    if (IS_IOS8)
    {
        self.tableView.estimatedRowHeight = 120.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    _loadFinish = YES;
}

- (void)viewConfig
{
    [self.tableView reLayoutHeaderView];
    [self startCouponDetailRequest];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _detail ? 4 : Zero;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_detail)
    {
        switch (indexPath.section)
        {
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCodeCell" forIndexPath:indexPath];
                [(SCCouponCell *)cell displayCellWithCoupon:_coupon];
            }
                break;
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupProductMerchantCell" forIndexPath:indexPath];
                [(SCGroupProductMerchantCell *)cell displayCellWithDetial:_detail];
            }
                break;
            case 3:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupProductDetailCell" forIndexPath:indexPath];
                [(SCGroupProductDetailCell *)cell displayCellWithDetail:_detail];
            }
                break;
                
            default:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCBuyGroupProductCell" forIndexPath:indexPath];
                [(SCBuyGroupProductCell *)cell displayCellWithDetail:_detail];
            }
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IOS8)
    {
        if (!indexPath.section)
            return 70.0f;
        else if (indexPath.section == 1)
            return 44.0f;
            
        return UITableViewAutomaticDimension;
    }
    else
    {
        CGFloat height = DOT_COORDINATE;
        CGFloat separatorHeight = 1.0f;
        if (_detail)
        {
            switch (indexPath.section)
            {
                case 1:
                {
                    if(!_merchantCell)
                        _merchantCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCGroupProductMerchantCell"];
                    [_merchantCell displayCellWithDetial:_detail];
                    // Layout the cell
                    [_merchantCell updateConstraintsIfNeeded];
                    [_merchantCell layoutIfNeeded];
                    height = [_merchantCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                }
                    break;
                case 2:
                {
                    if(!_detailCell)
                        _detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"SCGroupProductDetailCell"];
                    [_detailCell displayCellWithDetail:_detail];
                    // Layout the cell
                    [_detailCell updateConstraintsIfNeeded];
                    [_detailCell layoutIfNeeded];
                    height = [_detailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                }
                    break;
                    
                default:
                {
                    if (!indexPath.section)
                        return indexPath.section ? 44.0f : 70.0f;
                }
                    break;
            }
        }
        
        return height + separatorHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section)
        return DOT_COORDINATE;
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *text  = @"";
    UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 30.0f)];
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, DOT_COORDINATE, 100.0f, 30.0f)];
    label.font      = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    switch (section)
    {
        case 1:
            text = @"团购券信息";
            break;
        case 2:
            text = @"商家详情";
            break;
        case 3:
            text = @"团购详情";
            break;
            
        default:
            text = @"";
            break;
    }
    label.text = text;
    return view;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ((indexPath.row == 0 && indexPath.section == 3) && _loadFinish && IS_IOS8)
    {
        [self.tableView scrollRectToVisible:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 1.0f, 1.0f) animated:NO];
        _loadFinish = NO;
    }
}

#pragma mark - Private Methods
- (void)startCouponDetailRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakSelf = self;
    NSDictionary *parameters = @{@"product_id": _coupon.product_id};
    [[SCAPIRequest manager] startMerchantGroupProductDetailAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _detail = [[SCGroupProductDetail alloc] initWithDictionary:responseObject error:nil];
            _detail.companyID = _coupon.company_id;
            _detail.merchantName = _coupon.company_name;
            [self.tableView reloadData];
            if (IS_IOS8)
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - SCGroupProductCellDelegate Methods
- (void)shouldShowBuyProductView
{
    @try {
        SCBuyGroupProductViewController *buyGroupProductViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCBuyGroupProductViewController"];
        buyGroupProductViewController.groupProductDetail = _detail;
        [self.navigationController pushViewController:buyGroupProductViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantDetailViewController Go to the SCGroupProductViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
