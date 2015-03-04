//
//  SCGroupProductDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductDetailViewController.h"
#import "SCGroupProductDetail.h"
#import "SCGroupProductDetailCell.h"
#import "SCBuyGroupProductViewController.h"

@interface SCGroupProductDetailViewController () <SCGroupProductCellDetailDelegate>

@property (nonatomic, strong) SCGroupProductDetail *detail;

@end

@implementation SCGroupProductDetailViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[团购]"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"[团购]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initConfig
{
    
}

- (void)viewConfig
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startGroupProductDetailRequest];
}

- (void)startGroupProductDetailRequest
{
    __weak typeof(self)weakSelf = self;
    NSDictionary *parameters = @{@"product_id": _product.product_id};
    [[SCAPIRequest manager] startMerchantGroupProductDetailAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _detail = [[SCGroupProductDetail alloc] initWithDictionary:responseObject error:nil];
            _detail.companyID = _product.companyID;
            _detail.merchantName = _product.merchantName;
            [weakSelf displayGroupProductDetail];
        }
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

- (void)displayGroupProductDetail
{
    _detailCell.productNameLabel.text  = _detail.title;
    _detailCell.groupPriceLabel.text   = _detail.final_price;
    _detailCell.productPriceLabel.text = _detail.total_price;
}

#pragma mark - SCGroupProductCellDelegate Methods
- (void)shouldShowBuyProductView
{
    @try {
        SCBuyGroupProductViewController *buyGroupProductViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCBuyGroupProductViewController"];
        buyGroupProductViewController.groupProducDetail= _detail;
        [self.navigationController pushViewController:buyGroupProductViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantDetailViewController Go to the SCGroupProductViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
