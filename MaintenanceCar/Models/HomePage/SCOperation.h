//
//  SCOperation.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <MJExtension/MJExtension.h>

@interface SCOperation : NSObject

@property (nonatomic, assign)      BOOL  html;              // 是否是网页
@property (nonatomic, assign)      BOOL  needLogin;         // 是否需要登录
@property (nonatomic, assign) NSInteger  gift;              // 活动参数
@property (nonatomic, copy)    NSString *pictureURL;        // 按钮图片地址连接
@property (nonatomic, copy)    NSString *text;              // 显示名称
@property (nonatomic, copy)    NSString *url;               // 网页地址
@property (nonatomic, copy)    NSString *parameter;         // 商家活动请求参数
@property (nonatomic, copy)    NSString *value;             // 商家活动请求值

@end
