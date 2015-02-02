//
//  SCInfiniteLoopScrollView.m
//  SCInfiniteLoopScrollViewDemo
//
//  Created by ShiCang on 14/11/23.
//  Copyright (c) 2014年 SCInfiniteLoopScrollViewDemo. All rights reserved.
//

#import "SCInfiniteLoopScrollView.h"

@interface UIImageView (SCInfiniteLoopScrollView) <NSCopying>

@end

@implementation UIImageView (SCInfiniteLoopScrollView)

- (id)copyWithZone:(NSZone *)zone
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    return imageView;
}

@end

#define DOT_COORDINATE      0.0f

#define SELF_WIDTH          self.frame.size.width
#define SELF_HEIGHT         self.frame.size.height

#define MIN_BORDER          SELF_WIDTH
#define MAX_BORDER          (_subItems.count + 1) * SELF_WIDTH

#define kCurrentIndexKey    @"currentPage"

typedef void(^BLOCK)(NSInteger index, BOOL animated);

@protocol SCInfiniteLoopScrollViewDelegate <UIScrollViewDelegate>
@end

@interface SCInfiniteLoopScrollView () <UIScrollViewDelegate>
{
    BLOCK                                   _block;
    id<SCInfiniteLoopScrollViewDelegate>    _currentDelegate;
}

@end

@implementation SCInfiniteLoopScrollView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self initData];
    [self clearSubViews];
    if (_subItems)
        [self reloadSubViews:_subItems];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:kCurrentIndexKey];
}

#pragma mark - KVO Methods
#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kCurrentIndexKey])
    {
        NSInteger oldValue = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        NSInteger newValue = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        if (newValue != oldValue)
        {
            if (_block)
                _block(newValue, YES);
        }
    }
}

#pragma mark - Private Methods
#pragma mark -
- (void)initData
{
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    [super setDelegate:self];
    [self addObserver:self forKeyPath:kCurrentIndexKey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)clearSubViews
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)reloadSubViews:(NSArray *)subItems
{
    [self setContentSize:CGSizeMake(SELF_WIDTH * (subItems.count + 2), SELF_HEIGHT)];
    
    id lastObject = [subItems lastObject];
    if ([lastObject isKindOfClass:[UIView class]])
    {
        UIView *view = [lastObject copy];
        view.frame = CGRectMake(DOT_COORDINATE, DOT_COORDINATE, self.frame.size.width, self.frame.size.height);
        [self addSubview:view];
    }
    
    [subItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIView class]])
        {
            UIView *view = obj;
            view.frame = CGRectMake(self.frame.size.width * (idx + 1), DOT_COORDINATE, self.frame.size.width, self.frame.size.height);
            [self addSubview:view];
        }
    }];
    
    id firstObject = [subItems firstObject];
    if ([firstObject isKindOfClass:[UIView class]])
    {
        UIView *view = [firstObject copy];
        view.frame = CGRectMake(self.frame.size.width * (subItems.count + 1), DOT_COORDINATE, self.frame.size.width, self.frame.size.height);
        [self addSubview:view];
    }
    
    [self setContentOffset:CGPointMake(SELF_WIDTH, DOT_COORDINATE)];
}

- (NSInteger)getCurrentIndex:(NSInteger)index
{
    if (index >= _subItems.count)
    {
        return 0;
    }
    else if (index < 0)
    {
        return _subItems.count;
    }
    else
    {
        return index;
    }
}

#pragma mark - Public Methods
#pragma mark -
- (void)setSubItems:(NSArray *)subItems
{
    self.scrollEnabled = (subItems.count > 1) ? YES : NO;
    [self clearSubViews];
    _subItems = subItems;
    
    [self reloadSubViews:subItems];
}

- (void)startAnimation:(void (^)(NSInteger, BOOL))block
{
    _block = block;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    _currentDelegate = (id<SCInfiniteLoopScrollViewDelegate>)delegate;
}

- (id<UIScrollViewDelegate>)delegate
{
    return _currentDelegate;
}

#pragma mark - UISrollView Delegate Methods
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [_currentDelegate scrollViewDidScroll:scrollView];
    
    if (scrollView.contentOffset.x < MIN_BORDER)
    {
        [scrollView setContentOffset:CGPointMake(MAX_BORDER, DOT_COORDINATE)];
    }
    else if (scrollView.contentOffset.x > MAX_BORDER)
    {
        [scrollView setContentOffset:CGPointMake(MIN_BORDER, DOT_COORDINATE)];
    }
    
    NSInteger currentPage = (scrollView.contentOffset.x/SELF_WIDTH) - 1;
    self.currentPage = [self getCurrentIndex:currentPage];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [_currentDelegate scrollViewDidZoom:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [_currentDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [_currentDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [_currentDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [_currentDelegate scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [_currentDelegate scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [_currentDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [_currentDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)] ? [_currentDelegate viewForZoomingInScrollView:scrollView] : nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [_currentDelegate scrollViewWillBeginZooming:scrollView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [_currentDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
{
    return [_currentDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)] ? [_currentDelegate scrollViewShouldScrollToTop:scrollView] : NO;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([_currentDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [_currentDelegate scrollViewDidScrollToTop:scrollView];
}

@end
