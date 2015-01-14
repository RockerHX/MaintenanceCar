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

typedef NS_ENUM(BOOL, SCAddCarStatus) {
    SCAddCarStatusSelected = YES,
    SCAddCarStatusCancel   = NO
};

@interface SCAddCarViewController () <SCCarBrandViewDelegate>

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
    {
        
    }
    else
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
