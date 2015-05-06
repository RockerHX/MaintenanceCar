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
#define STORY_BOARD(Name)                   [UIStoryboard storyboardWithName:Name bundle:nil]
#define STORY_BOARD_VIEW_CONTROLLER(Name)   [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:Name]
#define NOTIFICATION_CENTER                 [NSNotificationCenter defaultCenter]


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
#define PATH_OF_DOCUMENT        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define LabelSystemFont(size)   [UIFont systemFontOfSize:size]


// 通过十六进制的rgb值来返回一个UIColor实例
#define UIColorFromRGB(rgbHexValue)     [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbHexValue & 0xFF))/255.0f alpha:1.0f]
// 通过R,G,B,A四个原生值来返回一个UIColor实例
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#endif