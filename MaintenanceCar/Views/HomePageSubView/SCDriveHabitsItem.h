//
//  SCDriveHabitsItem.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCHabitsType) {
    SCHabitsTypeNoraml = 1,
    SCHabitsTypeHigh,
    SCHabitsTypeOften
};

@class SCDriveHabitsItem;

@protocol SCDriveHabitsItemDelegate <NSObject>

@optional
- (void)didSelected:(SCDriveHabitsItem *)item;

@end

@interface SCDriveHabitsItem : UIView

@property (weak, nonatomic) IBOutlet UIImageView  *checkBox;

@property (nonatomic, weak)          id           <SCDriveHabitsItemDelegate>delegate;
@property (nonatomic, assign)        SCHabitsType type;

- (void)selected;
- (void)unSelected;

@end
