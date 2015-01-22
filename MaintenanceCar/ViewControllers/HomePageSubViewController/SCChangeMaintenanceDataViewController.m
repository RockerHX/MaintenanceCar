//
//  SCChangeMaintenanceDataViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCChangeMaintenanceDataViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCUserInfo.h"
#import "SCUerCar.h"
#import "SCDatePickerView.h"
#import "SCCarDriveHabitsView.h"
#import "SCAPIRequest.h"

@interface SCChangeMaintenanceDataViewController () <UITextFieldDelegate, SCDatePickerViewDelegate, SCCarDriveHabitsViewDelegate, MBProgressHUDDelegate>

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
- (IBAction)buyCarDateButtonPressed:(UIButton *)sender
{
    // 购车按钮点击事件触发，收起键盘，弹出时间选择器
    [self.view endEditing:YES];
    
    SCDatePickerView *datePicker = [[SCDatePickerView alloc] initWithDelegate:self mode:UIDatePickerModeDate];
    datePicker.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:DOT_COORDINATE];
    [datePicker show];
}

#pragma mark - Private Methods
- (void)initConfig
{
    // 初始化的时候加入单击手势，用于页面点击收起数字键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
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
    SCUerCar *userCar              = [SCUserInfo share].currentCar;
    _userCarLabel.text             = userCar.model_name;
    _mileageTextField.text         = userCar.run_distance;
    _buyCarDateLabel.text          = ([userCar.buy_car_year integerValue] && [userCar.buy_car_month integerValue]) ? [NSString stringWithFormat:@"%@年%@月", userCar.buy_car_year, userCar.buy_car_month] : @"";

    _carDriveHabitsView.delegate   = self;
    _carDriveHabitsView.habitsType = (SCHabitsType)[userCar.habit integerValue];
}

/**
 *  页面单击手势事件
 */
- (void)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

/**
 *  用户提示方法
 *
 *  @param text     提示内容
 *  @param delay    提示消失时间
 *  @param delegate 代理对象
 */
- (void)showPromptHUDWithText:(NSString *)text delay:(NSTimeInterval)delay delegate:(id)delegate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = delegate;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = (SCREEN_HEIGHT/2 - 100.0f);
    hud.margin = 10.0f;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
}

/**
 *  车辆数据更新请求，参数：user_id, user_car_id必选，其他可选参数见API文档
 */
- (void)startUpdateUserCarRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SCUerCar *userCar        = [SCUserInfo share].currentCar;
    NSDictionary *parameters =               @{@"user_id": [SCUserInfo share].userID,
                                           @"user_car_id": userCar.user_car_id,
                                              @"model_id": userCar.model_id,
                                          @"buy_car_year": userCar.buy_car_year,
                                         @"buy_car_month": userCar.buy_car_month,
                                          @"run_distance": userCar.run_distance,
                                                 @"habit": userCar.habit};
    
    __weak typeof(self) weakSelf = self;
    [[SCAPIRequest manager] startUpdateUserCarAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSLog(@"%@", responseObject);
            [[SCUserInfo share] userCarsReuqest:^(BOOL finish) {
                if (finish)
                    [weakSelf showPromptHUDWithText:@"保存成功！" delay:0.5f delegate:weakSelf];
            }];
        }
        else
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - Text Field Delegate Methods
#define kMaxLength 6
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 限制用户输入长度，以免数据越界
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > kMaxLength && range.length!=1)
    {
        textField.text = [toBeString substringToIndex:kMaxLength];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 输入结束，更新模型数据
    SCUerCar *userCar = [SCUserInfo share].currentCar;
    userCar.run_distance = textField.text;
}

#pragma mark - SCDatePickerView Delegate Methods
- (void)datePickerSelectedFinish:(NSDate *)date mode:(UIDatePickerMode)mode
{
    // 时间选择器时间选择完毕
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *dateString = [formatter stringFromDate:date];
    _buyCarDateLabel.text = dateString;
    
    SCUerCar *userCar = [SCUserInfo share].currentCar;
    [formatter setDateFormat:@"yyyy"];
    userCar.buy_car_year = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MM"];
    userCar.buy_car_month = [NSString stringWithFormat:@"%@", @([[formatter stringFromDate:date] integerValue])];
}

#pragma mark - SCCarDriveHabitsView Delegate Methods
- (void)didSaveWithHabitsType:(SCHabitsType)type
{
    if (!_mileageTextField.text.length)
    {
        [self showPromptHUDWithText:@"请完善里程数" delay:0.5f delegate:nil];
    }
    else if (!_buyCarDateLabel.text.length)
    {
        [self showPromptHUDWithText:@"请完善购车时间" delay:0.5f delegate:nil];
    }
    else
    {
        // 保存按钮被点击，刷新[驾驶习惯]数据，并开始保存请求
        SCUerCar *userCar = [SCUserInfo share].currentCar;
        userCar.habit = [NSString stringWithFormat:@"%@", @(type)];
        
        [self startUpdateUserCarRequest];
    }
}

#pragma mark - MBProgressHUD Delegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_delegate dataSaveSuccess];
    // 保存成功，返回上一页
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
