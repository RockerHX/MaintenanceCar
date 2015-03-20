//
//  SCMerchantServiceCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCServiceItemCell.h"

@class SCMerchantDetail;

@interface SCMerchantServiceCell : UITableViewCell <SCServiceItemCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *serviceView; // 商家服务内容栏

- (void)displayCellWithDetail:(SCMerchantDetail *)detail;

@end
