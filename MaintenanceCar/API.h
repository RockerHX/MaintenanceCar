//
//  API.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/24.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#ifndef MaintenanceCar_API_h
#define MaintenanceCar_API_h

#define DoMain              @"https://api.yjclw.com"

#define APIPath             @"/v1"
#define APIURL              [DoMain stringByAppendingString:APIPath]

#define WearthAPI           @"/Weather"
#define SearchAPI           @"/company_search"

#define WearthAPIURL        [APIURL stringByAppendingString:WearthAPI]
#define SearchAPIURL        [APIURL stringByAppendingString:SearchAPI]

#endif
