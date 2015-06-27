//
//  SCServerResponse.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCServerResponse : NSObject

@property (nonatomic, assign) NSInteger  statusCode;
@property (nonatomic, strong)  NSString *prompt;

- (instancetype)initWithResponseObject:(id)responseObject;

@end
