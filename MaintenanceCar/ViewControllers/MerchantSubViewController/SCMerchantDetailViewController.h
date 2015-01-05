//
//  SCMerchantDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchantDetail;
@class SCCollectionItem;

@interface SCMerchantDetailViewController : UITableViewController

@property (nonatomic, copy)                  NSString *companyID;
@property (nonatomic, strong)        SCMerchantDetail *merchantDetail;
@property (weak, nonatomic) IBOutlet SCCollectionItem *favoriteItem;

- (IBAction)favoriteItemPressed:(SCCollectionItem *)sender;

@end
