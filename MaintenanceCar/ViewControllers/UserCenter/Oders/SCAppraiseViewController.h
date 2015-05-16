//
//  SCAppraiseViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@protocol SCAppraiseViewControllerDelegate <NSObject>

@optional
- (void)appraiseSuccess;

@end

@class SCOder;
@class SCStarView;
@class SCTextView;

@interface SCAppraiseViewController : UITableViewController <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet    UILabel *merchantNameLabel;
@property (nonatomic, weak) IBOutlet    UILabel *serviceLabel;
@property (nonatomic, weak) IBOutlet    UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet SCStarView *starView;
@property (nonatomic, weak) IBOutlet SCTextView *textView;

@property (nonatomic, weak)       id  <SCAppraiseViewControllerDelegate>delegate;
@property (nonatomic, weak)   SCOder *oder;

- (IBAction)commitAppraiseButtonPressed:(id)sender;

@end
