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

@protocol SCReservatAlertViewDelegate <NSObject>

@optional
- (void)selectedAtButton:(SCAlertItemType)type;

@end

@interface SCReservatAlertView : UIView

@property (nonatomic, weak) id<SCReservatAlertViewDelegate>delegate;

- (id)initWithDelegate:(id<SCReservatAlertViewDelegate>)delegate;

/**
 *  显示预约项目页面
 */
- (void)show;

@end
