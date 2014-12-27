//
//  SCMerchantViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCAPIRequest.h"
#import "SCMerchant.h"
#import "SCMerchantTableViewCell.h"
#import "SCLocationInfo.h"
#import "SCMerchantList.h"

#define MerchantCellReuseIdentifier     @"MerchantCellReuseIdentifier"

@interface SCMerchantViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *merchantList;
@property (nonatomic, assign) NSInteger      offset;

@end

@implementation SCMerchantViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[商户] - 商户列表"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[商户] - 商户列表"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self initConfig];
    [self startMerchantListRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SCMerchantList shareList].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantCellReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    SCMerchant *merchant = [SCMerchantList shareList].items[indexPath.row];
    cell.merchantNameLabel.text = merchant.detail.name;
    cell.distanceLabel.text = merchant.distance;
    
    return cell;
}

#pragma mark - Table View Delegate Methods
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods
#pragma mark -
- (void)initConfig
{
    _offset               = 0;
    _merchantList         = [@[] mutableCopy];

    _tableView.delegate   = self;
    _tableView.dataSource = self;
}

- (void)startMerchantListRequest
{
    SCLocationInfo *locationInfo = [SCLocationInfo shareLocationInfo];
    NSDictionary *parameters     = @{@"word"        : locationInfo.city,
                                     @"limit"       : @(MerchantListLimit),
                                     @"offset"      : @(_offset),
                                     @"radius"      : @(MerchantListRadius),
                                     @"longtitude"  : locationInfo.longitude,
                                     @"latitude"    : locationInfo.latitude};
    
    [[SCAPIRequest manager] startMerchantListAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SCLog(@"%@", responseObject);
        NSArray *list = [[responseObject objectForKey:@"result"] objectForKey:@"items"];
        
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error       = nil;
            SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj error:&error];
            SCError(@"weather model parse error:%@", error);
            [_merchantList addObject:merchant];
        }];
        
        [SCMerchantList shareList].items = _merchantList;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCError(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
