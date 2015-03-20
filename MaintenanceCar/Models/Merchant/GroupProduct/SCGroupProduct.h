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

@property (nonatomic, copy) NSString <Optional>*product_id;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*content;
@property (nonatomic, copy) NSString <Optional>*final_price;
@property (nonatomic, copy) NSString <Optional>*status;
@property (nonatomic, copy) NSString <Optional>*total_price;
@property (nonatomic, copy) NSString <Optional>*sell_count;

@property (nonatomic, copy) NSString <Optional>*companyID;
@property (nonatomic, copy) NSString <Optional>*merchantName;

@end
