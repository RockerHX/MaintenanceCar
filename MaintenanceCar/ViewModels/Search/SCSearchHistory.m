//
//  SCSearchHistory.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSearchHistory.h"

static NSString *const SearchHistoryFileName = @"SearchHistory";

@implementation SCSearchHistory

#pragma mark - Init Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        _histories = [self read];
        if (!_histories.count)
            _histories = @[].mutableCopy;
    }
    return self;
}

#pragma mark - Private Methods
- (void)save {
    [self saveData:_histories fileName:SearchHistoryFileName];
}

- (id)read {
    return [self readLocalDataWithFileName:SearchHistoryFileName];
}

#pragma mark - Public Methods
- (void)addNewSearchHistory:(id)newSearch {
    if ([newSearch isKindOfClass:[NSString class]]) {
        [_histories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *history = obj;
            if ([history isEqualToString:newSearch]) {
                [_histories removeObject:history];
            }
        }];
        [_histories insertObject:newSearch atIndex:0];
        [self save];
    }
}

- (void)deleteSearchHistoryAtIndex:(NSInteger)index {
    if (index >= _histories.count) return;
    [_histories removeObjectAtIndex:index];
    [self save];
}

- (void)deleteSearchHistoryWithObject:(id)object {
    [_histories removeObject:object];
    [self save];
}

- (void)clearHistory {
    [_histories removeAllObjects];
    [self save];
}

- (NSArray *)history {
    id objects = [self read];
    if ([objects isKindOfClass:[NSArray class]]) return objects;
    return nil;
}

@end
