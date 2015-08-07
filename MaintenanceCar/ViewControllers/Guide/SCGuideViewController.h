//
//  SCGuideViewController.h
//  MaintenanceCar
//
//  Created by Andy on 15/8/7.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@protocol SCGuideViewControllerDelegate <NSObject>

@optional
- (void)guideFinished;

@end

@interface SCGuideViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *guideView;

@property (nonatomic, weak) id  <SCGuideViewControllerDelegate>delegate;

+ (instancetype)instance;

@end
