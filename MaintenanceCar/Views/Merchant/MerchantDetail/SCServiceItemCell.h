//
//  SCServiceItemCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCServiceItemCellDelegate <NSObject>

@optional
- (void)itemTapedWithTitle:(NSString *)title ID:(NSString *)ID;

@end

@interface SCServiceItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet    UIButton *icon;
@property (weak, nonatomic) IBOutlet     UILabel *textLabel;

@property (nonatomic, weak)                   id  <SCServiceItemCellDelegate>delegate;

- (IBAction)itemPressed:(id)sender;

- (void)displayCellWithDate:(NSDictionary *)data;

@end
