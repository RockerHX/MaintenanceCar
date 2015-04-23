//
//  SCMyOder.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOder.h"

@implementation SCMyOder

#pragma mark - Class Methods
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"reserveID": @"reserve_id",
                                                    @"carModelName": @"car_model_name",
                                                     @"serviceName": @"service_name",
                                                    @"merchantName": @"name",
                                               @"previousStateDate": @"previous_time",
                                               @"previousStateName": @"previous_name",
                                                @"currentStateDate": @"current_time",
                                                @"currentStateName": @"current_name",
                                                   @"nextStateDate": @"next_time",
                                                   @"nextStateName": @"next_name",
                                                @"merchantTelphone": @"telephone"}];
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
