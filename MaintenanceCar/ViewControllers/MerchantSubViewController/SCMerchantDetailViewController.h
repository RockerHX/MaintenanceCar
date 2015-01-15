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

@property (nonatomic, copy)                  NSString *companyID;       // 商户ID
@property (nonatomic, strong)        SCMerchantDetail *merchantDetail;  // 商户详情数据模型

@property (weak, nonatomic) IBOutlet SCCollectionItem *favoriteItem;    // 收藏按钮

/**
 *  [收藏]按钮触发事件
 */
- (IBAction)favoriteItemPressed:(SCCollectionItem *)sender;

@end
