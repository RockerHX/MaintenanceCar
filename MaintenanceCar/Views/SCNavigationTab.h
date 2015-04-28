//
//  SCNavigationTab.h
//  NiceHome-Manager
//
//  Created by ShiCang on 15/4/13.
//  Copyright (c) 2015年 NiceHome-Manager. All rights reserved.
//

#import "SCViewCategory.h"

@protocol SCNavigationTabDelegate <NSObject>

@optional
- (void)didSelectedItemAtIndex:(NSInteger)index;

@end

@interface SCNavigationTab : UIView

@property (weak, nonatomic) IBOutlet   UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;

@property (nonatomic, weak) IBOutlet id<SCNavigationTabDelegate>delegate;

@property (nonatomic, assign) CGFloat anmationDuration;

- (IBAction)firstButtonPressed:(UIButton *)button;
- (IBAction)secondButtonPressed:(UIButton *)button;
- (IBAction)thirdButtonPressed:(UIButton *)button;
- (IBAction)fourthButtonPressed:(UIButton *)button;

@end
