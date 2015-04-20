//
//  SCMyOderCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewCategory.h"
#import "AllMicroConstants.h"
#import "SCReservation.h"

@protocol SCMyOderCellDelegate <NSObject>

@optional
- (void)shouldCallMerchant;

@end

@interface SCMyOderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *serviceTypeIcon;
@property (weak, nonatomic) IBOutlet     UILabel *carModelLabel;
@property (weak, nonatomic) IBOutlet     UILabel *merchantNameLabel;

@property (nonatomic, weak) id<SCMyOderCellDelegate>delegate;

- (CGFloat)displayCellWithReservation:(SCReservation *)reservation;

- (IBAction)callMerchantButtonPressed:(id)sender;

@end
