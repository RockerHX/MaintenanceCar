//
//  SCOderDetailProgressCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@class SCOderDetail;

@interface SCOderDetailProgressCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet        UIImageView *upLine;
@property (weak, nonatomic) IBOutlet        UIImageView *dotIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotIconWidth;
@property (weak, nonatomic) IBOutlet        UIImageView *downLine;
@property (weak, nonatomic) IBOutlet            UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet            UILabel *nameLabel;

/**
 *  刷新订单状态数据
 *
 *  @param detail  订单数据模型
 *  @param index   cell所在row
 *
 *  @return 刷新后cell的高度
 */
- (CGFloat)displayCellWithDetail:(SCOderDetail *)detail index:(NSInteger)index;

@end
