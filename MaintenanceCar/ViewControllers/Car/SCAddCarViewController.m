//
//  SCAddCarViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAddCarViewController.h"
#import "SCCarBrandView.h"
#import "SCCarModelView.h"
#import "SCCollectionIndexView.h"
#import "SCCarBrandDisplayModel.h"

// 添加车辆返回操作类型
typedef NS_ENUM(BOOL, SCAddCarStatus) {
    SCAddCarStatusSelected = YES,
    SCAddCarStatusCancel   = NO
};

// View切换类型
typedef NS_ENUM(NSInteger, SCContentViewSwitch) {
    SCContentViewSwitchCarBrandView = 300,
    SCContentViewSwitchCarModelView
};

@interface SCAddCarViewController () <SCCarBrandViewDelegate, SCCarModelViewDelegate>
{
    SCCar *_car;        // 车辆数据缓存
}

@property (nonatomic, weak) IBOutlet SCCollectionIndexView *indexView;

@end

@implementation SCAddCarViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 添加车辆"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 添加车辆"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 页面相关数据初始化
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance
{
    return CAR_VIEW_CONTROLLER(@"SCAddCarViewNavigationController");
}

#pragma mark - Config Methods
- (void)initConfig
{
    // 设置相关页面代理，以便回调方法触发
    _carBrandView.delegate = self;
    _carModelView.delegate = self;
    
    // 为索引控件添加相应事件
    [_indexView addTarget:self action:@selector(indexWasTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewConfig
{
    WEAK_SELF(weakSelf);
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[SCCarBrandDisplayModel share] requestCarBrands:^(NSDictionary *displayData, NSArray *indexTitles, BOOL finish) {
        if (finish)
        {
            [MBProgressHUD hideAllHUDsForView:weakSelf.navigationController.view animated:YES];
            weakSelf.indexView.indexTitles    = indexTitles;
            weakSelf.carBrandView.indexTitles = indexTitles;
            weakSelf.carBrandView.carBrands   = displayData;
            [weakSelf.carBrandView refresh];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:weakSelf.navigationController.view animated:YES];
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"数据错误，请联系修养！" delay:0.5f];
        }
    }];
}

#pragma mark - Action Methods
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissWithStatus:SCAddCarStatusCancel];
}

- (IBAction)addCarButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissWithStatus:SCAddCarStatusSelected];
}

#pragma mark - Private Methods
- (void)indexWasTapped:(SCCollectionIndexView *)indexView
{
    // 索引栏被点击触发事件，根据索引信息滚动到相关位置
    @try {
        [_carBrandView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexView.selectedIndex]
                                             atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Collection View Scroll To Item Error:%@", exception.reason);
    }
    @finally {
    }
}

- (void)dismissWithStatus:(SCAddCarStatus)status
{
    // 顶栏[添加]被点击弹出提示框，[取消]被点击这返回个人中心
    if (status)
    {
        if (!_car)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先选择具体车辆噢亲！"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
            [self showAlert:_car];
            
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchContentView:(SCContentViewSwitch)swtichView
{
    switch (swtichView)
    {
        // 切换到车辆品牌View
        case SCContentViewSwitchCarBrandView:
        {
            _carBrandView.canSelected = NO;
            [_carBrandView selected];
            _carModelView.canSelected = YES;
            [_carModelView updateArrowIcon];
            [_carModelView clearAllCache];
            
            [_indexView showWithAnimation:YES];
        }
            break;
        // 切换到车辆车型View
        case SCContentViewSwitchCarModelView:
        {
            _carModelView.canSelected = NO;
            [_carModelView selected];
            _carBrandView.canSelected = YES;
            [_carBrandView updateArrowIcon];
            
            [_indexView hiddenWithAnimation:YES];
        }
            break;
    }
}

// 添加车辆确认提示
- (void)showAlert:(SCCar *)car
{
    NSString *title;
    if (car.car_id.length)
        title = [NSString stringWithFormat:@"您选择的是%@ %@", car.car_full_model, (car.up_time ? car.up_time : @"")];
    else
        title = [NSString stringWithFormat:@"您选择的是%@ %@", car.brand_name, car.model_name];
    [self showAlertWithTitle:title message:@"您确认添加吗？" delegate:self tag:Zero cancelButtonTitle:@"取消" otherButtonTitle:@"添加"];
}

/**
 *  为用户添加车辆的数据请求，参数：user_id, car_id, model_id
 */
- (void)startAddCarRequest
{
    WEAK_SELF(weakSelf);
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                  @"car_id": _car.car_id,
                                @"model_id": _car.model_id};
    [[SCAPIRequest manager] startAddCarAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            _car.user_car_id = responseObject[@"user_car_id"];
            [NOTIFICATION_CENTER postNotificationName:kUserCarsDataNeedReloadSuccessNotification object:nil];
            if ([_delegate respondsToSelector:@selector(addCarSuccess:)])
                [_delegate addCarSuccess:_car];
            [weakSelf showPromptHUDToView:weakSelf.view withText:@"添加成功！" delay:1.0f delegate:weakSelf];
        }
        else
            [weakSelf showPromptHUDToView:weakSelf.view withText:@"添加失败，请重试！" delay:1.0f delegate:weakSelf];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showPromptHUDToView:weakSelf.view withText:@"添加失败，请重试！" delay:1.0f delegate:weakSelf];
    }];
}

/**
 *  用户提示方法
 *
 *  @param text     提示内容
 *  @param delay    提示消失时间
 *  @param delegate 代理对象
 */
- (void)showPromptHUDToView:(UIView *)view withText:(NSString *)text delay:(NSTimeInterval)delay delegate:(id)delegate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.delegate = delegate;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = SCREEN_HEIGHT/2 - 100.0f;
    hud.margin = 10.0f;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
}

#pragma mark - SCCarBrandView Delegate Methods
- (void)carBrandViewScrollEnd
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view.window addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.yOffset = SCREEN_HEIGHT/2 - 100.0f;
    hud.labelText = [_indexView selectedIndexTitle];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.5f];
}

- (void)carBrandViewTitleTaped
{
    _car = nil;
    // 车辆品牌栏被点击，切换到车辆品牌View
    [self switchContentView:SCContentViewSwitchCarBrandView];
}

- (void)carBrandViewDidSelectedCar:(SCCarBrand *)carBrand
{
    // 某车辆品牌被点击，切换到车辆车型View，并开始进行数据刷新
    [self switchContentView:SCContentViewSwitchCarModelView];
    [_carModelView showWithCarBrand:carBrand];
}

#pragma mark - SCCarModelView Delegate Methods
- (void)carModelViewTitleTaped
{
    _car = nil;
}

- (void)carModelViewDidSelectedCar:(SCCar *)car
{
    // 车辆型号被点击，添加车辆数据缓存
    _car = car;
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 当用户选择提示框的[添加]遍开始为用户添加车辆的请求
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startAddCarRequest];
    }
}

#pragma mark - MBProgressHUDDelegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // HUD提示框的回调方法，在用户请求添加车辆之后才会触发，成功之后返回到个人中心
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
