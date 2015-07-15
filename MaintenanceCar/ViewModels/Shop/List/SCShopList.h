//
//  SCShopList.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopViewModel.h"

typedef NS_ENUM(NSUInteger, SCShopListType) {
    SCShopListTypeNormal,
    SCShopListTypeSearch
};

@class SCServerResponse;

@interface SCShopList : NSObject

@property (nonatomic, assign)                        BOOL  loaded;
@property (nonatomic, assign)              SCShopListType  type;
@property (nonatomic, strong)         NSMutableDictionary *parameters;
@property (nonatomic, strong, readonly)  SCServerResponse *serverResponse;
@property (nonatomic, strong, readonly)           NSArray *shops;

- (void)reloadShops;
- (void)loadShops;
- (void)loadShopsWithSearch:(NSString *)search;
- (void)loadMoreShops;

- (void)setParameter:(id)parameter value:(id)value;

@end
