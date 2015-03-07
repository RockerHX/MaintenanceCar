//
//  SCGroupProductTicket.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/7.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCGroupProductTicket : JSONModel

@property (nonatomic, copy)  NSString <Optional>*group_ticket_id;
@property (nonatomic, strong) NSArray <Optional>*code;

@end
