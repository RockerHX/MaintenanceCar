//
//  SCDatePickerView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCDatePickerViewDelegate <NSObject>

@optional
- (void)datePickerSelectedFinish:(NSDate *)date mode:(UIDatePickerMode)mode;

@end

@interface SCDatePickerView : UIView

@property (nonatomic, weak) id<SCDatePickerViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker       *datePicker;
@property (weak, nonatomic) IBOutlet UIView             *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

- (id)initWithDelegate:(id<SCDatePickerViewDelegate>)delegate mode:(UIDatePickerMode)mode;

- (void)show;

@end
