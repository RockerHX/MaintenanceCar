//
//  SCDictionaryItem.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 字典项Model
@interface SCDictionaryItem : JSONModel

@property (nonatomic, copy) NSString <Optional>*dict_id;    // 字典ID
@property (nonatomic, copy) NSString <Optional>*name;       // 字典名字
@property (nonatomic, copy) NSString <Optional>*type;       // 字典类型
@property (nonatomic, copy) NSString <Optional>*index;      // 字典索引

/**
 *  字典项Model初始化方法
 *
 *  @param itemName 字典名字
 *  @param dictID   字典ID
 *  @param type     字典类型
 *  @param index    字典索引
 *
 *  @return 字典项Model实例对象
 */
- (id)initWithItemName:(NSString *)itemName
                dictID:(NSString *)dictID
                  type:(NSString *)type
                 index:(NSString *)index;

@end
