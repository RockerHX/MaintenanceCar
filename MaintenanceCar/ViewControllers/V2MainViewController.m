//
//  V2MainViewController.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "V2MainViewController.h"

@interface V2MainViewController ()

@end

@implementation V2MainViewController

#pragma mark - Container Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:NSStringFromClass([SCMenuViewController class])]) {
        _menuViewController = segue.destinationViewController;
    }
}

#pragma mark - View Controller Life Cycle
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Action
- (IBAction)menuButtonPressed {
    _containerView.hidden = NO;
    [_menuViewController openMenuWhenClosed:^{
        _containerView.hidden = YES;
    }];
}

- (IBAction)searchButtonPressed {
    
}

@end
