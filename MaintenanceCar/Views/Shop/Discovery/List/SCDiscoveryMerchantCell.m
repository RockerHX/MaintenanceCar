//
//  SCDiscoveryMerchantCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SCDiscoveryMerchantCell.h"
#import "VersionConstants.h"
#import "SCStarView.h"
#import "SCDiscoveryMerchantServiceCell.h"
#import "SCShopViewModel.h"

@implementation SCDiscoveryMerchantCell
{
    NSArray *_flags;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (IS_IPHONE_5_PRIOR)
    {
        [self narrowLabel:_starValueLabel how:2.0f];
        [self narrowLabel:_characteristicLabel how:1.0f];
        [self narrowLabel:_distanceLabel how:2.0f];
        [self narrowLabel:_repairPromptLabel how:1.0f];
        
        _starViewToStarValueLabelConstraint.constant = 2.0f;
        _starValueLabelToCharacteristicLabelConstraint.constant = 2.0f;
        _characteristicLabelToDistanceLabelConstraint.constant = 2.0f;
    }
}

#pragma mark - Draw Methods
- (void)drawRect:(CGRect)rect
{
    self.layer.shadowColor = [UIColor colorWithWhite:0.8f alpha:0.9f].CGColor;
    self.layer.shadowOffset = CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
}

#pragma mark - Private Methods
- (void)narrowLabel:(UILabel *)label how:(CGFloat)how
{
    label.font = [label.font fontWithSize:(label.font.pointSize - how)];
}

#pragma mark - Public Methods
- (void)displayCellWithShopViewModel:(SCShopViewModel *)shopViewModel
{
    [_thumbnailIcon sd_setImageWithURL:[NSURL URLWithString:shopViewModel.shop.thumbnails] placeholderImage:[UIImage imageNamed:@"MerchantIconDefault"]];
    _canPayIcon.hidden = !shopViewModel.shop.canPay;
    _mechantNameLabel.text = shopViewModel.shop.name;
    _starView.value = shopViewModel.shop.star;
    _starValueLabel.text = shopViewModel.star;
    _characteristicLabel.text = shopViewModel.shop.characteristic.title;
    _distanceLabel.text = shopViewModel.distance;
    _repairTypeIcon.image = [UIImage imageNamed:shopViewModel.repairTypeImageName];
    _repairPromptLabel.text = shopViewModel.repairPrompt;
    
    _flags = shopViewModel.flags;
    [self.flagsView reloadData];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _flags.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCDiscoveryMerchantServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDiscoveryMerchantServiceCell" forIndexPath:indexPath];
    cell.icon.image = [UIImage imageNamed:_flags[indexPath.section]];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, 1.0f, 1.0f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
