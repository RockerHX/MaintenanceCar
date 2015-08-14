//
//  SCOrderBase.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderBase.h"

@implementation SCOrderBase

#pragma mark - Class Methods
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (NSDictionary *)baseKeyMapper; {
    return @{@"reserve_id": @"reserveID",
             @"company_id": @"companyID",
         @"car_model_name": @"carModelName",
              @"type_name": @"serviceName",
           @"company_name": @"merchantName",
      @"company_telephone": @"merchantTelphone"};
}

#pragma mark - Setter And Getter Methods
- (NSString<Ignore> *)typeImageName {
    NSString *imageName;
    NSInteger type = [_type integerValue];
    switch (type) {
        case 1: {
            imageName = @"OrderIcon-XiChe";
            break;
        }
        case 2: {
            imageName = @"OrderIcon-BaoYang";
            break;
        }
        case 3: {
            imageName = @"OrderIcon-WeiXiu";
            break;
        }
        case 4: {
            imageName = @"OrderIcon-MeiRong";
            break;
        }
        case 5: {
            imageName = @"OrderIcon-JianCe";
            break;
        }
        default: {
            imageName = @"OrderIcon-ZuiXin";
            break;
        }
    }
    return imageName;
}

@end
