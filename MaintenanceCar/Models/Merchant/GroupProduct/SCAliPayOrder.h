//
//  SCAliPayOrder.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/28.
//  Copyright (c) 2015年 WeiXinPayDemo. All rights reserved.
//

#import "JSONModel.h"

@interface SCAliPayOrder : JSONModel

@property(nonatomic, copy) NSString <Optional>*partner;
@property(nonatomic, copy) NSString <Optional>*seller_id;
@property(nonatomic, copy) NSString <Optional>*out_trade_no;
@property(nonatomic, copy) NSString <Optional>*subject;
@property(nonatomic, copy) NSString <Optional>*body;
@property(nonatomic, copy) NSString <Optional>*total_fee;
@property(nonatomic, copy) NSString <Optional>*notify_url;

@property(nonatomic, copy) NSString <Optional>*service;
@property(nonatomic, copy) NSString <Optional>*payment_type;
@property(nonatomic, copy) NSString <Optional>*input_charset;
@property(nonatomic, copy) NSString <Optional>*it_b_pay;
@property(nonatomic, copy) NSString <Optional>*show_url;

@property(nonatomic, copy) NSString <Optional>*sign;
@property(nonatomic, copy) NSString <Optional>*sign_type;

@property(nonatomic, copy) NSString <Optional>*rsaDate;//可选
@property(nonatomic, copy) NSString <Optional>*appID;//可选

- (NSString *)requestString;

@end
