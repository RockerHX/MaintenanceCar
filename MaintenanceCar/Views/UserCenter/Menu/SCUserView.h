//
//  SCUserView.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCUserViewDelegate <NSObject>

@optional
- (void)shouldLogin;
- (void)shouldEditUserInfo;

@end

@interface SCUserView : UIView

@property (weak, nonatomic) IBOutlet       id  <SCUserViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *header;
@property (weak, nonatomic) IBOutlet  UILabel *loginPromptLabel;
@property (weak, nonatomic) IBOutlet  UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel *infoLabel;

@end
