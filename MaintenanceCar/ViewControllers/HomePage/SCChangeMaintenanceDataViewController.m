//
//  SCChangeMaintenanceDataViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCChangeMaintenanceDataViewController.h"
#import "SCUserCar.h"
#import "SCDatePickerView.h"
#import "SCCarDriveHabitsView.h"

typedef NS_ENUM(NSInteger, SCHUDType) {
    SCHUDTypeDefault,
    SCHUDTypeSaveData,
    SCHUDTypeDeleteCar
};

@interface SCChangeMaintenanceDataViewController () <UITextFieldDelegate, SCDatePickerViewDelegate, SCCarDriveHabitsViewDelegate>

@end

@implementation SCChangeMaintenanceDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 数据初始化
    [self initConfig];
    [self viewConfig];
    [self viewDisplay];
}

#pragma mark - Action Methods
- (IBAction)deleteCarButtonPressed
{
    [self showAlertWithTitle:@"警告"
                     message:@"您确定要删除您的车辆吗？"
                    delegate:self
                         tag:Zero
           cancelButtonTitle:@"确认"
            otherButtonTitle:@"取消"];
}

- (IBAction)buyCarDateButtonPressed
{
    // 购车按钮点击事件触发，收起键盘，弹出时间选择器
    [self.view endEditing:YES];
    
    SCDatePickerView *datePicker = [[SCDatePickerView alloc] initWithDelegate:self mode:UIDatePickerModeDate];
    datePicker.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:DOT_COORDINATE];
    datePicker.datePicker.maximumDate = [NSDate date];
    [datePicker show];                                    
}

#pragma mark - Private Methods
- (void)initConfig
{
    // 初始化的时候加入单击手势，用于页面点击收起数字键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
    [self.buyCarDateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyCarDateButtonPressed)]];
}

- (void)viewConfig
{
    // 配置页面元素，设置圆角
    _userCarLabel.layer.borderWidth     = 1.0f;
    _userCarLabel.layer.borderColor     = [UIColor lightGrayColor].CGColor;

    _mileageTextField.layer.borderWidth = 1.0f;
    _mileageTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;

    _buyCarDateLabel.layer.borderWidth  = 1.0f;
    _buyCarDateLabel.layer.borderColor  = [UIColor lightGrayColor].CGColor;
}

- (void)viewDisplay
{
    // 刷新页面数据
    _userCarLabel.text             = [_car.brand_name stringByAppendingString:_car.model_name];
    _mileageTextField.text         = _car.run_distance;
    _buyCarDateLabel.text          = ([_car.buy_car_year integerValue] && [_car.buy_car_month integerValue]) ? [NSString stringWithFormat:@"%@年%@月", _car.buy_car_year, _car.buy_car_month] : @"";

    _carDriveHabitsView.delegate   = self;
    _carDriveHabitsView.habitsType = (SCHabitsType)[_car.habit integerValue];
}

/**
 *  页面单击手势事件
 */
- (void)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

/**
 *  车辆数据更新请求，参数：user_id, user_car_id必选，其他可选参数见API文档
 */
- (void)startUpdateUserCarRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters =               @{@"user_id": [SCUserInfo share].userID,
                                           @"user_car_id": _car.user_car_id,
                                              @"model_id": _car.model_id,
                                          @"buy_car_year": _car.buy_car_year,
                                         @"buy_car_month": _car.buy_car_month,
                                          @"run_distance": _car.run_distance,
                                                 @"habit": _car.habit};
    [[SCAPIRequest manager] startUpdateUserCarAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
                if (finish)
                    [weakSelf showHUDAlertToViewController:weakSelf tag:SCHUDTypeSaveData text:@"保存成功！" delay:0.5f];
            }];
        }
        else
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"数据保存失败，请重试！" delay:0.5f];
    }];
}

- (void)startDeleteUserCarRequest
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"user_car_id": _car.user_car_id};
    [[SCAPIRequest manager] startDeleteCarAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
                if (finish)
                {
                    [weakSelf showHUDAlertToViewController:weakSelf tag:SCHUDTypeDeleteCar text:@"删除成功！" delay:0.5f];
                    [NOTIFICATION_CENTER postNotificationName:kUserCarsDataLoadSuccess object:nil];
                }
            }];
        }
        else
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.navigationController.view animated:YES];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"车辆删除失败，请重试！" delay:0.5f];
    }];
}

#pragma mark - Text Field Delegate Methods
#define kMaxLength 6
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 限制用户输入长度，以免数据越界
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ((toBeString.length > kMaxLength) && (range.length != 1))
    {
        textField.text = [toBeString substringToIndex:kMaxLength];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 输入结束，更新模型数据
    _car.run_distance = textField.text;
}

#pragma mark - SCDatePickerView Delegate Methods
- (void)datePickerSelectedFinish:(NSDate *)date mode:(UIDatePickerMode)mode
{
    // 时间选择器时间选择完毕
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *dateString = [formatter stringFromDate:date];
    _buyCarDateLabel.text = dateString;
    
    [formatter setDateFormat:@"yyyy"];
    _car.buy_car_year = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MM"];
    _car.buy_car_month = [NSString stringWithFormat:@"%@", @([[formatter stringFromDate:date] integerValue])];
}

#pragma mark - SCCarDriveHabitsView Delegate Methods
- (void)didSaveWithHabitsType:(SCHabitsType)type
{
    if (!_mileageTextField.text.length)
    {
        [self showHUDAlertToViewController:self tag:SCHUDTypeDefault text:@"请完善里程数" delay:0.5f];
    }
    else if (!_buyCarDateLabel.text.length)
    {
        [self showHUDAlertToViewController:self tag:SCHUDTypeDefault text:@"请完善车辆登记日期" delay:0.5f];
    }
    else
    {
        // 保存按钮被点击，刷新[驾驶习惯]数据，并开始保存请求
        _car.habit = [@(type) stringValue];
        
        [self startUpdateUserCarRequest];
    }
}

#pragma mark - MBProgressHUD Delegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    switch (hud.tag)
    {
        case SCHUDTypeSaveData:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(dataSaveSuccess)])
                [_delegate dataSaveSuccess];
            // 保存成功，返回上一页
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case SCHUDTypeDeleteCar:
        {
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
        [self startDeleteUserCarRequest];
}

@end
