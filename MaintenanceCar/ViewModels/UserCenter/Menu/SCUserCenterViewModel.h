//
//  SCUserCenterViewModel.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterMenuItem.h"

typedef NS_ENUM(NSUInteger, SCUserCenterItemSection) {
    SCUserCenterItemSectionUserCars,
    SCUserCenterItemSectionSelectedItems
};


@interface SCUserCenterViewModel : NSObject

@property (nonatomic, assign)                BOOL  needRefresh;
@property (nonatomic, assign, readonly) NSInteger  itemSections;
@property (nonatomic, assign, readonly) NSInteger  carSelectedIndex;
@property (nonatomic, strong, readonly)     NSURL *headerURL;
@property (nonatomic, copy, readonly)    NSString *placeHolderHeader;
@property (nonatomic, copy, readonly)    NSString *prompt;
@property (nonatomic, copy, readonly)     NSArray *userCarItems;
@property (nonatomic, copy, readonly)     NSArray *selectedItems;

+ (instancetype)instance;

- (void)reloadCars;
- (void)recordUserCarSelected:(NSInteger)index;

@end
