//
//  SCReservationViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCReservationViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCMerchant.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"
#import "SCPickerView.h"
#import "SCDatePickerView.h"

typedef NS_ENUM(NSInteger, UITableViewRowIndex) {
    UITableViewRowIndexProject = 3,
    UITableViewRowIndexDate,
    UITableViewRowIndexTime
};

@interface SCReservationViewController () <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, SCPickerViewDelegate, SCDatePickerViewDelegate>
{
    NSString *_reservationType;
    NSString *_reservationDate;
    NSString *_reservationTime;
    NSString *_reservationCarID;
}

- (IBAction)reservationButtonPressed:(UIButton *)sender;

@end

@implementation SCReservationViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 开启cell高度预估，自动适配cell高度
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 设置商户名称显示
    _reservationCarID = @"";
    _merchantNameLabel.text = _merchant.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_ownerNameTextField resignFirstResponder];
    [_ownerPhoneNumberTextField resignFirstResponder];
    [_remarkTextField resignFirstResponder];
    // 点击[项目][日期][时间]栏触发选择动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case UITableViewRowIndexProject:
        {
            SCPickerView *pickerView = [[SCPickerView alloc] initWithDelegate:self];
            [pickerView show];
        }
            break;
        case UITableViewRowIndexDate:
        {
            SCDatePickerView *datePickerView = [[SCDatePickerView alloc] initWithDelegate:self mode:UIDatePickerModeDate];
            [datePickerView show];
        }
            break;
        case UITableViewRowIndexTime:
        {
            SCDatePickerView *datePickerView = [[SCDatePickerView alloc] initWithDelegate:self mode:UIDatePickerModeTime];
            [datePickerView show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Button Action Methods
- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    if (![SCUserInfo share].loginStatus)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登陆"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登陆", nil];
        [alertView show];
    }
    else if ([self checkeParamterIntegrity])
    {
        [self startMerchantReservationRequest];
    }
}

#pragma mark - Private Methods
/**
 *  商户预约请求方法，参数：user_id, company_id, type, reserve_name, reserve_phone, content, time, user_car_id
 *  user_id: 用户 ID
 *  company_id: 商户 ID, 通过这个 ID 可以获取商户详细信息
 *  type:1,2,3,4 对应 洗养修团
 *  reserve_name: XXX
 *  reserve_phone: 电话
 *  content: 预约内容
 *  time: 预约时段,  如 2014-12-13 10:00:00 代表的时间段是当天10点到11点
 *  user_car_id: 可选. 用户已经添加的私家车 id
 *  返回: reserve_id和友盟推送返回信息
 */
- (void)startMerchantReservationRequest
{
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                              @"company_id": _merchant.company_id,
                                    @"type": _reservationType,
                            @"reserve_name": _ownerNameTextField.text,
                           @"reserve_phone": _ownerPhoneNumberTextField.text,
                                 @"content": _remarkTextField.text,
                                    @"time": [_reservationDate stringByAppendingString:_reservationTime],
                             @"user_car_id": _reservationCarID};
    [[SCAPIRequest manager] startMerchantReservationAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            [self showPromptHUDWithText:@"恭喜您，已经预约成功!" delay:1.5f delegate:self];
        }
        else
        {
            [self showPromptHUDWithText:@"很抱歉，预约未成功，请重试!" delay:1.5f delegate:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil]);
        [self showPromptHUDWithText:@"网络异常，请重试!" delay:1.5f delegate:nil];
    }];
}

/**
 *  用户提示方法
 *
 *  @param text     提示内容
 *  @param delay    提示消失时间
 *  @param delegate 代理对象
 */
- (void)showPromptHUDWithText:(NSString *)text delay:(NSTimeInterval)delay delegate:(id<MBProgressHUDDelegate>)delegate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = delegate;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = SCREEN_HEIGHT/2 - 100.0f;
    hud.margin = 10.f;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
}

- (void)checkShouldLogin
{
    if (![SCUserInfo share].loginStatus)
    {
        [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
    }
}

- (void)displayDateItemWithDate:(NSDate *)date
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateStyle = kCFDateFormatterFullStyle;
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    if ([date compare:currentDate] == NSOrderedAscending)
    {
        NSString *displayDateString = @"今天（";
        NSString *dateString = [fmt stringFromDate:currentDate];
        _dateLabel.text = [[displayDateString stringByAppendingString:dateString] stringByAppendingString:@")"];
    }
    else
    {
        fmt.dateStyle = kCFDateFormatterFullStyle;
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _dateLabel.text = [fmt stringFromDate:date];
    }
}

- (void)displayTimeItemWithDate:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeStyle = kCFDateFormatterShortStyle;
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _timeLabel.text = [self dateWhichPeriodWithDate:date];
}

- (NSString *)dateWhichPeriodWithDate:(NSDate *)date
{
    NSInteger index;
    for (index = [[self getCurrentHourWithDate:date] integerValue]; index < 24; index++)
    {
        NSInteger from = index;
        NSInteger to = index + 1;
        
        if ([self date:date betweenFromHour:from toHour:to])
        {
            break;
        }
    }
    return [NSString stringWithFormat:@"%@:00 -- %@:00", @(index), @(index+1)];
}

- (NSString *)getCurrentHourWithDate:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"HH"];
    return [fmt stringFromDate:date];
}

/**
 *  判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 *
 *  @param date     需要判断的时间
 *  @param fromHour 判断初始值
 *  @param toHour   判断结束值
 *
 *  @return 是否是对应范围之内
 */
- (BOOL)date:(NSDate *)date betweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *fromDate = [self getCustomDateWithHour:fromHour];
    NSDate *toDate = [self getCustomDateWithHour:toHour];
    
    return (([date compare:fromDate] == NSOrderedDescending) && ([date compare:toDate] == NSOrderedAscending)) ? YES : NO;
}

/**
 *  生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 *
 *  @param hour 如hour为“8”，就是上午8:00（本地时间）
 *
 *  @return 时间点
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

- (BOOL)checkeParamterIntegrity
{
    if (![_ownerNameTextField.text length])
    {
        ShowPromptHUDWithText(self.view, @"请输入您的姓名!", 1.0f);
        return NO;
    }
    else if (![_ownerPhoneNumberTextField.text length])
    {
        ShowPromptHUDWithText(self.view, @"请输入您的手机号码!", 1.0f);
        return NO;
    }
    else if (!_reservationType)
    {
        ShowPromptHUDWithText(self.view, @"请选择您需要预约的类型!", 1.0f);
        return NO;
    }
    else if (!_reservationDate)
    {
        ShowPromptHUDWithText(self.view, @"请选择您需要预约的时间!", 1.0f);
        return NO;
    }
    else if (!_reservationTime)
    {
        ShowPromptHUDWithText(self.view, @"请选择您需要预约的时间!", 1.0f);
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self checkShouldLogin];
    }
}

#pragma mark - Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 在车主姓名栏点击[下一项]跳到车主电话栏，车主电话栏和备注栏点击[完成]收起键盘
    if (textField == _ownerNameTextField)
    {
        [_ownerPhoneNumberTextField becomeFirstResponder];
        return NO;
    }
    else
    {
        [textField resignFirstResponder];
        return YES;
    }
}

#pragma mark - MBProgressHUDDelegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SCDatePickerViewDelegate Methods
- (void)datePickerSelectedFinish:(NSDate *)date mode:(UIDatePickerMode)mode
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    switch (mode)
    {
        case UIDatePickerModeDate:
        {
            [formatter setDateFormat:@"yyyy-MM-dd"];
            _reservationDate = [formatter stringFromDate:date];
            [self displayDateItemWithDate:date];
        }
            break;
        case UIDatePickerModeTime:
        {
            _reservationTime = [NSString stringWithFormat:@" %@:00:00", [self getCurrentHourWithDate:date]];
            [self displayTimeItemWithDate:date];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SCPickerViewDelegate Methods
- (void)pickerViewSelectedFinish:(NSString *)item displayName:(NSString *)name
{
    _reservationType = item;
    _projectLabel.text = name;
}

@end
