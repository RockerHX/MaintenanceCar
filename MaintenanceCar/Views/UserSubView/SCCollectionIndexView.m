//
//  SCCollectionIndexView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCollectionIndexView.h"
#import "MicroCommon.h"

#define LabelWidth      24.0f

@interface SCCollectionIndexView ()

@property (strong, nonatomic) NSArray *indexLabels;

@end


@implementation SCCollectionIndexView

#pragma mark - Init Methods
- (id) initWithFrame:(CGRect)frame indexTitles:(NSArray *)indexTitles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:DOT_COORDINATE alpha:0.8f];
        _indexTitles = indexTitles;
        _selectedIndex = 0;
        // add pan recognizer
    }
    return self;
}

- (void)awakeFromNib
{
    _selectedIndex = 0;
}

#pragma mark - Setter And Getter Methods
- (void)setIndexTitles:(NSArray *)indexTitles
{
    if (_indexTitles == indexTitles)
        return;
    _indexTitles = indexTitles;
    [_indexLabels performSelector:@selector(removeFromSuperview)];
    [self buildIndexLabels];
}

- (NSString *)selectedIndexTitle
{
    return _indexTitles[_selectedIndex];
}

#pragma mark - Public Methods
- (void)showWithAnimation:(BOOL)animation
{
    _rightConstraint.constant = _rightConstraint.constant + LabelWidth;
    [self needsUpdateConstraints];
    if (animation)
    {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5f animations:^{
            [weakSelf layoutIfNeeded];
        }];
    }
}

- (void)hiddenWithAnimation:(BOOL)animation
{
    _rightConstraint.constant = _rightConstraint.constant - LabelWidth;
    [self needsUpdateConstraints];
    if (animation)
    {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5f animations:^{
            [weakSelf layoutIfNeeded];
        }];
    }
}

#pragma mark - Private Methods
- (void)buildIndexLabels
{
    CGFloat cumulativeItemHeight = (SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - 120.0f - LabelWidth) / _indexTitles.count;
    NSMutableArray *labels = [@[] mutableCopy];
    __weak typeof(self)weakSelf = self;
    [_indexTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DOT_COORDINATE, idx * cumulativeItemHeight, LabelWidth, cumulativeItemHeight)];
        label.tag                    = idx;
        label.text                   = obj;
        label.font                   = [UIFont systemFontOfSize:10.0f];
        label.backgroundColor        = [UIColor clearColor];
        label.textAlignment          = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        [weakSelf addSubview:label];
        [labels addObject:label];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)]];
    }];
    _indexLabels = labels;
}

#pragma mark - Gestures
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    _selectedIndex = tap.view.tag;
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
