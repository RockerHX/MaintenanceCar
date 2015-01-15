//
//  SCAddCarViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAddCarViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCCarBrandView.h"
#import "SCCarModelView.h"
#import "SCCollectionIndexView.h"
#import "SCCarBrandDisplayModel.h"
#import "SCCar.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"

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

@interface SCAddCarViewController () <SCCarBrandViewDelegate, SCCarModelViewDelegate, MBProgressHUDDelegate>
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 监听车辆数据同步是否完成，再经行相关数据加载操作
    if ([keyPath isEqualToString:@"loadFinish"])
    {
        if (change[NSKeyValueChangeNewKey])
        {
            [self loadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }
}

#pragma mark - Private Methods
- (void)initConfig
{
    // 设置相关页面代理，以便回调方法触发
    _carBrandView.delegate = self;
    _carModelView.delegate = self;
    
    // 为索引控件添加相应事件
    [_indexView addTarget:self action:@selector(indexWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    // 监听车辆数据同步模型是否加载完成
    [[SCCarBrandDisplayModel share] addObserver:self forKeyPath:@"loadFinish" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewConfig
{
    BOOL loadFinish = [SCCarBrandDisplayModel share].loadFinish;
    if (!loadFinish)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    else
        [self loadData];
}

- (void)loadData
{
    // 加载车辆品牌数据，以及索引数据
    SCCarBrandDisplayModel *model = [SCCarBrandDisplayModel share];
    _carBrandView.indexTitles     = model.indexTitles;
    _carBrandView.carBrands       = model.displayData;
    [_carBrandView refresh];

    _indexView.indexTitles        = model.indexTitles;
}

- (void)indexWasTapped:(SCCollectionIndexView *)indexView
{
    // 索引栏被点击触发事件，根据索引信息滚动到相关位置
    @try {
        [_carBrandView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexView.selectedIndex]
                                             atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
    @catch (NSException *exception) {
        SCException(@"Collection View Scroll To Item Error:%@", exception.reason);
    }
    @finally {
    }
}

- (void)dismissWithStatus:(SCAddCarStatus)status
{
    // 顶栏[添加]被点击弹出提示框，[取消]被点击这返回个人中心
    if (status)
        [self showAlert:_car];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您选中的是%@ %@", car.car_full_model, car.up_time]
                                                        message:@"您确认添加吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"添加", nil];
    [alertView show];
}

/**
 *  为用户添加车辆的数据请求，参数：user_id, car_id, model_id
 */
- (void)startAddCarRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                  @"car_id": _car.car_id,
                                @"model_id": _car.model_id};
    [[SCAPIRequest manager] startAddCarAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            [[SCUserInfo share] updateCarIDs:@[responseObject[@"user_car_id"]]];
            [_delegate addCarSuccessWith:responseObject[@"user_car_id"]];
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
