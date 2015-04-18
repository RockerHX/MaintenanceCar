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

@class SCStarView;
@class SCReservation;
@class SCPlaceholderTextView;

@interface SCAppraiseViewController : UITableViewController

@property (nonatomic, weak) IBOutlet               UILabel *merchantNameLabel;
@property (nonatomic, weak) IBOutlet               UILabel *serviceLabel;
@property (nonatomic, weak) IBOutlet               UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet            SCStarView *starView;
@property (nonatomic, weak) IBOutlet SCPlaceholderTextView *textView;

@property (nonatomic, weak)            id <SCAppraiseViewControllerDelegate>delegate;
@property (nonatomic, weak) SCReservation *reservation;

- (IBAction)commitAppraiseButtonPressed:(id)sender;

@end
