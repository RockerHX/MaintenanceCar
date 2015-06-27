//
//  SCFilterView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewCategory.h"

typedef NS_ENUM(NSUInteger, SCFilterType) {
    SCFilterTypeService,
    SCFilterTypeRegion,
    SCFilterTypeModel,
    SCFilterTypeSort
};

@class SCFilterCategory;
@class SCFilterViewModel;
@interface SCFilterView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _canSelected;
    BOOL _popUp;
    
    NSInteger _mainFilterIndex;
    NSInteger _subFilterIndex;
    
    SCFilterType      _filterType;
    SCFilterCategory *_filterCategory;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomBarHeightConstraint;

@property (nonatomic, weak) IBOutlet      UIView *containerView;
@property (nonatomic, weak) IBOutlet      UIView *popUpView;
@property (nonatomic, weak) IBOutlet UITableView *mainFilterView;
@property (nonatomic, weak) IBOutlet UITableView *subFilterView;

@property (nonatomic, weak) IBOutlet UIButton *seviceFilterButton;
@property (nonatomic, weak) IBOutlet UIButton *regionFilterButton;
@property (nonatomic, weak) IBOutlet UIButton *modelFilterButton;
@property (nonatomic, weak) IBOutlet UIButton *sortFilterButton;

@property (nonatomic, assign, readonly) NSInteger  selectedIndex;
@property (nonatomic, strong)             NSArray *mainFilters;
@property (nonatomic, strong)             NSArray *subFilters;
@property (nonatomic, strong)   SCFilterViewModel *filterViewModel;

- (IBAction)filterButtonPressed:(UIButton *)button;

- (void)selectedAtIndex:(void(^)(NSUInteger index))block;

@end
