//
//  SCStoryBoardManager.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCStoryBoardManager.h"

@implementation SCStoryBoardManager

+ (id)navigaitonControllerWithIdentifier:(NSString *)identifier storyBoardName:(SCStoryBoardName)name
{
    id controller = [self viewControllerWithIdentifier:identifier storyBoardName:name];
    return [controller isKindOfClass:[UINavigationController class]] ? controller : nil;
}

+ (id)viewControllerWithClass:(Class)class storyBoardName:(SCStoryBoardName)name
{
    NSString *identifier = NSStringFromClass([class class]);
    id controller = [self viewControllerWithIdentifier:identifier storyBoardName:name];
    return [controller isKindOfClass:[UIViewController class]] ? controller : nil;
}

#pragma mark - Private Methods
+ (NSString *)storyBoardName:(SCStoryBoardName)name
{
    NSString *storyBoardName = nil;
    switch (name)
    {
        case SCStoryBoardNameMain:
            storyBoardName = @"Main";
            break;
        case SCStoryBoardNameHomePage:
            storyBoardName = @"HomePage";
            break;
        case SCStoryBoardNameShops:
            storyBoardName = @"Shop";
            break;
        case SCStoryBoardNameUserCenter:
            storyBoardName = @"UserCenter";
            break;
        case SCStoryBoardNameDetail:
            storyBoardName = @"Detail";
            break;
        case SCStoryBoardNameLogin:
            storyBoardName = @"Login";
            break;
        case SCStoryBoardNameMap:
            storyBoardName = @"Map";
            break;
        case SCStoryBoardNameSearch:
            storyBoardName = @"Search";
            break;
        case SCStoryBoardNameOrderPay:
            storyBoardName = @"OrderPay";
            break;
        case SCStoryBoardNameReservation:
            storyBoardName = @"Reservation";
            break;
        case SCStoryBoardNameComment:
            storyBoardName = @"Comment";
            break;
        case SCStoryBoardNameCar:
            storyBoardName = @"Car";
            break;
        case SCStoryBoardNameOrder:
            storyBoardName = @"Order";
            break;
        case SCStoryBoardNameCollection:
            storyBoardName = @"Collection";
            break;
        case SCStoryBoardNameGroupTicket:
            storyBoardName = @"GroupTicket";
            break;
        case SCStoryBoardNameCoupon:
            storyBoardName = @"Coupon";
            break;
    }
    return storyBoardName;
}

+ (id)viewControllerWithIdentifier:(NSString *)identifier storyBoardName:(SCStoryBoardName)name
{
    @try {
        NSString *storyBoardName = [self storyBoardName:name];
        return [[UIStoryboard storyboardWithName:storyBoardName bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    }
    @catch (NSException *exception) {
        NSLog(@"Load View Controller From StoryBoard Error:%@", exception.reason);
    }
    @finally {
    }
}

@end
