//
//  SCADView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCADView;

@protocol SCADViewDelegate <NSObject>

@optional
- (void)imageLoadCompleted:(SCADView *)adView;
- (void)shouldEnter;

@end

@interface SCADView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet    UIButton *cancelButton;

@property (nonatomic, weak) id <SCADViewDelegate>delegate;

+ (void)showWithDelegate:(id<SCADViewDelegate>)delegate imageURL:(NSString *)imageURL;

- (instancetype)initWithDelegate:(id<SCADViewDelegate>)delegate imageURL:(NSString *)imageURL;
- (void)show;

- (IBAction)cancelButtonPressed;

@end
