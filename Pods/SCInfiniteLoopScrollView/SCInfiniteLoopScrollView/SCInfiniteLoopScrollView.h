//
//  SCInfiniteLoopScrollView.h
//  SCInfiniteLoopScrollViewDemo
//
//  Created by ShiCang on 14/11/23.
//  Copyright (c) 2014年 SCInfiniteLoopScrollViewDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCInfiniteLoopScrollView : UIScrollView

@property (nonatomic, assign)               NSInteger   currentPage;
@property (nonatomic, strong)               NSArray     *subItems;

- (void)startAnimation:(void(^)(NSInteger index, BOOL animated))block;

@end
