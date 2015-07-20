//
//  SCMenuViewController.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSlideMenu.h"

@interface SCMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCSlideMenu *menu;

- (SCMenuState)menuState;
- (void)setMenuState:(SCMenuState)state completion:(void(^)(void))completion;

- (void)operateMenu;

@end
