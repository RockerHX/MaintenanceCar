//
//  SCAliPayOrder.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/28.
//  Copyright (c) 2015年 WeiXinPayDemo. All rights reserved.
//

#import "JSONModel.h"

@interface SCAliPayOrder : JSONModel

@property(nonatomic, strong) NSString <Optional>*partner;
@property(nonatomic, strong) NSString <Optional>*seller_id;
@property(nonatomic, strong) NSString <Optional>*out_trade_no;
@property(nonatomic, strong) NSString <Optional>*subject;
@property(nonatomic, strong) NSString <Optional>*body;
@property(nonatomic, strong) NSString <Optional>*total_fee;
@property(nonatomic, strong) NSString <Optional>*notify_url;

@property(nonatomic, strong) NSString <Optional>*service;
@property(nonatomic, strong) NSString <Optional>*payment_type;
@property(nonatomic, strong) NSString <Optional>*input_charset;
@property(nonatomic, strong) NSString <Optional>*it_b_pay;
@property(nonatomic, strong) NSString <Optional>*show_url;

@property(nonatomic, strong) NSString <Optional>*sign;
@property(nonatomic, strong) NSString <Optional>*sign_type;

@property(nonatomic, strong) NSString <Optional>*rsaDate;//可选
@property(nonatomic, strong) NSString <Optional>*appID;//可选

- (NSString *)requestString;

@end
