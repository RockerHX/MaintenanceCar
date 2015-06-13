//
//  SCShop.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

// 商家特色数据模型
@interface SCShopCharacteristic : NSObject

@property (nonatomic, copy) NSString *title;            // 特色描述
@property (nonatomic, copy) NSString *color;            // 描述颜色值

@end

// 商家维修数据模型
@interface SCShopRepair : NSObject

@property (nonatomic, assign) NSInteger  type;          // 维修类型
@property (nonatomic, strong)   NSArray *have;          // 车主拥有车辆与维修厂匹配的车辆
@property (nonatomic, strong)   NSArray *haveNot;       // 维修厂能维修的车辆

@end

// 商家产品数据模型
@interface SCShopProduct : NSObject

@property (nonatomic, assign)     BOOL  hot;            // 是否热卖
@property (nonatomic, assign)     BOOL  isGroup;        // 是否热卖
@property (nonatomic, copy)   NSString *ID;             // 产品ID
@property (nonatomic, copy)   NSString *title;          // 产品名称
@property (nonatomic, copy)   NSString *discountPrice;  // 产品价格

@end

@interface SCShop : NSObject

@property (nonatomic, assign)                 BOOL  canPay;         // 是否支持买单
@property (nonatomic, assign)               double  longtitude;     // 商家地理位置坐标 - 经度
@property (nonatomic, assign)               double  latitude;       // 商家地理位置坐标 - 纬度
@property (nonatomic, copy)               NSString *ID;             // 商家ID
@property (nonatomic, copy)               NSString *thumbnails;     // 缩略图路径
@property (nonatomic, copy)               NSString *name;           // 商家店名
@property (nonatomic, copy)               NSString *star;           // 用户评星
@property (nonatomic, strong) SCShopCharacteristic *characteristic; // 商家特色
@property (nonatomic, strong)         SCShopRepair *repair;         // 商家维修类型数据
@property (nonatomic, strong)              NSArray *flags;          // 商家标签
@property (nonatomic, strong)              NSArray *products;       // 商家推荐产品

@end
