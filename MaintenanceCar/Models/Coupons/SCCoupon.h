//
//  SCCoupon.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCCoupon : JSONModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *validDate;
@property (nonatomic, copy) NSString *memo;

@end
