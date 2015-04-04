//
//  SCPlaceholderTextView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPlaceholderTextView.h"
#import "UIConstants.h"

@implementation SCPlaceholderTextView

#pragma mark - Init And Dealloc Methods
- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize
{
    _placeholderColor    = [UIColor lightGrayColor];
    self.backgroundColor = [UIColor clearColor];
    self.text            = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)textChanged:(NSNotification *)notification
{
    if (notification.object == self)
        [self layoutGUI];
}

#pragma mark - LayoutGUI Methods
- (void)layoutGUI
{
    _placeholderLabel.alpha = [self.text length] ? ZERO_POINT : 1.0f;
}

#pragma mark - Setters
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self layoutGUI];
}

- (void)setPlaceholderText:(NSString*)placeholderText
{
	_placeholderText = placeholderText;
	[self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor*)color
{
	_placeholderColor = color;
	[self setNeedsDisplay];
}

#pragma mark - DrawRect Methods
- (void)drawRect:(CGRect)rect
{
    if ([_placeholderText length])
    {
        if (!_placeholderLabel)
        {
            _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 8.0f, rect.size.width - 16.0f, 18.0f)];
            _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeholderLabel.numberOfLines = 0;
            _placeholderLabel.font = self.font;
            _placeholderLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_placeholderLabel];
        }
        
        _placeholderLabel.text      = _placeholderText;
        _placeholderLabel.textColor = _placeholderColor;
    }
    
    [self layoutGUI];
    
    [super drawRect:rect];
}

@end