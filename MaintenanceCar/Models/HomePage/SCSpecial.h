//
//  SCSpecial.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCSpecial : JSONModel

@property (nonatomic, strong) NSString <Optional>*pic_url;            // 按钮图片地址连接
@property (nonatomic, strong) NSString <Optional>*text;               // 显示名称
@property (nonatomic, strong) NSString <Optional>*url;                // 网页地址
@property (nonatomic, strong) NSString <Optional>*query;              // 查询条件
@property (nonatomic, strong) NSString <Optional>*post_pic;           // 展示图片地址
@property (nonatomic, strong) NSString <Optional>*type;
@property (nonatomic, assign) BOOL                html;               // 是否是网页

@end
