//
//  SCMenuViewController.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSlideMenu.h"

@interface SCMenuViewController : UIViewController <SCSlideMenuDelegate>

@property (weak, nonatomic) IBOutlet      UIView *transparentView;
@property (weak, nonatomic) IBOutlet SCSlideMenu *menu;

- (SCMenuState)menuState;
- (void)openMenuWhenClosed:(void(^)(void))closed;

- (void)operateMenu;

@end
