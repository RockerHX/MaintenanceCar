//
//  SCMerchantDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCMerchant;
@class SCMerchantDetail;
@class SCCollectionItem;
@class SCLoopScrollView;

@interface SCMerchantDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SCCollectionItem *collectionItem;      // 收藏按钮
@property (weak, nonatomic) IBOutlet SCLoopScrollView *merchantImagesView;  // 商户图片

@property (nonatomic, strong)       SCMerchant *merchant;            // 商家信息
@property (nonatomic, strong) SCMerchantDetail *merchantDetail;      // 商家详情数据模型
@property (nonatomic, strong)         NSString *type;
@property (nonatomic, assign)             BOOL  canSelectedReserve;

/**
 *  [收藏]按钮触发事件
 */
- (IBAction)collectionItemPressed:(SCCollectionItem *)sender;

@end
