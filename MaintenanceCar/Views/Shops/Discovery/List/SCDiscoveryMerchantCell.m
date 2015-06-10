//
//  SCDiscoveryMerchantCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDiscoveryMerchantCell.h"
#import "VersionConstants.h"
#import "SCStarView.h"
#import "SCDiscoveryMerchantServiceCell.h"
#import <Masonry/Masonry.h>

@implementation SCDiscoveryMerchantCell

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

#pragma mark - Private Methods
- (void)narrowLabel:(UILabel *)label how:(CGFloat)how
{
    label.font = [label.font fontWithSize:(label.font.pointSize - how)];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCDiscoveryMerchantServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDiscoveryMerchantServiceCell" forIndexPath:indexPath];
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
