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
 *  添加数据 - SCCarBrand
 *
 *  @param object 需要添加的数据
 */
- (void)addObject:(id)object;

/**
 *  加载本地数据
 */
- (void)loadLocalData;

/**
 *  服务器数据添加完毕
 */
- (void)addFinish;

@end
