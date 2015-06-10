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

@property (nonatomic, assign, readonly)                 BOOL  canPay;         // 是否支持买单
@property (nonatomic, copy, readonly)               NSString *ID;             // 商家ID
@property (nonatomic, copy, readonly)               NSString *thumbnails;     // 缩略图路径
@property (nonatomic, copy, readonly)               NSString *name;           // 商家店名
@property (nonatomic, copy, readonly)               NSString *star;           // 用户评星
@property (nonatomic, strong, readonly) SCShopCharacteristic *characteristic; // 商家特色
@property (nonatomic, assign, readonly)               double  longtitude;     // 商家地理位置坐标 - 经度
@property (nonatomic, assign, readonly)               double  latitude;       // 商家地理位置坐标 - 纬度
@property (nonatomic, strong, readonly)         SCShopRepair *repair;         // 商家维修类型数据
@property (nonatomic, strong, readonly)              NSArray *flags;          // 商家标签
@property (nonatomic, strong, readonly)              NSArray *products;       // 商家推荐产品

/**
 *  类方法
 *
 *  @param shop 商家数据模型 - SCShop
 *
 *  @return 商家数据显示模型 - SCShopViewModel
 */
+ (instancetype)initWithShop:(SCShop *)shop;

@end
