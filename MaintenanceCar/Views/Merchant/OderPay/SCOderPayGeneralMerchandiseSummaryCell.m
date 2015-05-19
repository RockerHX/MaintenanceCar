//
//  SCOderPayGeneralMerchandiseSummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderPayGeneralMerchandiseSummaryCell.h"

@implementation SCOderPayGeneralMerchandiseSummaryCell
{
    NSInteger _productCount;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 43.0f;
    _countLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _countLabel.layer.borderWidth = 1.0f;
    _cutButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cutButton.layer.borderWidth = 1.0f;
    _addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addButton.layer.borderWidth = 1.0f;
}

#pragma mark - Config Methods
- (void)initConfig
{
    _productCount = 1;
}

#pragma mark - Action Methods
- (IBAction)cutButtonPressed
{
    _productCount = _productCount - 1;
    if (_productCount < 1)
        _productCount = 1;
    [self displayView];
}

- (IBAction)addButtonPressed
{
    _productCount = _productCount + 1;
    [self displayView];
}

#pragma mark - Private Methods
- (void)displayView
{
    _countLabel.text = [@(_productCount) stringValue];
}

@end
