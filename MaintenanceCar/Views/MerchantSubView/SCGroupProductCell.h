//
//  SCGroupProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCGroupProductCellDelegate <NSObject>

@optional
- (void)shouldShowBuyProductView;

@end

@interface SCGroupProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

@property (nonatomic, weak)      IBOutlet id <SCGroupProductCellDelegate>delegate;

- (IBAction)bugProductButtonPressed:(id)sender;

@end
