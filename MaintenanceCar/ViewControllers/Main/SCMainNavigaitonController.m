//
//  SCMainNavigaitonController.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMainNavigaitonController.h"

@implementation SCMainNavigaitonController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

#pragma mark - Gesture Recognizer
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController panGestureRecognized:sender];
}

@end
