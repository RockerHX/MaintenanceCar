//
//  SCCarBrandDisplayModel.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCarBrandDisplayModel : NSObject

@property (nonatomic, assign, readonly) BOOL         loadFinish;
@property (nonatomic, strong, readonly) NSDictionary *displayData;

+ (instancetype)share;

- (void)addObject:(id)object;
- (void)loadLocalData;

@end
