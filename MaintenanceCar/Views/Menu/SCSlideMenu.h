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

@class SCSlideMenu;
@protocol SCSlideMenuDelegate <NSObject>

@optional
- (void)menuWillClose:(SCSlideMenu *)menu;
- (void)menuDidClose:(SCSlideMenu *)menu;
- (void)menuWillOpen:(SCSlideMenu *)menu;
- (void)menuDidOpen:(SCSlideMenu *)menu;

/**
 *  菜单状态进度
 *
 *  @param menu     menu实例
 *  @param progress 状态进度(0.0 ~ 1.0)，默认0.0
 */
- (void)menu:(SCSlideMenu *)menu stateProgress:(CGFloat)progress;

@end

@interface SCSlideMenu : UIView

@property (weak, nonatomic) IBOutlet id <SCSlideMenuDelegate>delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (nonatomic, assign) SCMenuState state;

@end
