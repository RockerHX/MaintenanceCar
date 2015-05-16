//
//  SCGroupTicketDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCGroupTicket;
@class SCLoopScrollView;

@protocol SCGroupTicketDetailViewControllerDelegate <NSObject>

@optional
- (void)reimburseSuccess;

@end

@interface SCGroupTicketDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SCLoopScrollView *ticketImagesView;
@property (weak, nonatomic) IBOutlet           UIView *refundView;

@property (nonatomic, weak)            id  <SCGroupTicketDetailViewControllerDelegate>delegate;
@property (nonatomic, weak) SCGroupTicket *ticket;

- (IBAction)refundButtonPressed:(id)sender;

@end
