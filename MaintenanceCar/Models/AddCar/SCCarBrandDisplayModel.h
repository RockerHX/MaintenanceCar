//
//  SCCarBrandDisplayModel.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

// 车辆品牌显示数据Model
@interface SCCarBrandDisplayModel : NSObject

@property (nonatomic, assign, readonly) BOOL         loadFinish;        // 数据加载标识
@property (nonatomic, strong, readonly) NSArray      *indexTitles;      // 索引标题集合
@property (nonatomic, strong, readonly) NSDictionary *displayData;      // 车辆品牌显示数据

/**
 *  SCCarBrandDisplayModel对象单例初始化方法
 *
 *  @return SCMerchantList对象
 */
+ (instancetype)share;

/**
 *  请求汽车品牌方法
 *
 *  @param finfish 完成回调
 */
- (void)requestCarBrands:(void(^)(NSDictionary *displayData, NSArray *indexTitles, BOOL finish))finfish;

@end
