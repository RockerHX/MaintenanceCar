//
//  SCMyOder.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOder.h"

@interface SCMyOder : SCOder

@property (nonatomic, strong) NSString *previousStateDate;      // 上个进度时间
@property (nonatomic, strong) NSString *previousStateName;      // 上个进度名称
@property (nonatomic, strong) NSString *currentStateDate;       // 当前进度时间
@property (nonatomic, strong) NSString *currentStateName;       // 当前进度名称
@property (nonatomic, strong) NSString *nextStateDate;          // 下个进度时间
@property (nonatomic, strong) NSString *nextStateName;          // 下个进度名称
@property (nonatomic, strong) NSString *star;                   // 商家评星
@property (nonatomic, assign)     BOOL  canComment;             // 是否能评论

@end
