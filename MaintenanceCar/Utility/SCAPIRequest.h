//
//  SCAPIRequest.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/25.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"
#import <AFNetworking/AFNetworking.h>

@interface SCAPIRequest : NSObject

@property (nonatomic, copy) NSString *doMain;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *api;

@property (nonatomic, copy) NSString *url;

+ (instancetype)shareRequest;

- (instancetype)initWithURL:(NSString *)url;
- (instancetype)initWithDoMain:(NSString *)doMain path:(NSString *)path api:(NSString *)api;

- (AFSecurityPolicy *)customSecurityPolicy;
- (NSDictionary *)startWearthAPIRequest;

@end
