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

@property (nonatomic, weak) IBOutlet SCCollectionIndexView *indexView;

@end

@implementation SCAddCarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
}

- (void)viewConfig
{
    _carBrandView.canSelected = YES;
    _carModelView.canSelected = YES;
    
    [_indexView addTarget:self action:@selector(indexWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    SCCarBrandDisplayModel *model = [SCCarBrandDisplayModel share];
}

- (void)indexWasTapped:(SCCollectionIndexView *)indexView
{
    [_carBrandView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexView.selectedIndex]
                                         atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
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
