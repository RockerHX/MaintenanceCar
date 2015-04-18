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

@property (nonatomic, copy) NSString <Optional>*product_id;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*content;
@property (nonatomic, copy) NSString <Optional>*type;
@property (nonatomic, copy) NSString <Optional>*final_price;
@property (nonatomic, copy) NSString <Optional>*total_price;

@end
