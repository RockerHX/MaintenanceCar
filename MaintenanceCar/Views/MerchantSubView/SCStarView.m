//
//  SCStarView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCStarView.h"

@implementation SCStarView

#pragma mark - Setter And Getter Methods
// 根据星级数来显示对应星级图片
- (void)setStartValue:(NSString *)startValue
{
    _startValue = startValue;
    NSInteger star = [startValue integerValue];
    
    switch (star)
    {
        case 1:
            self.image = [UIImage imageNamed:@"Grade-1"];
            break;
        case 2:
            self.image = [UIImage imageNamed:@"Grade-2"];
            break;
        case 3:
            self.image = [UIImage imageNamed:@"Grade-3"];
            break;
        case 4:
            self.image = [UIImage imageNamed:@"Grade-4"];
            break;
        case 5:
            self.image = [UIImage imageNamed:@"Grade-5"];
            break;
            
        default:
            self.image = [UIImage imageNamed:@"Grade-0"];
            break;
    }
}

@end
