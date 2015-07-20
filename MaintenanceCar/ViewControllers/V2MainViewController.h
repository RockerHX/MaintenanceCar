//
//  V2MainViewController.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import "SCMenuViewController.h"

@interface V2MainViewController : UIViewController
{
    SCMenuViewController *_menuViewController;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)menuButtonPressed;
- (IBAction)searchButtonPressed;

@end
