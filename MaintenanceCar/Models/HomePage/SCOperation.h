//
//  SCOperation.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <MJExtension/MJExtension.h>

@interface SCOperation : NSObject

@property (nonatomic, copy) NSString *pictureURL;        // 按钮图片地址连接
@property (nonatomic, copy) NSString *text;              // 显示名称
@property (nonatomic, copy) NSString *url;               // 网页地址
@property (nonatomic, copy) NSString *postPicture;       // 展示图片地址
@property (nonatomic, copy) NSString *parameter;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign)   BOOL  html;              // 是否是网页

@end
