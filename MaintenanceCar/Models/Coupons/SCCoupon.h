//
//  SCCoupon.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCCoupon : JSONModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *needMin;
@property (nonatomic, strong) NSString *validDate;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, assign)     BOOL  current;

@end
