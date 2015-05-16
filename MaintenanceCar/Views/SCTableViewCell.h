//
//  SCTableViewCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewCategory.h"

// V2卡片Cell基类
@interface SCTableViewCell : UITableViewCell

/**
 *  刷新Cell约束
 *
 *  @return 刷新后的Cell高度
 */
- (CGFloat)layoutSizeFittingSize;

@end
