//
//  SCOderBase.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderBase.h"

@implementation SCOderBase

#pragma mark - Class Methods
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (NSDictionary *)baseKeyMapper;
{
    return @{@"reserve_id": @"reserveID",
             @"company_id": @"companyID",
         @"car_model_name": @"carModelName",
              @"type_name": @"serviceName",
           @"company_name": @"merchantName",
      @"company_telephone": @"merchantTelphone"};
}

#pragma mark - Setter And Getter Methods
- (NSString<Ignore> *)typeImageName
{
    NSString *imageName;
    NSInteger type = [_type integerValue];
    switch (type)
    {
        case 1:
            imageName = @"OderIcon-XiChe";
            break;
        case 2:
            imageName = @"OderIcon-BaoYang";
            break;
        case 3:
            imageName = @"OderIcon-WeiXiu";
            break;
        case 4:
            imageName = @"OderIcon-MeiRong";
            break;
        case 5:
            imageName = @"OderIcon-JianCe";
            break;
            
        default:
            imageName = @"OderIcon-ZuiXin";
            break;
    }
    return imageName;
}

@end
