//
//  SCSearchBar.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCSearchBarDelegate <NSObject>

@optional
- (void)shouldBackReturn;
- (void)shouldResearch;
- (void)shouldSearchWithContent:(NSString *)content;

@end

@interface SCSearchBar : UIView <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet          id  <SCSearchBarDelegate>delegate;
@property (weak, nonatomic) IBOutlet      UIView *fieldView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)backButtonPressed;
- (IBAction)searchButtonPressed;

@end
