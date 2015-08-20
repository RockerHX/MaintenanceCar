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
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"reserveID": @"reserve_id",
             @"companyID": @"company_id",
          @"carModelName": @"car_model_name",
           @"serviceName": @"type_name",
          @"merchantName": @"company_name",
      @"merchantTelphone": @"company_telephone"};
}

#pragma mark - Setter And Getter Methods
- (NSString *)typeImageName {
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
