//
//  SCUserCenterMenuViewController.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterMenuViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SCStoryBoardManager.h"
#import "SCUserCenterUserCarCell.h"
#import "SCUserCenterAddCarCell.h"
#import "SCUserCenterCell.h"
#import "SCUserCenterViewModel.h"
#import "SCAddCarViewController.h"

static CGFloat CellHeight = 44.0f;

@implementation SCUserCenterMenuViewController {
    SCUserCenterViewModel *_viewModel;
}

#pragma mark - Init Methods
+ (instancetype)instance {
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameUserCenter];
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    _viewModel = [SCUserCenterViewModel instance];
}

- (void)viewConfig {
}

#pragma mark - Private Methods
- (void)reloadData {
    [_userView.header sd_setImageWithURL:_viewModel.headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:_viewModel.placeHolderHeader]];
    [_userView.loginPromptLabel setText:_viewModel.prompt];
    [_tableView reloadData];
}

- (void)hideMenu {
    [self.frostedViewController hideMenuViewController];
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel.itemSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case SCUserCenterItemSectionUserCars:
            rows = _viewModel.userCarItems.count;
            break;
            
        case SCUserCenterItemSectionSelectedItems:
            rows = _viewModel.userCarItems.count;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCUserCenterCell *cell = nil;
    SCUserCenterMenuItem *item = nil;
    switch (indexPath.section) {
        case SCUserCenterItemSectionUserCars: {
            item = _viewModel.userCarItems[indexPath.row];
            if (item.last) {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCUserCenterAddCarCell class])
                                                       forIndexPath:indexPath];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCUserCenterUserCarCell class])
                                                       forIndexPath:indexPath];
            }
            break;
        }
            
        case SCUserCenterItemSectionSelectedItems: {
            item = _viewModel.selectedItems[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCUserCenterCell class])
                                                   forIndexPath:indexPath];
            break;
        }
    }
    [cell diplayCellWithItem:item];
    return cell;
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideMenu];
    
    switch (indexPath.section) {
        case SCUserCenterItemSectionUserCars: {
            SCUserCenterMenuItem *item = _viewModel.userCarItems[indexPath.row];
            if (item.last) {
                if (_delegate && [_delegate respondsToSelector:@selector(willShowAddCarSence)]) {
                    [_delegate willShowAddCarSence];
                }
                UINavigationController *addCarNavigaitonController = [SCAddCarViewController navigationInstance];
                [self presentViewController:addCarNavigaitonController animated:YES completion:nil];
            }
            break;
        }
            
        case SCUserCenterItemSectionSelectedItems: {
            if (_delegate && [_delegate respondsToSelector:@selector(shouldShowViewControllerOnRow:)]) {
                [_delegate shouldShowViewControllerOnRow:indexPath.row];
            }
            break;
        }
    }
}

#pragma mark - REFrostedViewController Delegate
- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController {
    [self reloadData];
}

#pragma mark - SCUserView Delegate
- (void)shouldLogin {
    [self hideMenu];
    [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
}

@end
