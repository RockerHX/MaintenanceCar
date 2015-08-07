//
//  SCGuideViewController.m
//  MaintenanceCar
//
//  Created by Andy on 15/8/7.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGuideViewController.h"
#import <SCLoopScrollView/SCLoopScrollView.h>

@implementation SCGuideViewController {
    NSArray *_images;
}

#pragma mark - Init Methods
+ (instancetype)instance {
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameGuide];
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    NSMutableArray *images = @[].mutableCopy;
    for (NSInteger index = 1; index < 5; index ++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%zd", (IS_IPHONE_4 ? @"Guide4S0" : @"Guide0"), index];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    _images = [NSArray arrayWithArray:images];
}

- (void)viewConfig {
    UIScrollView *guideView = [self configGuideView];
    for (NSInteger index = 0; index < _images.count; index ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*index, ZERO_POINT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = _images[index];
        [guideView addSubview:imageView];
    }
    UIView *lastGuideView = [guideView.subviews lastObject];
    lastGuideView.userInteractionEnabled = YES;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH - 60.0f, 60.0f)];
    button.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - (IS_IPHONE_4 ? 50.0f : (IS_IPHONE_5 ? 80.0f : 100.0f)));
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(finishedButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [lastGuideView addSubview:button];
}

#pragma mark - Private Methods
- (UIScrollView *)configGuideView {
    _guideView.bounces = NO;
    _guideView.pagingEnabled = YES;
    _guideView.showsVerticalScrollIndicator = NO;
    _guideView.showsHorizontalScrollIndicator = NO;
    _guideView.contentSize = CGSizeMake(_images.count * SCREEN_WIDTH, SCREEN_HEIGHT);
    return _guideView;
}

- (void)finishedButtonPressed {
    if (_delegate && [_delegate respondsToSelector:@selector(guideFinished)]) {
        [_delegate guideFinished];
    }
}

@end
