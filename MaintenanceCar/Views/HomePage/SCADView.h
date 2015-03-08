//
//  SCADView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCADViewDelegate <NSObject>

@optional
- (void)shouldEnter;

@end

@interface SCADView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet    UIButton *enterButton;
@property (weak, nonatomic) IBOutlet    UIButton *cancelButton;

@property (nonatomic, weak)                   id <SCADViewDelegate>delegate;

- (id)initWithDelegate:(id<SCADViewDelegate>)delegate imageURL:(NSString *)imageURL;
- (void)show;

- (IBAction)enterButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
