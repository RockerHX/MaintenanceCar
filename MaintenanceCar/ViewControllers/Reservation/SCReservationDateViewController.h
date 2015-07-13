//
//  SCReservationDateViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@protocol SCReservationDateViewControllerDelegate <NSObject>

@optional
- (void)reservationDateSelectedFinish:(NSString *)requestDate displayDate:(NSString *)displayDate;

@end

@interface SCReservationDateViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSDictionary *_dateItmes;
    NSArray      *_dateKeys;
    
    NSString     *_requestDate;
    NSString     *_displayDate;
}

@property (weak, nonatomic) IBOutlet          UILabel *promptTitleLabel;
@property (weak, nonatomic) IBOutlet          UILabel *subPromptTitleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *selectedCollectionView;

@property (nonatomic, weak)       id  <SCReservationDateViewControllerDelegate>delegate;
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, copy) NSString *type;

@end
