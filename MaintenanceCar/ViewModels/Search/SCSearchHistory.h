//
//  SCSearchHistory.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCObjectCategory.h"

@interface SCSearchHistory : NSObject
{
    NSMutableArray *_histories;
}

- (void)addNewSearchHistory:(id)newSearch;
- (void)deleteSearchHistoryAtIndex:(NSInteger)index;
- (void)deleteSearchHistoryWithObject:(id)object;
- (void)clearHistory;
- (NSArray *)history;

@end
