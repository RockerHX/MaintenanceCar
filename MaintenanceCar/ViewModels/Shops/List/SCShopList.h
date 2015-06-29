//
//  SCShopList.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopViewModel.h"

@class SCServerResponse;
@interface SCShopList : NSObject

@property (nonatomic, assign)                        BOOL  loaded;
@property (nonatomic, strong)         NSMutableDictionary *parameters;
@property (nonatomic, strong, readonly)  SCServerResponse *serverResponse;
@property (nonatomic, strong, readonly)           NSArray *shops;

- (void)reloadShops;
- (void)loadMoreShops;

@end
