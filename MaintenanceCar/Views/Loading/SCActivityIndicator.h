//
//  SCActivityIndicator.h
//
//  Created by ShiCang on 15/6/17.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCActivityIndicator : UIView
{
    BOOL      _isAnimating;
    CGFloat   _dotRadius;
    NSInteger _stepNumber;
    
    CGRect _firstPoint;
    CGRect _secondPoint;
    CGRect _thirdPoint;
    CGRect _fourthPoint;
    
    CALayer *_firstDot;
    CALayer *_secondDot;
    CALayer *_thirdDot;
    
    NSTimer *_timer;
}

@property (nonatomic, assign)    BOOL  hidesWhenStopped;
@property (nonatomic, strong) UIColor *color;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
