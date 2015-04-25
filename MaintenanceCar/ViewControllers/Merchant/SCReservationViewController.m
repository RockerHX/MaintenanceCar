//
//  SCReservationViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCReservationViewController.h"
#import "SCPickerView.h"
#import "SCReservationDateViewController.h"
#import "SCAllDictionary.h"
#import "SCAddCarViewController.h"

@interface SCReservationViewController () <UITextFieldDelegate, UIAlertViewDelegate, SCPickerViewDelegate, SCReservationDateViewControllerDelegate, SCAddCarViewControllerDelegate>
{
    NSString *_selectedCarID;
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

- (void)dealloc
{
    [NOTIFICATION_CENTER removeObserver:self name:kUserCarsDataNeedReloadSuccessNotification object:nil];
}

#pragma mark - Config Methods
- (void)initConfig
{
    // 开启cell高度预估，自动适配cell高度
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 设置商家名称显示
    _price = @"";
    _selectedCarID = @"";
    _merchantNameLabel.text = _merchant.name;
    [NOTIFICATION_CENTER addObserver:self selector:@selector(refresh) name:kUserCarsDataNeedReloadSuccessNotification object:nil];
}

- (void)viewConfig
{
    _reservationButton.layer.cornerRadius   = 5.0f;
    _ownerNameTextField.leftViewMode        = UITextFieldViewModeAlways;
    _ownerNameTextField.leftView            = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, 5.0f, 1.0f)];
    _ownerNameTextField.text                = [SCUserInfo share].ownerName;
    _ownerPhoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    _ownerPhoneNumberTextField.leftView     = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, 5.0f, 1.0f)];
    _ownerPhoneNumberTextField.text         = [SCUserInfo share].phoneNmber;
    _remarkTextField.leftViewMode           = UITextFieldViewModeAlways;
    _remarkTextField.leftView               = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, 5.0f, 1.0f)];
    
    [self refreshProjectLabel];
    
    NSArray *items = [SCUserInfo share].selectedItems;
    for (NSString *item in items)
    {
        if (_remarkTextField.text.length)
            _remarkTextField.text = [_remarkTextField.text stringByAppendingString:[NSString stringWithFormat:@",%@", item]];
        else
            _remarkTextField.text = item;
    }
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
    
    SCPickerView *pickerView = nil;
    if (indexPath.row == 3)
        pickerView = [[SCPickerView alloc] initWithItems:nil type:SCPickerTypeCar delegate:self];
    else if ((indexPath.row == 4) && _canChange)
        pickerView = [[SCPickerView alloc] initWithItems:nil type:SCPickerTypeService delegate:self];
    [pickerView show];
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
- (void)refresh
{
    [[SCUserInfo share] userCarsReuqest:nil];
}

- (void)closeAllKeyboard
{
    // 关闭所有键盘
    [_ownerNameTextField resignFirstResponder];
    [_ownerPhoneNumberTextField resignFirstResponder];
    [_remarkTextField resignFirstResponder];
}

- (void)refreshProjectLabel
{
    _categoryLabel.text = _serviceItem.service_name;
    _reservationType    = _serviceItem.service_id;
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
    [self showHUDOnViewController:self];
    __weak typeof(self)weakSelf = self;
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                              @"company_id": _merchant.company_id,
                                    @"type": _reservationType,
                            @"reserve_name": _ownerNameTextField.text,
                           @"reserve_phone": _ownerPhoneNumberTextField.text,
                                 @"content": _remarkTextField.text,
                                    @"time": _reservationDate,
                             @"user_car_id": _selectedCarID,
                                   @"price": _price};
    [[SCAPIRequest manager] startMerchantReservationAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf];
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            NSString *statusMessage = responseObject[@"status_message"];
            if (![statusMessage isEqualToString:@"success"])
            {
                [[SCUserInfo share] saveOwnerName:_ownerNameTextField.text];
                [weakSelf showHUDAlertToViewController:weakSelf tag:Zero text:statusMessage];
            }
        }
        else
            [weakSelf showHUDAlertToViewController:weakSelf text:DataError];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideHUDOnViewController:weakSelf];
        [weakSelf hanleFailureResponseWtihOperation:operation];
    }];
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
        [self showHUDAlertToViewController:self text:@"请输入您的姓名!"];
        return NO;
    }
    else if (![_ownerPhoneNumberTextField.text length])
    {
        [self showHUDAlertToViewController:self text:@"请输入您的手机号码!"];
        return NO;
    }
    else if (!_reservationType)
    {
        [self showHUDAlertToViewController:self text:@"请选择您需要预约的类型!"];
        return NO;
    }
    else if (!_reservationDate)
    {
        [self showHUDAlertToViewController:self text:@"请选择您需要预约的日期!"];
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
- (void)pickerView:(SCPickerView *)pickerView didSelectRow:(NSInteger)row item:(id)item
{
    switch (pickerView.type)
    {
        case SCPickerTypeCar:
        {
            if ([pickerView lastItem:item])
            {
                if ([SCUserInfo share].loginStatus)
                {
                    @try {
                        UINavigationController *addCarViewNavigationControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCAddCarViewNavigationController"];
                        SCAddCarViewController *addCarViewController = (SCAddCarViewController *)addCarViewNavigationControler.topViewController;
                        addCarViewController.delegate = self;
                        [self presentViewController:addCarViewNavigationControler animated:YES completion:nil];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"SCMyReservationTableViewController Go to the SCAddCarViewNavigationControler exception reasion:%@", exception.reason);
                    }
                    @finally {
                        [pickerView hidde];
                    }
                }
                else
                    [self showShoulLoginAlert];
            }
            else
            {
                SCUserCar *car = item;
                _selectedCarID = car.user_car_id;
                _carLabel.text = [car.brand_name stringByAppendingString:car.model_name];
            }
        }
            break;
        case SCPickerTypeService:
        {
            SCServiceItem *serviceItem = item;
            _reservationType           = serviceItem.service_id;
            _categoryLabel.text        = serviceItem.service_name;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SCReservationDateViewController Delegate Methods
- (void)reservationDateSelectedFinish:(NSString *)requestDate displayDate:(NSString *)displayDate
{
    _reservationDate = requestDate;
    [self displayDateItemWithDate:requestDate displayDate:displayDate];
}

#pragma mark - SCAddCarViewController Delegate Methods
- (void)addCarSuccess:(SCCar *)car
{
    _selectedCarID = car.user_car_id;
    _carLabel.text = [car.brand_name stringByAppendingString:car.model_name];
}

@end
