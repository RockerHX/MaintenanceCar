//
//  SCShopList.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCShopList : NSObject

@property (nonatomic, assign, readonly)    BOOL  shopsLoaded;
@property (nonatomic, strong, readonly) NSArray *shops;

- (void)loadMoreShops;

@end
