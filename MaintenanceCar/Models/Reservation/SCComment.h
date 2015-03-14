//
//  SCComment.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCComment : JSONModel

@property (nonatomic, copy) NSString <Optional>*comment_id;         // 评论ID
@property (nonatomic, copy) NSString <Optional>*star;               // 评星（10分制）
@property (nonatomic, copy) NSString <Optional>*reserve_id;         // 预约ID
@property (nonatomic, copy) NSString <Optional>*detail;             // 评论详情
@property (nonatomic, copy) NSString <Optional>*company_id;         // 商家ID

@end
