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

// 列表类型，区分以便分别刷新列表数据
typedef NS_ENUM(NSInteger, SCTableViewType) {
    SCTableViewTypeCarModel = 900,
    SCTableViewTypeCar,
};

@interface SCCarModelView ()
{
    NSMutableArray *_cars;                  // 车辆数据Cache
    NSMutableArray *_carModels;             // 车辆车型数据Cache
    
    UIImageView    *_selectedColorView;     // 车辆车型列表选中背景
}

@end

@implementation SCCarModelView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 相关数据初始化
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Action Methods
- (void)titleColumnTaped
{
    if (self.canSelected && _delegate && [_delegate respondsToSelector:@selector(carModelViewTitleTaped)])
        [_delegate carModelViewTitleTaped];
}

#pragma mark - Public Methods
- (void)showWithCarBrand:(SCCarBrand *)carBrand
{
    // 加载响应式控件，进行车辆车型数据请求
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [self startCarModelReuqest:carBrand];
}

#pragma mark - Private Methods
- (void)initConfig
{
    // Cache初始化以及列表数据设置
    _cars               = [@[] mutableCopy];
    _carModels          = [@[] mutableCopy];
    _leftTableView.tag  = SCTableViewTypeCarModel;
    _rightTableView.tag = SCTableViewTypeCar;
}

- (void)viewConfig
{
    // 为两个列表这是空白View，以便无数据是给用户造成视觉冲突
    _leftTableView.tableFooterView = [[UIView alloc] init];
    _rightTableView.tableFooterView = [[UIView alloc] init];
    
    // 设置选中背景
    _selectedColorView = [[UIImageView alloc] init];
    _selectedColorView.image = [UIImage imageNamed:@"CellSelectedBgView"];
}

/**
 *  清理当前页面自定义数据缓存，并因此响应式控件
 */
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

- (void)startCarModelReuqest:(SCCarBrand *)carBrand
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"brand_id": carBrand.brand_id,
                                @"time_flag": @"0"};
    [[SCAPIRequest manager] startUpdateCarModelAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSArray *models = responseObject[@"data"];
            for (NSDictionary *carData in models)
            {
                SCCarModel *carModel = [[SCCarModel alloc] initWithDictionary:carData error:nil];
                [_carModels addObject:carModel];
            }
            [_leftTableView reloadData];
        }
        else
            [weakSelf showHUDAlertWithText:@"暂无数据，有待添加！" delay:0.5f];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showHUDAlertWithText:@"网络卡爆了，去楼顶试试吧，亲！" delay:0.5f];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    }];
}

- (void)startCarsRequest:(SCCarModel *)carModel
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"model_id": carModel.model_id,
                                 @"time_flag": @"0"};
    [[SCAPIRequest manager] startUpdateCarsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSDictionary *defaultCarData = @{@"car_id": @"", @"model_id": carModel.model_id, @"up_time": @"", @"car_full_model": @"我不清楚/其他"};
            SCCar *defaultCar = [[SCCar alloc] initWithDictionary:defaultCarData error:nil];
            [_cars addObject:defaultCar];
            
            NSArray *cars = responseObject[@"data"];
            for (NSDictionary *carData in cars)
            {
                SCCar *car = [[SCCar alloc] initWithDictionary:carData error:nil];
                [_cars addObject:car];
            }
            [_rightTableView reloadData];
        }
        else
            [weakSelf showHUDAlertWithText:@"暂无数据，有待添加！" delay:0.5f];
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showHUDAlertWithText:@"网络卡爆了，去楼顶试试吧，亲！" delay:0.5f];
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
        cell.selectedBackgroundView = _selectedColorView;
        SCCarModel *carModel = _carModels[indexPath.row];
        cell.textLabel.text = carModel.model_name;
    }
    else
    {
        cell.backgroundColor = UIColorWithRGBA(240.0f, 240.0f, 240.0f, 1.0f);
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
        // 车辆车型被选择之后清除车辆型号列表数据，并重新请求及刷新
        [self clearCarsCache];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        SCCarModel *carModel = _carModels[indexPath.row];
        [self startCarsRequest:carModel];
        
        if (_delegate && [_delegate respondsToSelector:@selector(carModelViewDidSelectedCar:)])
            [_delegate carModelViewDidSelectedCar:nil];
    }
    else
    {
        // 车辆型号被选择之后清返回给主控制器，用于用户添加车辆请求的数据
        SCCar *car = _cars[indexPath.row];
        _carModelLabel.text = car.car_full_model;
        
        if (_delegate && [_delegate respondsToSelector:@selector(carModelViewDidSelectedCar:)])
            [_delegate carModelViewDidSelectedCar:car];
    }
}

@end
