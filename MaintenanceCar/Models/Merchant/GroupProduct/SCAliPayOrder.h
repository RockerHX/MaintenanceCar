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
@property(nonatomic, strong) NSString <Optional>*sellerID;
@property(nonatomic, strong) NSString <Optional>*outTradeNo;
@property(nonatomic, strong) NSString <Optional>*subject;
@property(nonatomic, strong) NSString <Optional>*body;
@property(nonatomic, strong) NSString <Optional>*totalFee;
@property(nonatomic, strong) NSString <Optional>*notifyURL;

@property(nonatomic, strong) NSString <Optional>*service;
@property(nonatomic, strong) NSString <Optional>*paymentType;
@property(nonatomic, strong) NSString <Optional>*inputCharset;
@property(nonatomic, strong) NSString <Optional>*itBPay;
@property(nonatomic, strong) NSString <Optional>*showURL;

@property(nonatomic, strong) NSString <Optional>*sign;
@property(nonatomic, strong) NSString <Optional>*signType;

@property(nonatomic, strong) NSString <Optional>*rsaDate;   //可选
@property(nonatomic, strong) NSString <Optional>*appID;     //可选

- (NSString *)requestString;

@end
