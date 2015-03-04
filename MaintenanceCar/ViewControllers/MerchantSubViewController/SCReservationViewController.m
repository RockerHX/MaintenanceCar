//
//  SCReservationViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCReservationViewController.h"
#import "SCMerchant.h"
#import "SCServiceItem.h"
#import "SCPickerView.h"
#import "SCReservationDateViewController.h"

@interface SCReservationViewController () <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, SCPickerViewDelegate, SCReservationDateViewControllerDelegate>
{
    NSString *_reservationType;
    NSString *_reservationDate;
}

- (IBAction)reservationButtonPressed:(UIButton *)sender;

@end

@implementation SCReservationViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商家] - [商家预约]"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商家] - [商家预约]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SCReservationDateViewController *reservationDataViewController = segue.destinationViewController;
    reservationDataViewController.delegate  = self;
    reservationDataViewController.companyID = _merchant.company_id;
    reservationDataViewController.type      = _reservationType;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self closeAllKeyboard];
    // 点击[项目][日期][时间]栏触发选择动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3)
    {
        SCPickerView *pickerView = [[SCPickerView alloc] initWithDelegate:self];
        [pickerView show];
    }
}

#pragma mark - Button Action Methods
- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    [self closeAllKeyboard];
    // 检查是否登录，已登录进行预约请求，反之则弹出登录提示框跳转到登录页面
    if (![SCUserInfo share].loginStatus)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登录"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登录", nil];
        [alertView show];
    }
    else if ([self checkeParamterIntegrity])
        [self startMerchantReservationRequest];
}

#pragma mark - Private Methods
- (void)initConfig
{
    // 开启cell高度预估，自动适配cell高度
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 设置商家名称显示
    _merchantNameLabel.text = _merchant.name;
}

- (void)viewConfig
{
    _reservationButton.layer.cornerRadius   = 5.0f;
    _ownerNameTextField.leftViewMode        = UITextFieldViewModeAlways;
    _ownerNameTextField.leftView            = [[UIView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 5.0f, 1.0f)];
    _ownerPhoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    _ownerPhoneNumberTextField.leftView     = [[UIView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 5.0f, 1.0f)];
    _remarkTextField.leftViewMode           = UITextFieldViewModeAlways;
    _remarkTextField.leftView               = [[UIView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 5.0f, 1.0f)];
    _projectLabel.text                      = _serviceItem.service_name;
    _reservationType                        = _serviceItem.service_id;
    
    NSArray *items = [SCUserInfo share].selectedItems;
    for (NSString *item in items)
    {
        if (_remarkTextField.text.length)
            _remarkTextField.text = [_remarkTextField.text stringByAppendingString:[NSString stringWithFormat:@",%@", item]];
        else
            _remarkTextField.text = item;
    }
}

- (void)closeAllKeyboard
{
    // 关闭所有键盘
    [_ownerNameTextField resignFirstResponder];
    [_ownerPhoneNumberTextField resignFirstResponder];
    [_remarkTextField resignFirstResponder];
}

/**
 *  商家预约请求方法，参数：user_id, company_id, type, reserve_name, reserve_phone, content, time, user_car_id
 *  user_id:        用户 ID
 *  company_id:     商家 ID, 通过这个 ID 可以获取商家详细信息
 *  type:           1,2,3,4 对应 洗养修团
 *  reserve_name:   XXX
 *  reserve_phone:  电话
 *  content:        预约内容
 *  time:           预约时段,  如 2014-12-13 10:00:00 代表的时间段是当天10点到11点
 *  user_car_id:    可选. 用户已经添加的私家车 id
 *  返回:            reserve_id和友盟推送返回信息
 */
- (void)startMerchantReservationRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                              @"company_id": _merchant.company_id,
                                    @"type": _reservationType,
                            @"reserve_name": _ownerNameTextField.text,
                           @"reserve_phone": _ownerPhoneNumberTextField.text,
                                 @"content": _remarkTextField.text,
                                    @"time": _reservationDate};
    [[SCAPIRequest manager] startMerchantReservationAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
            [self showPromptHUDWithText:@"恭喜您，已经预约成功!" delay:1.0f delegate:self];
        else
            [self showPromptHUDWithText:@"很抱歉，预约未成功，请重试!" delay:1.0f delegate:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showPromptHUDWithText:@"网络异常，请重试!" delay:1.0f delegate:nil];
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

- (void)displayDateItemWithDate:(NSString *)date displayDate:(NSString *)displayDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *selectedDate = [formatter dateFromString:date];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    selectedDate = [formatter dateFromString:[formatter stringFromDate:selectedDate]];
    
    if ([selectedDate compare:currentDate] == NSOrderedSame)
    {
        NSString *displayDateString = @"今天(";
        _dateLabel.text = [[displayDateString stringByAppendingString:displayDate] stringByAppendingString:@")"];
        if (IS_IPHONE_5_PRIOR)
            _dateLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    else
        _dateLabel.text = displayDate;
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
        ShowPromptHUDWithText(self.view, @"请选择您需要预约的日期!", 1.0f);
        return NO;
    }
    else
        return YES;
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
        [self checkShouldLogin];
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

#pragma mark - MBProgressHUD Delegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SCPickerView Delegate Methods
- (void)pickerViewSelectedFinish:(SCServiceItem *)serviceItem
{
    _reservationType = serviceItem.service_id;
    _projectLabel.text = serviceItem.service_name;
}

#pragma mark - SCReservationDateViewController Delegate Methods
- (void)reservationDateSelectedFinish:(NSString *)requestDate displayDate:(NSString *)displayDate
{
    _reservationDate = requestDate;
    [self displayDateItemWithDate:requestDate displayDate:displayDate];
}

@end
