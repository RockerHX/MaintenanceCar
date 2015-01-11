//
//  SCAddCarViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCarBrandView;
@class SCCarModelView;

@interface SCAddCarViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCCarBrandView *carBrandView;
@property (weak, nonatomic) IBOutlet SCCarModelView *carModelView;

- (IBAction)addCarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

@end
