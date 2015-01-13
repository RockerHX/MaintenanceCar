//
//  SCAddCarViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAddCarViewController.h"
#import "MicroCommon.h"
#import "SCCarBrandView.h"
#import "SCCarModelView.h"
#import "SCCollectionIndexView.h"
#import "SCCarBrandDisplayModel.h"

typedef NS_ENUM(BOOL, SCAddCarStatus) {
    SCAddCarStatusSelected = YES,
    SCAddCarStatusCancel   = NO
};

@interface SCAddCarViewController ()
{
    NSArray *_indexTitles;
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

#pragma mark - Private Methods
- (void)initConfig
{
    // 获取可显示的汽车品牌数据首字母，进行升序
    _indexTitles = [[[SCCarBrandDisplayModel share].displayData allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
}

- (void)viewConfig
{
    _carBrandView.canSelected = YES;
    _carBrandView.indexTitles = _indexTitles;
    _carBrandView.carBrands = [SCCarBrandDisplayModel share].displayData;
    
    _carModelView.canSelected = YES;
    
    _indexView.indexTitles = _indexTitles;
    [_indexView addTarget:self action:@selector(indexWasTapped:) forControlEvents:UIControlEventTouchUpInside];
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

@end
