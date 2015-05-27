//
//  SCMerchantInfo.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMerchantDetailBase.h"

@class SCMerchantDetail;

@interface SCMerchantInfoItem : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong)  UIColor *textColor;

@property (nonatomic, assign) CGFloat  fontSize;
@property (nonatomic, assign)    BOOL  canSelected;

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@end


@interface SCMerchantInfo : SCMerchantDetailBase

@property (nonatomic, strong, readonly) NSArray *infoItems;

@end
