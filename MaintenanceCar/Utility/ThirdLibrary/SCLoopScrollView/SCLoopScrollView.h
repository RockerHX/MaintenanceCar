//
//  SCLoopScrollView.h
//  ShiCang
//
//  Created by ShiCang on 15/3/18.
//  Copyright (c) 2014年 ShiCang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCLoopScrollViewDelegate;

@interface SCLoopScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak)   id         <SCLoopScrollViewDelegate>delegate;
@property (nonatomic, assign) NSInteger  index;
@property (nonatomic, assign) BOOL       autoScroll;

@property (nonatomic, strong) NSArray   *items;

- (void)begin:(void(^)(NSInteger index))finished
          tap:(void(^)(NSInteger index))tap;

- (void)beginWithAutoScroll:(BOOL)autoScroll
                  animation:(BOOL)animation
                   finished:(void(^)(NSInteger index))finished
                        tap:(void(^)(NSInteger index))tap;

@end

@protocol SCLoopScrollViewDelegate <NSObject>

@optional

@end
