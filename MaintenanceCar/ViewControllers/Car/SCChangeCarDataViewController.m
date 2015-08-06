//
//  SCChangeCarDataViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCChangeCarDataViewController.h"
#import "SCUserCar.h"
#import "SCDatePickerView.h"
#import "SCCarDriveHabitsView.h"
#import "SCPickerView.h"
#import "SCAddCarViewController.h"

static NSString *const ChangeCarDataNavControllerID = @"ChangeCarDataNavigationController";

typedef NS_ENUM(NSInteger, SCHUDType) {
    SCHUDTypeDefault,
    SCHUDTypeSaveData,
    SCHUDTypeDeleteCar
};

@interface SCChangeCarDataViewController () <UITextFieldDelegate, SCDatePickerViewDelegate, SCCarDriveHabitsViewDelegate, SCPickerViewDelegate, SCAddCarViewControllerDelegate>
@end

@implementation SCChangeCarDataViewController

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance {
    static UINavigationController *navigationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navigationController = [SCStoryBoardManager navigaitonControllerWithIdentifier:ChangeCarDataNavControllerID
                                                                        storyBoardName:SCStoryBoardNameCar];
    });
    return navigationController;
}

+ (instancetype)instance {
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameCar];
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 数据初始化
    [self initConfig];
    [self viewConfig];
    [self viewDisplay];
}

#pragma mark - Config Methods
- (void)initConfig {
    [_userCarLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCar)]];
    [_buyCarDateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyCarDateButtonPressed)]];
}

- (void)viewConfig {
    // 配置页面元素，设置圆角
    _userCarLabel.layer.borderWidth     = 1.0f;
    _userCarLabel.layer.borderColor     = [UIColor lightGrayColor].CGColor;
    
    _mileageTextField.layer.borderWidth = 1.0f;
    _mileageTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _buyCarDateLabel.layer.borderWidth  = 1.0f;
    _buyCarDateLabel.layer.borderColor  = [UIColor lightGrayColor].CGColor;
}

#pragma mark - Setter And Getter
- (void)setCar:(SCUserCar *)car {
    _car = car;
    [self viewDisplay];
}

#pragma mark - Action
- (IBAction)menuButtonPressed {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldShowMenu)]) {
        [_delegate shouldShowMenu];
    }
}

- (IBAction)deleteCarButtonPressed {
    [self showAlertWithTitle:@"警告"
                     message:@"您确定要删除您的车辆吗？"
                    delegate:self
                         tag:Zero
           cancelButtonTitle:@"确认"
            otherButtonTitle:@"取消"];
}

- (void)changeCar {
    // 购车按钮点击事件触发，收起键盘，弹出时间选择器
    [self.view endEditing:YES];
    
    SCPickerView *pickerView = [[SCPickerView alloc] initWithItems:nil type:SCPickerTypeCar delegate:self];
    [pickerView show];
}

- (IBAction)buyCarDateButtonPressed {
    // 购车按钮点击事件触发，收起键盘，弹出时间选择器
    [self.view endEditing:YES];
    
    SCDatePickerView *datePicker = [[SCDatePickerView alloc] initWithDelegate:self mode:UIDatePickerModeDate];
    datePicker.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:ZERO_POINT];
    datePicker.datePicker.maximumDate = [NSDate date];
    [datePicker show];                                    
}

#pragma mark - Private Methods
- (void)viewDisplay {
    // 刷新页面数据
    _userCarLabel.text     = [_car.brandName stringByAppendingString:_car.modelName];
    _mileageTextField.text = _car.runDistance;
    _buyCarDateLabel.text  = ([_car.buyCarYear integerValue] && [_car.buyCarMonth integerValue]) ? [NSString stringWithFormat:@"%@年%@月", _car.buyCarYear, _car.buyCarMonth] : @"";

    _carDriveHabitsView.delegate   = self;
    _carDriveHabitsView.habitsType = (SCHabitsType)[_car.habit integerValue];
}

/**
 *  车辆数据更新请求，参数：user_id, user_car_id必选，其他可选参数见API文档
 */
- (void)startUpdateUserCarRequest {
    WEAK_SELF(weakSelf);
    [self showHUDOnViewController:self.navigationController];
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                             @"user_car_id": _car.userCarID,
                                @"model_id": _car.modelID,
                            @"buy_car_year": _car.buyCarYear,
                           @"buy_car_month": _car.buyCarMonth,
                            @"run_distance": _car.runDistance,
                                   @"habit": _car.habit};
    [[SCAPIRequest manager] startUpdateUserCarAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess) {
            [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
                if (finish) {
                    [weakSelf showHUDAlertToViewController:weakSelf tag:SCHUDTypeSaveData text:@"保存成功！" delay:0.5f];
                }
            }];
        } else {
            [weakSelf hideHUDOnViewController:weakSelf.navigationController];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideHUDOnViewController:weakSelf.navigationController];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"数据保存失败，请重试！" delay:0.5f];
    }];
}

- (void)startDeleteUserCarRequest {
    WEAK_SELF(weakSelf);
    [self showHUDOnViewController:self.navigationController];
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                             @"user_car_id": _car.userCarID};
    [[SCAPIRequest manager] startDeleteCarAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess) {
            [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
                if (finish) {
                    [weakSelf showHUDAlertToViewController:weakSelf tag:SCHUDTypeDeleteCar text:@"删除成功！" delay:0.5f];
                    [NOTIFICATION_CENTER postNotificationName:kUserCarsDataNeedReloadSuccessNotification object:nil];
                }
            }];
        } else {
            [weakSelf hideHUDOnViewController:weakSelf.navigationController];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideHUDOnViewController:weakSelf.navigationController];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"车辆删除失败，请重试！" delay:0.5f];
    }];
}

#pragma mark - Text Field Delegate Methods
#define kMaxLength 6
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 限制用户输入长度，以免数据越界
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ((toBeString.length > kMaxLength) && (range.length != 1)) {
        textField.text = [toBeString substringToIndex:kMaxLength];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 输入结束，更新模型数据
    _car.runDistance = textField.text;
}

#pragma mark - SCDatePickerView Delegate Methods
- (void)datePickerSelectedFinish:(NSDate *)date mode:(UIDatePickerMode)mode {
    // 时间选择器时间选择完毕
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *dateString = [formatter stringFromDate:date];
    _buyCarDateLabel.text = dateString;
    
    [formatter setDateFormat:@"yyyy"];
    _car.buyCarYear = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MM"];
    _car.buyCarMonth = [NSString stringWithFormat:@"%@", @([[formatter stringFromDate:date] integerValue])];
}

#pragma mark - SCCarDriveHabitsView Delegate Methods
- (void)didSaveWithHabitsType:(SCHabitsType)type {
    if (!_mileageTextField.text.length) {
        [self showHUDAlertToViewController:self tag:SCHUDTypeDefault text:@"请完善里程数" delay:0.5f];
    } else if (!_buyCarDateLabel.text.length) {
        [self showHUDAlertToViewController:self tag:SCHUDTypeDefault text:@"请完善车辆登记日期" delay:0.5f];
    } else {
        // 保存按钮被点击，刷新[驾驶习惯]数据，并开始保存请求
        _car.habit = [@(type) stringValue];
        [self startUpdateUserCarRequest];
    }
}

#pragma mark - MBProgressHUD Delegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    switch (hud.tag) {
        case SCHUDTypeSaveData: {
            if (_delegate && [_delegate respondsToSelector:@selector(userCarDataSaveSuccess:)]) {
                [_delegate userCarDataSaveSuccess:self.navigationController];
            }
            break;
        }
        case SCHUDTypeDeleteCar: {
            if (_delegate && [_delegate respondsToSelector:@selector(userCarDataDeleteSuccess:)]) {
                [_delegate userCarDataDeleteSuccess:self.navigationController];
            }
            break;
        }
    }
    [self hideHUDOnViewController:self.navigationController];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self startDeleteUserCarRequest];
    }
}

#pragma mark - SCPickerView Delegate Methods
- (void)pickerView:(SCPickerView *)pickerView didSelectRow:(NSInteger)row item:(id)item {
    if ([pickerView lastItem:item]) {
        if ([SCUserInfo share].loginState) {
            UINavigationController *addCarViewNavigationControler = [SCAddCarViewController navigationInstance];
            SCAddCarViewController *addCarViewController = (SCAddCarViewController *)addCarViewNavigationControler.topViewController;
            addCarViewController.delegate = self;
            [self presentViewController:addCarViewNavigationControler animated:YES completion:nil];
            [pickerView hidde];
        } else {
            [self showShoulLoginAlert];
        }
    } else {
        SCUserCar *car = item;
        _car = car;
    }
    [self viewDisplay];
}

#pragma mark - SCAddCarViewController Delegate Methods
- (void)addCarSuccess:(SCCar *)car {
    _car = [[SCUserCar alloc] initWithCar:car];
    [self viewDisplay];
}

@end
