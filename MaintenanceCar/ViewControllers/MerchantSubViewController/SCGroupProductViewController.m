//
//  SCGroupProductViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductViewController.h"
#import "SCGroupProductCell.h"
#import "SCBuyGroupProductViewController.h"

@interface SCGroupProductViewController () <SCGroupProductCellDelegate>

@end

@implementation SCGroupProductViewController

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
    self.tableView.hidden = YES;
}

- (void)startGroupProductDetailRequest
{
    NSDictionary *parameters = @{@"product_id": _productID};
    [[SCAPIRequest manager] startMerchantGroupProductDetailAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - SCGroupProductCellDelegate Methods
- (void)shouldShowBuyProductView
{
    @try {
        SCBuyGroupProductViewController *buyGroupProductViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCBuyGroupProductViewController"];
        buyGroupProductViewController.productID = @"";
        [self.navigationController pushViewController:buyGroupProductViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantDetailViewController Go to the SCGroupProductViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
