//
//  SCMerchantList.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/27.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMerchant.h"

// 商户列表Model - 单例，全局使用
@interface SCMerchantList : NSObject

@property (nonatomic, strong) NSArray *items;   // 商户列表数据集合，存放SCMerchant对象

/**
 *  SCMerchantList对象单例初始化方法
 *
 *  @return SCMerchantList对象
 */
+ (instancetype)shareList;

@end
