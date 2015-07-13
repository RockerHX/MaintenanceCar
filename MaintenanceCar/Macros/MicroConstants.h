//
//  MicroCommon.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/24.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#ifndef MaintenanceCar_MicroCommons_h
#define MaintenanceCar_MicroCommons_h

#pragma mark - System Framework Singleton Define
#define APP_DELEGATE_INSTANCE               ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define USER_DEFAULT                        [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER                 [NSNotificationCenter defaultCenter]

#define STORY_BOARD(Name)                   [UIStoryboard storyboardWithName:Name bundle:nil]
#define MAIN_VIEW_CONTROLLER(Name)          [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:Name]
#define USERCENTER_VIEW_CONTROLLER(Name)    [STORY_BOARD(@"UserCenter") instantiateViewControllerWithIdentifier:Name]
#define SHOPS_VIEW_CONTROLLER(Name)         [STORY_BOARD(@"Shops") instantiateViewControllerWithIdentifier:Name]
#define SEARCH_VIEW_CONTROLLER(Name)        [STORY_BOARD(@"Search") instantiateViewControllerWithIdentifier:Name]
#define ORDER_VIEW_CONTROLLER(Name)         [STORY_BOARD(@"Order") instantiateViewControllerWithIdentifier:Name]
#define ORDER_PAY_VIEW_CONTROLLER(Name)     [STORY_BOARD(@"OrderPay") instantiateViewControllerWithIdentifier:Name]
#define COUPON_VIEW_CONTROLLER(Name)        [STORY_BOARD(@"Coupon") instantiateViewControllerWithIdentifier:Name]
#define GROUP_TICKET_VIEW_CONTROLLER(Name)  [STORY_BOARD(@"GroupTicket") instantiateViewControllerWithIdentifier:Name]
#define COLLECTION_VIEW_CONTROLLER(Name)    [STORY_BOARD(@"Collection") instantiateViewControllerWithIdentifier:Name]
#define LOGIN_VIEW_CONTROLLER(Name)         [STORY_BOARD(@"Login") instantiateViewControllerWithIdentifier:Name]
#define MAP_VIEW_CONTROLLER(Name)           [STORY_BOARD(@"Map") instantiateViewControllerWithIdentifier:Name]
#define RESERVATION_VIEW_CONTROLLER(Name)   [STORY_BOARD(@"Reservation") instantiateViewControllerWithIdentifier:Name]
#define COMMENT_VIEW_CONTROLLER(Name)       [STORY_BOARD(@"Comment") instantiateViewControllerWithIdentifier:Name]
#define CAR_VIEW_CONTROLLER(Name)           [STORY_BOARD(@"Car") instantiateViewControllerWithIdentifier:Name]
#define HOMEPAGE_VIEW_CONTROLLER(Name)      [STORY_BOARD(@"HomePage") instantiateViewControllerWithIdentifier:Name]
#define DETAIL_VIEW_CONTROLLER(Name)        [STORY_BOARD(@"Detail") instantiateViewControllerWithIdentifier:Name]

#define CLASS_NAME(Class)                   NSStringFromClass([Class class])

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define EMPTY_STRING            @""

#define STR(key)                NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME        NSHomeDirectory()
#define PATH_OF_TEMP            NSTemporaryDirectory()
#define PATH_OF_DOCUMENT        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define LabelSystemFont(size)   [UIFont systemFontOfSize:size]

#define WEAK_SELF(weakSelf)     __weak __typeof(&*self)weakSelf = self


// 通过十六进制的rgb值来返回一个UIColor实例
#define UIColorFromRGB(rgbHexValue)     [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbHexValue & 0xFF))/255.0f alpha:1.0f]
// 通过R,G,B,A四个原生值来返回一个UIColor实例
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#endif