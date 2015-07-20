//
//  SCSlideMenu.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCMenuState) {
    SCMenuStateClose,
    SCMenuStateOpen
};

@interface SCSlideMenu : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (nonatomic, assign) SCMenuState state;

@end
