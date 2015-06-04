//
//  SCGroupProduct.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@protocol SCGroupProduct
@end

@interface SCGroupProduct : JSONModel

@property (nonatomic, strong) NSString <Optional>*product_id;
@property (nonatomic, strong) NSString <Optional>*title;
@property (nonatomic, strong) NSString <Optional>*content;
@property (nonatomic, strong) NSString <Optional>*final_price;
@property (nonatomic, strong) NSString <Optional>*status;
@property (nonatomic, strong) NSString <Optional>*total_price;
@property (nonatomic, strong) NSString <Optional>*sell_count;
@property (nonatomic, strong) NSString <Optional>*now;

@property (nonatomic, strong) NSString <Ignore>*companyID;
@property (nonatomic, strong) NSString <Ignore>*merchantName;
@property (nonatomic, strong) NSArray  <Ignore>*tickets;

@end
