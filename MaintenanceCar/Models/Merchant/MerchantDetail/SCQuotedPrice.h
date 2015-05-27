//
//  SCQuotedPrice.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@protocol SCQuotedPrice
@end

@interface SCQuotedPrice : JSONModel

@property (nonatomic, strong) NSString <Optional>*product_id;
@property (nonatomic, strong) NSString <Optional>*title;
@property (nonatomic, strong) NSString <Optional>*content;
@property (nonatomic, strong) NSString <Optional>*type;
@property (nonatomic, strong) NSString <Optional>*final_price;
@property (nonatomic, strong) NSString <Optional>*total_price;
@property (nonatomic, strong) NSString <Optional>*price_begin;
@property (nonatomic, strong) NSString <Optional>*price_end;

@property (nonatomic, strong) NSString <Ignore>*companyID;
@property (nonatomic, strong) NSString <Ignore>*merchantName;

@end
