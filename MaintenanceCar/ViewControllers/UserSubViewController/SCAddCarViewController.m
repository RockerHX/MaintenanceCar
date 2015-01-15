//
//  SCAddCarViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAddCarViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCCarBrandView.h"
#import "SCCarModelView.h"
#import "SCCollectionIndexView.h"
#import "SCCarBrandDisplayModel.h"
#import "SCCar.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"

typedef NS_ENUM(BOOL, SCAddCarStatus) {
    SCAddCarStatusSelected = YES,
    SCAddCarStatusCancel   = NO
};

typedef NS_ENUM(NSInteger, SCContentViewSwitch) {
    SCContentViewSwitchCarBrandView = 300,
    SCContentViewSwitchCarModelView
};

@interface SCAddCarViewController () <SCCarBrandViewDelegate, SCCarModelViewDelegate, MBProgressHUDDelegate>
{
    SCCar *_car;
}

@property (nonatomic, weak) IBOutlet SCCollectionIndexView *indexView;

@end

@implementation SCAddCarViewController

#pragma mark - View Controller Life Cycle
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
    _carBrandView.delegate = self;
    _carModelView.delegate = self;
    [_indexView addTarget:self action:@selector(indexWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[SCCarBrandDisplayModel share] addObserver:self forKeyPath:@"loadFinish" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewConfig
{
    BOOL loadFinish = [SCCarBrandDisplayModel share].loadFinish;
    if (!loadFinish)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else
    {
        [self loadData];
    }
}

- (void)loadData
{
    SCCarBrandDisplayModel *model = [SCCarBrandDisplayModel share];
    _carBrandView.indexTitles = model.indexTitles;
    _carBrandView.carBrands   = model.displayData;
    [_carBrandView refresh];
    
    _indexView.indexTitles    = model.indexTitles;
}

- (void)indexWasTapped:(SCCollectionIndexView *)indexView
{
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
    if (status)
        [self showAlert:_car];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchContentView:(SCContentViewSwitch)swtichView
{
    switch (swtichView)
    {
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

- (void)showAlert:(SCCar *)car
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您选中的是%@ %@", car.car_full_model, car.up_time]
                                                        message:@"您确认添加吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"添加", nil];
    [alertView show];
}

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
    [self switchContentView:SCContentViewSwitchCarBrandView];
}

- (void)carBrandViewDidSelectedCar:(SCCarBrand *)carBrand
{
    [self switchContentView:SCContentViewSwitchCarModelView];
    [_carModelView showWithCarBrand:carBrand];
}

#pragma mark - SCCarModelView Delegate Methods
- (void)carModelViewTitleTaped
{
}

- (void)carModelViewDidSelectedCar:(SCCar *)car
{
    _car = car;
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startAddCarRequest];
    }
}

#pragma mark - MBProgressHUDDelegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
