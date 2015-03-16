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

@property (nonatomic, copy) NSString <Optional>*comment_id;         // 评价ID
@property (nonatomic, copy) NSString <Optional>*star;               // 评星（10分制）
@property (nonatomic, copy) NSString <Optional>*reserve_id;         // 预约ID
@property (nonatomic, copy) NSString <Optional>*detail;             // 评价详情
@property (nonatomic, copy) NSString <Optional>*company_id;         // 商家ID
@property (nonatomic, copy) NSString <Optional>*user_id;            // 用户ID
@property (nonatomic, copy) NSString <Optional>*title;              // 评价标题
@property (nonatomic, copy) NSString <Optional>*phone;              // 评价昵称
@property (nonatomic, copy) NSString <Optional>*create_time;        // 评价时间

@end
