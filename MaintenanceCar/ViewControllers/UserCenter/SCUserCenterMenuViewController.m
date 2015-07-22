//
//  SCUserCenterMenuViewController.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterMenuViewController.h"
#import "SCStoryBoardManager.h"

@interface SCUserCenterMenuViewController ()

@end

@implementation SCUserCenterMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Init
+ (instancetype)instance {
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameUserCenter];
}

@end
