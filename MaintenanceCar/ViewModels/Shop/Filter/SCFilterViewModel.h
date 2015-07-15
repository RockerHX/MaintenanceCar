//
//  SCFilterViewModel.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilter.h"

static CGFloat contentHeight = 195.0f;
static CGFloat bottomBarHeight = 20.0f;

typedef NS_ENUM(NSUInteger, SCFilterType) {
    SCFilterTypeService,
    SCFilterTypeRegion,
    SCFilterTypeSort,
    SCFilterTypeCarModel,
};

@interface SCFilterViewModel : NSObject

@property (nonatomic, assign, readonly)          CGFloat  contentHeight;
@property (nonatomic, assign, readonly)     SCFilterType  type;
@property (nonatomic, strong, readonly)         SCFilter *filter;
@property (nonatomic, strong, readonly) SCFilterCategory *category;

- (void)changeCategory:(SCFilterType)type;
- (void)loadCompleted:(void(^)(SCFilterViewModel *viewModel, BOOL success))block;

@end
