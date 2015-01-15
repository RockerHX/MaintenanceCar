//
//  SCCollectionIndexView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCollectionIndexView : UIControl

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@property (strong, nonatomic)   NSArray   *indexTitles;
@property (readonly, nonatomic) NSInteger selectedIndex;

- (id)initWithFrame:(CGRect)frame indexTitles:(NSArray *)indexTitles;
- (NSString *)selectedIndexTitle;

- (void)showWithAnimation:(BOOL)animation;
- (void)hiddenWithAnimation:(BOOL)animation;

@end
