//
//  SCMerchantDetailViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailViewController.h"
#import "SCMerchantViewController.h"
#import "SCMerchant.h"
#import "SCMerchantTableViewCell.h"
#import "SCMerchantPurchaseTableViewCell.h"
#import "SCMerchantDetialInfoTableViewCell.h"

typedef NS_ENUM(NSInteger, SCMerchantDetailCellSection) {
    SCMerchantDetailCellSectionMerchantBaseInfo = 0,
    SCMerchantDetailCellSectionPurchaseInfo,
    SCMerchantDetailCellSectionMerchantInfo
};
typedef NS_ENUM(NSInteger, SCMerchantDetailCellRow) {
    SCMerchantDetailCellRowAddress = 0,
    SCMerchantDetailCellRowPhone,
    SCMerchantDetailCellRowBusiness,
    SCMerchantDetailCellRowIntroduce
};

@interface SCMerchantDetailViewController ()

@end

@implementation SCMerchantDetailViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self displayMerchantDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark -
- (void)initConfig
{
    _merchantInfo = ((SCMerchantViewController *)self.navigationController.viewControllers[0]).merchantInfo;
    
    // 开启cell高度预估，自动适配cell高度
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)displayMerchantDetail
{
}

#pragma mark - Table View Data Source Methods
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case SCMerchantDetailCellSectionMerchantBaseInfo:
            return 1;
            break;
        case SCMerchantDetailCellSectionPurchaseInfo:
            return 1;
            break;
        case SCMerchantDetailCellSectionMerchantInfo:
            return 4;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantCellReuseIdentifier"];
    switch (indexPath.section)
    {
        case SCMerchantDetailCellSectionMerchantBaseInfo:
        {
            SCMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantCellReuseIdentifier"];
            cell.merchantNameLabel.text = _merchantInfo.detail.name;
            cell.distanceLabel.text = _merchantInfo.distance;
            return cell;
        }
            break;
        case SCMerchantDetailCellSectionPurchaseInfo:
        {
            SCMerchantPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantPurchaseTableViewCell"];
            return cell;
        }
            break;
        case SCMerchantDetailCellSectionMerchantInfo:
        {
            switch (indexPath.row)
            {
                case SCMerchantDetailCellRowAddress:
                {
                    SCMerchantDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetialInfoTableViewCellAddress"];
                    cell.contentLabel.text = _merchantInfo.detail.address;
                    return cell;
                }
                    break;
                case SCMerchantDetailCellRowPhone:
                {
                    SCMerchantDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetialInfoTableViewCellPhone"];
                    cell.contentLabel.text = _merchantInfo.detail.telephone;
                    return cell;
                }
                    break;
                case SCMerchantDetailCellRowBusiness:
                {
                    SCMerchantDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetialInfoTableViewCellBusiness"];
                    cell.contentLabel.text = _merchantInfo.detail.zige;
                    return cell;
                }
                    break;
                case SCMerchantDetailCellRowIntroduce:
                {
                    SCMerchantDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCMerchantDetialInfoTableViewCellIntroduce"];
                    return cell;
                }
                    break;
                    
                default:
                    return cell;
                    break;
            }
        }
            break;
            
        default:
            return cell;
            break;
    }
}

@end
