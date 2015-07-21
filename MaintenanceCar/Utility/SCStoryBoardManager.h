//
//  SCStoryBoardManager.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCStoryBoardName) {
    SCStoryBoardNameMain,
    SCStoryBoardNameHomePage,
    SCStoryBoardNameShops,
    SCStoryBoardNameUserCenter,
    SCStoryBoardNameDetail,
    SCStoryBoardNameLogin,
    SCStoryBoardNameMap,
    SCStoryBoardNameSearch,
    SCStoryBoardNameOrderPay,
    SCStoryBoardNameReservation,
    SCStoryBoardNameComment,
    SCStoryBoardNameCar,
    SCStoryBoardNameOrder,
    SCStoryBoardNameCollection,
    SCStoryBoardNameGroupTicket,
    SCStoryBoardNameCoupon
};

@interface SCStoryBoardManager : NSObject

+ (id)navigaitonControllerWithIdentifier:(NSString *)identifier storyBoardName:(SCStoryBoardName)name;
+ (id)viewControllerWithClass:(Class)class storyBoardName:(SCStoryBoardName)name;

@end
