//
//  Version.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#ifndef MaintenanceCar_VersionConstants_h
#define MaintenanceCar_VersionConstants_h

#define CURRENT_SYSTEM_VERSION              [[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS5                             ((CURRENT_SYSTEM_VERSION >= 5.0f && CURRENT_SYSTEM_VERSION < 6.0f) ? YES : NO)
#define IS_IOS6                             ((CURRENT_SYSTEM_VERSION >= 6.0f && CURRENT_SYSTEM_VERSION < 7.0f) ? YES : NO)
#define IS_IOS7                             ((CURRENT_SYSTEM_VERSION >= 7.0f && CURRENT_SYSTEM_VERSION < 8.0f) ? YES : NO)
#define IS_IOS8                             ((CURRENT_SYSTEM_VERSION >= 8.0f) ? YES : NO)

#define IS_WIDESCREEN_4                     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < __DBL_EPSILON__)
#define IS_WIDESCREEN_5                     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6                     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6Plus                 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < __DBL_EPSILON__)

#define IS_IPHONE                           ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone"] || [[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"])
#define IS_IPOD                             ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"])

#define IS_IPHONE_4                         (IS_IPHONE && IS_WIDESCREEN_4)
#define IS_IPHONE_5_PRIOR                   (IS_IPHONE && (IS_WIDESCREEN_5 || IS_WIDESCREEN_4))
#define IS_IPHONE_5                         (IS_IPHONE && IS_WIDESCREEN_5)
#define IS_IPHONE_6                         (IS_IPHONE && IS_WIDESCREEN_6)
#define IS_IPHONE_6Plus                     (IS_IPHONE && IS_WIDESCREEN_6Plus)

#endif
