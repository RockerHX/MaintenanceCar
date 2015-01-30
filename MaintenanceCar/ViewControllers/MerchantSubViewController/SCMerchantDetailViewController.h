//
//  SCMerchantDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchant;
@class SCMerchantDetail;
@class SCCollectionItem;

@interface SCMerchantDetailViewController : UITableViewController

@property (nonatomic, copy)                SCMerchant *merchant;        // 商户信息
@property (nonatomic, strong)        SCMerchantDetail *merchantDetail;  // 商户详情数据模型

@property (weak, nonatomic) IBOutlet SCCollectionItem *collectionItem;    // 收藏按钮

/**
 *  [收藏]按钮触发事件
 */
- (IBAction)collectionItemPressed:(SCCollectionItem *)sender;

@end
