//
//  SCStarView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCStarView : UIView

@property (nonatomic, strong)           NSString *value;
@property (nonatomic, strong, readonly) NSString *startValue;

@property (nonatomic, assign)             BOOL enabled;

@end
