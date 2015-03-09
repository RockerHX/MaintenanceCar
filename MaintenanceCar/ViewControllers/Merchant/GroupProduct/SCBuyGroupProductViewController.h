//
//  SCBuyGroupProductViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@class SCGroupProductDetail;

@interface SCBuyGroupProductViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic, copy) NSString *productfinalPrice;
@property (nonatomic, copy) NSString *productTitle;
@property (nonatomic, copy) NSString *productMerchantName;
@property (nonatomic, copy) NSString *productCompanyID;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *productOutTradeNo;
@property (nonatomic, copy) NSString *productTotalPrice;
@property (nonatomic, copy) NSString *productLimitBegin;
@property (nonatomic, copy) NSString *productLimitEnd;

- (IBAction)cutButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

- (IBAction)weiXinPayPressed:(id)sender;

@end
