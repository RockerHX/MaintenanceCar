//
//  SCServiceItemCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCServiceItemCell.h"

@implementation SCServiceItemCell
{
    NSString *_title;
    NSString *_ID;
}

#pragma mark - Action Methods
- (IBAction)itemPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(itemTapedWithTitle:ID:)])
        [_delegate itemTapedWithTitle:_title ID:_ID];
}

#pragma mark - Public Methods
- (void)displayCellWithDate:(NSDictionary *)data
{
    NSString *imageName = nil;
    
    switch ([[[data allKeys] firstObject] integerValue])
    {
        case 1:
        {
            _ID       = @"1";
            imageName = @"WashIcon";
            _title    = @"洗车美容";
        }
            break;
        case 2:
        {
            _ID       = @"2";
            imageName = @"MaintenanceIcon";
            _title    = @"保养";
        }
            break;
        case 3:
        {
            _ID       = @"3";
            imageName = @"RepaireIcon";
            _title    = @"维修";
        }
            break;
        case 4:
        {
            _ID       = @"4";
            imageName = @"OtherIcon";
            _title    = @"免费检测";
        }
            break;
    }
    
    [_icon setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    _textLabel.text = _title;
}

@end
