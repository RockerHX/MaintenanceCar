//
//  SCOrder.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderBase.h"

@interface SCOrder : SCOrderBase

@property (nonatomic, copy) NSString *previousStateDate;      // 上个进度时间
@property (nonatomic, copy) NSString *previousStateName;      // 上个进度名称
@property (nonatomic, copy) NSString *currentStateDate;       // 当前进度时间
@property (nonatomic, copy) NSString *currentStateName;       // 当前进度名称
@property (nonatomic, copy) NSString *nextStateDate;          // 下个进度时间
@property (nonatomic, copy) NSString *nextStateName;          // 下个进度名称
@property (nonatomic, copy) NSString *star;                   // 商家评星
@property (nonatomic, assign)   BOOL  canComment;             // 是否能评论

@end
