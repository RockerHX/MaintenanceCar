//
//  SCFilterViewModel.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilter.h"

@interface SCFilterViewModel : NSObject

@property (nonatomic, strong, readonly) SCFilter *filter;

- (void)loadCompleted:(void(^)(SCFilterViewModel *viewModel, BOOL success))block;

@end
