//
//  SCOderBaseCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

// V2订单基类
@interface SCOderBaseCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *serviceTypeIcon;          // 服务类型图标
@property (weak, nonatomic) IBOutlet     UILabel *carModelLabel;            // 车辆车型栏
@property (weak, nonatomic) IBOutlet     UILabel *serviceNameLabel;         // 服务名称栏
@property (weak, nonatomic) IBOutlet     UILabel *merchantNameLabel;        // 商家名称栏

@end
