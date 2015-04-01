//
//  SCWeiXinPayOder.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/28.
//  Copyright (c) 2015年 WeiXinPayDemo. All rights reserved.
//

#import "JSONModel.h"

@interface SCWeiXinPayOder : JSONModel

@property (nonatomic, copy)   NSString <Optional>*appid;
@property (nonatomic, copy)   NSString <Optional>*noncestr;
@property (nonatomic, copy)   NSString <Optional>*package;
@property (nonatomic, copy)   NSString <Optional>*signType;
@property (nonatomic, copy)   NSString <Optional>*sign;
@property (nonatomic, copy)   NSString <Optional>*prepayid;
@property (nonatomic, copy)   NSString <Optional>*partnerid;
@property (nonatomic, copy)   NSString <Optional>*out_trade_no;
@property (nonatomic, assign) NSInteger           timestamp;

@end
