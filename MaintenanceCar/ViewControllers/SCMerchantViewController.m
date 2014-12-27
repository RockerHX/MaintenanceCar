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

@property (nonatomic, assign) NSInteger      offset;        // 商户列表请求偏移量，用户上拉刷新的分页请求操作

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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];      // 加载响应式控件
    
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
    
    // 刷新商户列表
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
/**
 *  初始化配置，列表设置，全局变量初始化都放在这里
 */
- (void)initConfig
{
    _offset               = 0;          // 第一次进入商户列表列表请求偏移量必须为0

    _tableView.delegate   = self;
    _tableView.dataSource = self;
}

/**
 *  商户列表数据请求方法
 */
- (void)startMerchantListRequest
{
    // 配置请求参数
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
        NSMutableArray *merchantList = [NSMutableArray arrayWithArray:[SCMerchantList shareList].items];
        
        // 遍历请求回来的商户数据，生成SCMerchant用于商户列表显示
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error       = nil;
            SCMerchant *merchant = [[SCMerchant alloc] initWithDictionary:obj error:&error];
            SCError(@"weather model parse error:%@", error);
            [merchantList addObject:merchant];
        }];
        
        [SCMerchantList shareList].items = merchantList;            // 商户列表数据全局设置，方便不同页面经行筛选，搜索，读取商户数据等操作
        [MBProgressHUD hideHUDForView:self.view animated:YES];      // 请求完成，移除响应式控件
        [_tableView reloadData];                                    // 数据配置完成，刷新商户列表
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCError(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
