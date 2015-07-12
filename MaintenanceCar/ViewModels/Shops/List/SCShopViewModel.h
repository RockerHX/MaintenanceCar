//
//  SCShopViewModel.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShop.h"

// 商家数据显示模型
@interface SCShopViewModel : NSObject

@property (nonatomic, strong, readonly)  SCShop *shop;                  // 商家数据
@property (nonatomic, copy, readonly)  NSString *star;                  // 商家评星
@property (nonatomic, copy, readonly)  NSString *distance;              // 商家距离
@property (nonatomic, copy, readonly)  NSString *repairTypeImageName;   // 商家维修类型
@property (nonatomic, copy, readonly)  NSString *repairPrompt;          // 商家维修类型描述

@property (nonatomic, strong, readonly) NSArray *flags;                 // 商户标签集合
@property (nonatomic, strong, readonly) NSArray *dataSource;            // 数据源

@property (nonatomic, assign, readonly)              BOOL  canOpen;         // 产品能否展开
@property (nonatomic, assign, getter=isProductsOpen) BOOL  productsOpen;    // 产品是否展开

/**
 *  初始化方法
 *
 *  @param shop 商家数据模型 - SCShop
 *
 *  @return 商家数据显示模型 - SCShopViewModel
 */
- (instancetype)initWithShop:(SCShop *)shop;

/**
 *  展开或关闭商家产品
 *
 *  @param block 列表刷新的判断回调
 */
- (void)operateProductsMenu:(void(^)(BOOL shouldReload, BOOL close))block;

@end
