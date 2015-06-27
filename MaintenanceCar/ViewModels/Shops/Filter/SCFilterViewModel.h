//
//  SCFilterViewModel.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilter.h"

@class SCServerResponse;
@interface SCFilterViewModel : NSObject

@property (nonatomic, assign)                        BOOL  loaded;
@property (nonatomic, strong, readonly)  SCServerResponse *serverResponse;

@property (nonatomic, strong, readonly) SCFilter *filter;

- (void)load;

@end
