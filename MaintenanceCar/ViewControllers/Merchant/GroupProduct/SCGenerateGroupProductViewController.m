//
//  SCGenerateGroupProductViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/7.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGenerateGroupProductViewController.h"
#import "SCGroupProductDetailViewController.h"
#import "SCGroupProductDetail.h"
#import "SCGroupProductTicket.h"

@interface SCGenerateGroupProductViewController ()

@end

@implementation SCGenerateGroupProductViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[团购] - 生成团购券"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"[团购] - 生成团购券"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewConfig];
}

#pragma mark - Action Methods
- (IBAction)returnButtonPressed:(id)sender
{
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[SCGroupProductDetailViewController class]])
            [self.navigationController popToViewController:viewController animated:YES];
    }
}

#pragma mark - Private Methods
- (void)initConfig
{
    
}

- (void)viewConfig
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startGenerateGroupProductRequest];
}

- (void)startGenerateGroupProductRequest
{
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"company_id": _groupProductDetail.companyID,
                                 @"product_id": _groupProductDetail.product_id,
                                 @"content": _groupProductDetail.title,
                                 @"old_price": _groupProductDetail.total_price,
                                 @"price": _groupProductDetail.final_price,
                                 @"limit_begin": _groupProductDetail.limit_begin,
                                 @"limit_end": _groupProductDetail.limit_end,
                                 @"how_many": @(_productCount),
                                 @"mobile": [USER_DEFAULT objectForKey:kPhoneNumberKey],
                                 @"order_id": _groupProductDetail.outTradeNo};
    [[SCAPIRequest manager] startGenerateGroupProductAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            NSLog(@"%@", responseObject);
            SCGroupProductTicket *ticket = [[SCGroupProductTicket alloc] initWithDictionary:responseObject error:nil];
            [self displayTicketWithTicket:ticket];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)displayTicketWithTicket:(SCGroupProductTicket *)ticket
{
    _merchantNameLabel.text = _groupProductDetail.merchantName;
    _productNameLabel.text  = _groupProductDetail.title;
    _groupPriceLabel.text   = [NSString stringWithFormat:@"%.2f", ([_groupProductDetail.final_price doubleValue] * _productCount)];
    _productPriceLabel.text = [NSString stringWithFormat:@"%.2f", ([_groupProductDetail.total_price doubleValue] * _productCount)];
    _codeLabel.text         = [[ticket.code firstObject] stringValue];
}

@end
