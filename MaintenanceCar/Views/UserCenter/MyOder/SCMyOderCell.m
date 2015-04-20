//
//  SCMyOderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOderCell.h"

@implementation SCMyOderCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 40.0f;
}

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10.0f;
    frame.origin.y = frame.origin.y + 10.0f;
    frame.size.width = frame.size.width - 20.0f;
    frame.size.height = frame.size.height - 20.0f;
    [super setFrame:frame];
}

#pragma mark - Public Methods
- (CGFloat)displayCellWithReservation:(SCReservation *)reservation
{
    return 20.0f;
}

- (IBAction)callMerchantButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldCallMerchant)])
        [_delegate shouldCallMerchant];
}

@end
