//
//  SCReservationDateViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCReservationDateViewController.h"
#import "SCDateCell.h"
#import "SCSelectedCell.h"

typedef NS_ENUM(NSInteger, SCCollectionViewType){
    SCCollectionViewTypeData,
    SCCollectionViewTypeSelected
};

@interface SCReservationDateViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
{
    NSDictionary *_dateItmes;
    NSArray      *_dateKeys;
    
    NSString     *_requestDate;
    NSString     *_displayDate;
}

@end

@implementation SCReservationDateViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[预约] - [预约时间]"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[预约] - [预约时间]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initConfig
{
    _dateCollectionView.layer.borderWidth     = 1.0f;
    _dateCollectionView.layer.borderColor     = [UIColor grayColor].CGColor;
    
    _dateCollectionView.tag     = SCCollectionViewTypeData;
    
    _selectedCollectionView.tag = SCCollectionViewTypeSelected;
}

- (void)viewConfig
{
    CGFloat promptFontSize = DOT_COORDINATE;
    CGFloat subPromptFontSize = DOT_COORDINATE;
    if (IS_IPHONE_6Plus)
    {
        promptFontSize = 20.0f;
        subPromptFontSize = promptFontSize;
    }
    else if (IS_IPHONE_6)
    {
        promptFontSize = 20.0f;
        subPromptFontSize = 18.0f;
    }
    else
    {
        promptFontSize = 18.0f;
        subPromptFontSize = 15.0f;
    }
    _promptTitleLabel.font    = [UIFont systemFontOfSize:promptFontSize];
    _subPromptTitleLabel.font = [UIFont systemFontOfSize:subPromptFontSize];
    
    [self startReservationItemsRequest];
}

- (void)startReservationItemsRequest
{
    [self showHUDOnViewController:self];
    
    __weak typeof(self)weakSelf = self;
    NSDictionary *parameters = @{@"company_id": _companyID,
                                       @"type": _type};
    [[SCAPIRequest manager] startGetReservationItemNumAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:self];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            _dateItmes = responseObject;
            _dateKeys  = [[_dateItmes allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            
            [_dateCollectionView reloadData];
            [_selectedCollectionView reloadData];
        }
        else
            [weakSelf showHUDAlertToViewController:weakSelf tag:Zero text:NetWorkError delay:0.5f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeDataError)
            [weakSelf showHUDAlertToViewController:weakSelf tag:Zero text:DataError delay:0.5f];
        else
            [weakSelf showHUDAlertToViewController:weakSelf tag:Zero text:NetWorkError delay:0.5f];
    }];
}

- (CGFloat)itemWidthWithInde:(NSInteger)index
{
    CGFloat itemWidth = DOT_COORDINATE;
    if (index)
    {
        if (IS_IPHONE_6Plus)
            itemWidth = 54.0f;
        else if (IS_IPHONE_6)
            itemWidth = 48.5f;
        else
            itemWidth = 41.0f;
    }
    else
    {
        if (IS_IPHONE_6Plus)
            itemWidth = 38.0f;
        else if (IS_IPHONE_6)
            itemWidth = 37.5f;
        else
            itemWidth = 35.0f;
    }
    return itemWidth;
}

- (NSNumber *)getContentWithDiction:(NSDictionary *)dictionary index:(NSInteger)index
{
    if (dictionary)
    {
        // 升序处理
        NSArray *keys = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        NSString *key = keys[index];
        NSNumber *text = [dictionary objectForKey:key];
        return text;
    }
    return @(0);
}

- (NSString *)getTime:(NSIndexPath *)indexPath
{
    NSArray *times = [[_dateItmes[_dateKeys[indexPath.row - 1]] allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *time = times[indexPath.section];
    return time;
}

- (BOOL)itemCanSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        NSString *time = [self getTime:indexPath];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSDate *reservationDate = [dateFormatter dateFromString:time];
        [dateFormatter setDateFormat:@"HH"];
        NSDate *now = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
        
        NSComparisonResult result = [now compare:reservationDate];
        return (result == NSOrderedDescending) ? NO : YES;
    }
    else if (indexPath.row > 1)
        return YES;
    return NO;
}

- (NSString *)getPeriodWithDate:(NSString *)date time:(NSString *)time
{
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", date, time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromDate = [formatter dateFromString:dateString];
    NSDate *toDate = [NSDate dateWithTimeInterval:60*60 sinceDate:fromDate];
    
    [formatter setDateFormat:@"HH:mm"];
    NSString *fromTime = [formatter stringFromDate:fromDate];
    NSString *toTime = [formatter stringFromDate:toDate];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    dateString = [formatter stringFromDate:fromDate];
    
    NSString *showDate = [NSString stringWithFormat:@"%@ %@-%@", dateString, fromTime, toTime];
    
    return showDate;
}

#pragma mark - Collection View Data Source Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (collectionView.tag == SCCollectionViewTypeSelected) ? [_dateItmes[[[_dateItmes allKeys] firstObject]] allKeys].count : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (collectionView.tag == SCCollectionViewTypeData)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCDateCell" forIndexPath:indexPath];
        SCDateCell *dateCell = (SCDateCell *)cell;
        if (indexPath.row)
        {
            [dateCell diplayWithDate:_dateKeys[indexPath.row - 1]
                            constant:[self itemWidthWithInde:indexPath.row]];
        }
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCSelectedCell" forIndexPath:indexPath];
        SCSelectedCell *selectedCell = (SCSelectedCell *)cell;
        selectedCell.showTopLine     = !indexPath.section;
        if (indexPath.row)
        {
            [selectedCell displayItemWithText:[self getContentWithDiction:_dateItmes[_dateKeys[indexPath.row - 1]]
                                                                    index:indexPath.section]
                                  canSelected:[self itemCanSelectedWithIndexPath:indexPath]
                                     constant:[self itemWidthWithInde:indexPath.row]];
        }
        else
        {
            [selectedCell displayItemWithTimes:[_dateItmes[[_dateKeys firstObject]] allKeys]
                                       section:indexPath.section
                                      constant:[self itemWidthWithInde:indexPath.row]];
        }
    }
    return cell;
}

#pragma mark - Collection View Delegate Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self itemWidthWithInde:indexPath.row], (collectionView.tag == SCCollectionViewTypeData) ? 60.0f : 50.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == SCCollectionViewTypeSelected && [self itemCanSelectedWithIndexPath:indexPath])
    {
        NSNumber *reservationNum = [self getContentWithDiction:_dateItmes[_dateKeys[indexPath.row - 1]]
                                                         index:indexPath.section];
        if ([reservationNum integerValue] > 0)
        {
            NSString *date = _dateKeys[indexPath.row - 1];
            NSString *time = [self getTime:indexPath];
            _requestDate = [NSString stringWithFormat:@"%@ %@", date, time];
            _displayDate = [self getPeriodWithDate:date time:time];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否预约"
                                                                message:[_displayDate stringByAppendingString:@"这个时间段?"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确认", nil];
            [alertView show];
        }
    }
}

#pragma mark - MBProgressHUD Delegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // 保存成功，返回上一页
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(reservationDateSelectedFinish:displayDate:)])
            [_delegate reservationDateSelectedFinish:_requestDate displayDate:_displayDate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
