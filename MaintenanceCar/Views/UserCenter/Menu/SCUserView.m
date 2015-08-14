//
//  SCUserView.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>
#import "SCUserView.h"
#import "SCUserInfo.h"
#import "SCUserCenterViewModel.h"

@implementation SCUserView

#pragma mark - Init Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)viewConfig {
    _header.clipsToBounds = YES;
    _header.layer.cornerRadius = _header.frame.size.width/2;
}

#pragma mark - Action
- (IBAction)headerTap {
    [self tap];
}

#pragma mark - Public Methods
- (void)refreshByViewModel:(SCUserCenterViewModel *)viewModel {
    [_header sd_setImageWithURL:viewModel.headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:viewModel.placeHolderHeader]];
    [_loginPromptLabel setText:viewModel.prompt];
}

#pragma mark - Private Methods
- (void)tap {
    if ([SCUserInfo share].loginState) {
        if (_delegate && [_delegate respondsToSelector:@selector(shouldEditUserInfo)]) {
            [_delegate shouldEditUserInfo];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(shouldLogin)]) {
            [_delegate shouldLogin];
        }
    }
}

@end
