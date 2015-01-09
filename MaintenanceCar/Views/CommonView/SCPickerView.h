//
//  SCPickerView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCPickerViewDelegate <NSObject>

@optional
- (void)pickerViewSelectedFinish:(NSString *)item displayName:(NSString *)name;

@end

@interface SCPickerView : UIView

@property (nonatomic, weak) id<SCPickerViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIPickerView       *picker;
@property (weak, nonatomic) IBOutlet UIView             *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

- (id)initWithDelegate:(id<SCPickerViewDelegate>)delegate;

- (void)show;

@end
