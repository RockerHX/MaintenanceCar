//
//  SCShopList.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopViewModel.h"

@interface SCShopList : NSObject

@property (nonatomic, assign)                BOOL  shopsLoaded;
@property (nonatomic, assign, readonly) NSInteger  statusCode;
@property (nonatomic, strong, readonly)  NSString *serverPrompt;
@property (nonatomic, strong, readonly)   NSArray *shops;

- (void)loadMoreShops;

@end
