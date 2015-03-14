//
//  SCPlaceholderTextView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPlaceholderTextView : UITextView
{
    UILabel *_placeholderLabel;
}

@property (strong, nonatomic) NSString *placeholderText;
@property (strong, nonatomic)  UIColor *placeholderColor;


@end