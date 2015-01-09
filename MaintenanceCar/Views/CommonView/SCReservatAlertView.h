//
//  SCReservatAlertView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCAlertItemType) {
    SCAlertItemTypeOne   = 0,
    SCAlertItemTypeTwo,
    SCAlertItemTypeThree,
    SCAlertItemTypeOhter
};

typedef NS_ENUM(NSInteger, SCAlertAnimation) {
    SCAlertAnimationDefault = 0,
    SCAlertAnimationEnlarge,
    SCAlertAnimationMove
};

@protocol SCReservatAlertViewDelegate <NSObject>

@optional
- (void)selectedAtButton:(SCAlertItemType)type;

@end

@interface SCReservatAlertView : UIView

@property (nonatomic, weak) id<SCReservatAlertViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonOther;

- (id)initWithDelegate:(id<SCReservatAlertViewDelegate>)delegate animation:(SCAlertAnimation)anmation;

/**
 *  显示预约项目页面
 */
- (void)show;

@end
