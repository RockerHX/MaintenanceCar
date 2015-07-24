//
//  SCUserCenterMenuItem.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCUserCenterMenuItem : NSObject

@property (nonatomic, assign)             BOOL  last;
@property (nonatomic, assign, readonly)   BOOL  localData;
@property (nonatomic, assign, readonly)  Class  viewController;
@property (nonatomic, copy, readonly) NSString *icon;
@property (nonatomic, copy, readonly) NSString *title;

- (instancetype)initWithDictionary:(NSDictionary *)dic localData:(BOOL)local;

@end
