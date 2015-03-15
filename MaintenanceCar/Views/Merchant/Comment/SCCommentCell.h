//
//  SCCommentCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCStarView;
@class SCComment;

@interface SCCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;         // 用户头像
@property (weak, nonatomic) IBOutlet     UILabel *userNameLabel;    // 用户名栏
@property (weak, nonatomic) IBOutlet  SCStarView *starView;         // 用户评星栏
@property (weak, nonatomic) IBOutlet     UILabel *commentDateLabel; // 评价日期栏
@property (weak, nonatomic) IBOutlet     UILabel *contentLabel;     // 评价详情栏

- (void)displayCellWithComment:(SCComment *)comment;

@end
