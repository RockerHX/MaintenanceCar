//
//  SCCarModelView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarModelView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCAPIRequest.h"
#import "SCCarBrand.h"
#import "SCCarModel.h"
#import "SCCar.h"

typedef NS_ENUM(NSInteger, SCTableViewType) {
    SCTableViewTypeCarModel = 900,
    SCTableViewTypeCar,
};

@interface SCCarModelView ()
{
    NSMutableArray *_cars;
    NSMutableArray *_carModels;
}

@end

@implementation SCCarModelView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Action Methods
- (void)titleColumnTaped
{
    if (self.canSelected)
    {
        [_delegate carModelViewTitleTaped];
    }
}

#pragma mark - Public Methods
- (void)showWithCarBrand:(SCCarBrand *)carBrand
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [self startCarModelReuqest:carBrand];
}
#pragma mark - Private Methods
- (void)initConfig
{
    _cars               = [@[] mutableCopy];
    _carModels          = [@[] mutableCopy];
    _leftTableView.tag  = SCTableViewTypeCarModel;
    _rightTableView.tag = SCTableViewTypeCar;
    [self.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleColumnTaped)]];
}

- (void)viewConfig
{
    _leftTableView.tableFooterView = [[UIView alloc] init];
    _rightTableView.tableFooterView = [[UIView alloc] init];
}

- (void)clearAllCache
{
    [self clearCarsCache];
    
    [_carModels removeAllObjects];
    [_leftTableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

- (void)clearCarsCache
{
    [_cars removeAllObjects];
    [_rightTableView reloadData];
}

- (void)loadCarModelsLocalData
{
    SCCarModel *carModel = [[SCCarModel alloc] init];
    if (carModel.localData.count)
    {
        [_carModels arrayByAddingObject:carModel.localData];
        [_leftTableView reloadData];
    }
    else
    {
        ShowPromptHUDWithText(self, @"数据获取失败，请重新获取！", 1.0f);
    }
}

- (void)loadCarsLocalData
{
    SCCar *car = [[SCCar alloc] init];
    if (!car.localData.count)
    {
        [_carModels arrayByAddingObject:car.localData];
        [_rightTableView reloadData];
    }
    else
    {
        ShowPromptHUDWithText(self, @"数据获取失败，请重新获取！", 1.0f);
    }
}

- (void)startCarModelReuqest:(SCCarBrand *)carBrand
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"brand": carBrand.brand_id};
    [[SCAPIRequest manager] startUpdateCarModelAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess) {
            if (((NSArray *)responseObject).count)
            {
                for (NSDictionary *data in responseObject)
                {
                    SCCarModel *carModel = [[SCCarModel alloc] initWithDictionary:data error:nil];
                    [carModel save];
                    [_carModels addObject:carModel];
                }
                [_leftTableView reloadData];
            }
            else
                ShowPromptHUDWithText(weakSelf, @"暂无数据，有待添加！", 1.0f);
        }
        else
            [weakSelf loadCarModelsLocalData];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf loadCarModelsLocalData];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    }];
}

- (void)startCarsRequest:(SCCarModel *)carModel
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"model": carModel.model_id};
    [[SCAPIRequest manager] startUpdateCarsAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess) {
            for (NSDictionary *data in responseObject)
            {
                SCCar *car = [[SCCar alloc] initWithDictionary:data error:nil];
                [car save];
                [_cars addObject:car];
            }
            [_rightTableView reloadData];
        }
        else
            [weakSelf loadCarsLocalData];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf loadCarsLocalData];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    }];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == SCTableViewTypeCarModel)
        return _carModels.count;
    else
        return _cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCarCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    if (tableView.tag == SCTableViewTypeCarModel)
    {
        SCCarModel *carModel = _carModels[indexPath.row];
        cell.textLabel.text = carModel.model_name;
    }
    else
    {
        SCCar *car = _cars[indexPath.row];
        cell.textLabel.text = car.car_full_model;
        cell.detailTextLabel.text = car.up_time;
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == SCTableViewTypeCarModel)
    {
        [self clearCarsCache];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        SCCarModel *carModel = _carModels[indexPath.row];
        [self startCarsRequest:carModel];
    }
    else
    {
        
    }
}

@end
