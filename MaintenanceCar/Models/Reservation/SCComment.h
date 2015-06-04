//
//  SCComment.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@protocol SCComment <NSObject>
@end

@interface SCComment : JSONModel

@property (nonatomic, strong) NSString <Optional>*comment_id;         // 评价ID
@property (nonatomic, strong) NSString <Optional>*star;               // 评星（10分制）
@property (nonatomic, strong) NSString <Optional>*reserve_id;         // 预约ID
@property (nonatomic, strong) NSString <Optional>*detail;             // 评价详情
@property (nonatomic, strong) NSString <Optional>*company_id;         // 商家ID
@property (nonatomic, strong) NSString <Optional>*user_id;            // 用户ID
@property (nonatomic, strong) NSString <Optional>*title;              // 评价标题
@property (nonatomic, strong) NSString <Optional>*phone;              // 评价昵称
@property (nonatomic, strong) NSString <Optional>*create_time;        // 评价时间

@end
