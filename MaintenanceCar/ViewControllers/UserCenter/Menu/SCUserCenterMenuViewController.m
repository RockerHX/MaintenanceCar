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
    _userCarHeightConstraint.constant = _viewModel.userCarItems.count * CellHeight;
    [self updateViewConstraints];
}

#pragma mark - Private Methods
- (void)reloadData {
    [_userView.header sd_setImageWithURL:_viewModel.headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:_viewModel.placeHolderHeader]];
    [_userView.loginPromptLabel setText:_viewModel.prompt];
    [_userCarView reloadData];
}

- (void)hideMenu {
    [self.frostedViewController hideMenuViewController];
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_userCarView]) return _viewModel.userCarItems.count;
    else if ([tableView isEqual:_userCenterView]) return _viewModel.userCenterItems.count;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCUserCenterCell *cell = nil;
    SCUserCenterMenuItem *item = nil;
    if ([tableView isEqual:_userCarView]) {
        item = _viewModel.userCarItems[indexPath.row];
        if (item.last) {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCUserCenterAddCarCell class])
                                                   forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCUserCenterUserCarCell class])
                                                   forIndexPath:indexPath];
        }
    } else {
        item = _viewModel.userCenterItems[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCUserCenterCell class])
                                               forIndexPath:indexPath];
        
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
    if ([tableView isEqual:_userCarView]) {
        SCUserCenterMenuItem *item = _viewModel.userCarItems[indexPath.row];
        if (item.last) {
            if (_delegate && [_delegate respondsToSelector:@selector(willShowAddCarSence)]) {
                [_delegate willShowAddCarSence];
            }
            UINavigationController *addCarNavigaitonController = [SCAddCarViewController navigationInstance];
            [self presentViewController:addCarNavigaitonController animated:YES completion:^{
                if (_delegate && [_delegate respondsToSelector:@selector(didShowAddCarSence)]) {
                    [_delegate didShowAddCarSence];
                }
            }];
        } else {
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(shouldShowViewControllerOnRow:)]) {
            [_delegate shouldShowViewControllerOnRow:indexPath.row];
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
