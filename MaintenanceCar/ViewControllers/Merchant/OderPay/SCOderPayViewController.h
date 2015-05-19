//
//  SCOderPayViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

typedef NS_ENUM(NSUInteger, SCOderPayType) {
    SCOderPayTypeGroupProduct,
    SCOderPayTypeGeneralMerchandise
};

@class SCGroupProductDetail;

@interface SCOderPayViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *cutButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *weiXinPayButton;
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;

@property (nonatomic, assign)        SCOderPayType  oderPayType;
@property (nonatomic, strong) SCGroupProductDetail *groupProductDetail;

- (IBAction)cutButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

- (IBAction)weiXinPayPressed:(id)sender;
- (IBAction)aliPayPressed:(id)sender;

@end
