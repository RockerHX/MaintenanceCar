//
//  SCDateCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDateCell.h"

@implementation SCDateCell

#pragma mark - Public Methods
- (void)diplayWithDate:(NSString *)date constant:(CGFloat)constant
{
    if (date)
    {
        // 更新约束，保证label正确显示
        _labelWidthConstraint.constant = constant;
        [_dayLabel needsUpdateConstraints];
        [_dayLabel layoutIfNeeded];
        [_weekLabel needsUpdateConstraints];
        [_weekLabel layoutIfNeeded];
        
        // 设置天数栏显示
        _dayLabel.text = [date substringWithRange:(NSRange){date.length - 2, 2}];
        
        // 通过日期获得星期几，再转换成对应的显示值
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *showDate = [dateFormatter dateFromString:date];
        
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"dd"];
        NSString *today    = [dayFormatter stringFromDate:[NSDate date]];
        NSString *tomorrow = [dayFormatter stringFromDate:[NSDate dateWithTimeInterval:60*60*24 sinceDate:[NSDate date]]];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSWeekdayCalendarUnit;
        comps = [calendar components:unitFlags fromDate:showDate];
        
        NSString *weekDay = [self weekDay:[comps weekday]];
        if ([_dayLabel.text integerValue] == [today integerValue])
            weekDay = @"今天";
        else if ([_dayLabel.text integerValue] == [tomorrow integerValue])
            weekDay = @"明天";
        
        _weekLabel.text = weekDay;
    }
}

#pragma mark - Private Methods
/**
 *  星期几转换方法
 *
 *  @param weekDay 星期值
 *
 *  @return 星期中文标示
 */
- (NSString *)weekDay:(NSInteger)weekDay
{
    switch (weekDay)
    {
        case 2:
            return @"一";
            break;
        case 3:
            return @"二";
            break;
        case 4:
            return @"三";
            break;
        case 5:
            return @"四";
            break;
        case 6:
            return @"五";
            break;
        case 7:
            return @"六";
            break;
            
        default:
            return @"日";
            break;
    }
}

@end
