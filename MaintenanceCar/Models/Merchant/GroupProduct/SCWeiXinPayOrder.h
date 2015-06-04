//
//  SCWeiXinPayOrder.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/28.
//  Copyright (c) 2015年 WeiXinPayDemo. All rights reserved.
//

#import "JSONModel.h"

@interface SCWeiXinPayOrder : JSONModel

@property (nonatomic, strong) NSString <Optional>*appid;
@property (nonatomic, strong) NSString <Optional>*noncestr;
@property (nonatomic, strong) NSString <Optional>*package;
@property (nonatomic, strong) NSString <Optional>*signType;
@property (nonatomic, strong) NSString <Optional>*sign;
@property (nonatomic, strong) NSString <Optional>*prepayid;
@property (nonatomic, strong) NSString <Optional>*partnerid;
@property (nonatomic, strong) NSString <Optional>*outTradeNo;
@property (nonatomic, assign) NSInteger           timestamp;

@end
