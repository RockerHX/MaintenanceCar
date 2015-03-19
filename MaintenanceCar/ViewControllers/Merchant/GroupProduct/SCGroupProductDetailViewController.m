//
//  SCGroupProductDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductDetailViewController.h"
#import "SCGroupProductDetail.h"
#import "SCBuyGroupProductCell.h"
#import "SCGroupProductMerchantCell.h"
#import "SCGroupProductDetailCell.h"
#import "SCBuyGroupProductViewController.h"

@interface SCGroupProductDetailViewController () <SCBuyGroupProductCellDelegate>
{
    SCGroupProductDetail *_detail;
}
@property (weak, nonatomic) SCGroupProductMerchantCell *merchantCell;
@property (weak, nonatomic)   SCGroupProductDetailCell *detailCell;

@end

@implementation SCGroupProductDetailViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[团购] - 团购详情"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[团购] - 团购详情"];
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
}

- (void)viewConfig
{
    [self.tableView reLayoutHeaderView];
    [self startGroupProductDetailRequest];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _detail ? 3 : Zero;
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
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupProductMerchantCell" forIndexPath:indexPath];
                [(SCGroupProductMerchantCell *)cell displayCellWithDetial:_detail];
            }
                break;
            case 2:
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
                return 70.0f;
                break;
        }
    }
    
    return height + separatorHeight;
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
            text = @"商家信息";
            break;
        case 2:
            text = @"团购详情";
            break;
            
        default:
            return nil;
            break;
    }
    label.text = text;
    return view;
}

#pragma mark - Private Methods
- (void)startGroupProductDetailRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakSelf = self;
    NSDictionary *parameters = @{@"product_id": _product.product_id};
    [[SCAPIRequest manager] startMerchantGroupProductDetailAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _detail = [[SCGroupProductDetail alloc] initWithDictionary:responseObject error:nil];
            _detail.companyID = _product.companyID;
            _detail.merchantName = _product.merchantName;
            [self.tableView reloadData];
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
