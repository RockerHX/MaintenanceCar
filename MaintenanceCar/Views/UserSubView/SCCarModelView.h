//
//  SCCarModelView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSelectedView.h"

@class SCCar;
@class SCCarBrand;

@protocol SCCarModelViewDelegate <NSObject>

@optional
// SCCarModelView标题栏被点击，以便通知代理对象是否选择关闭此View
- (void)carModelViewTitleTaped;
// 车辆型号被选中，通知代理对象经行相关数据操作
- (void)carModelViewDidSelectedCar:(SCCar *)car;

@end

@interface SCCarModelView : SCSelectedView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView      *titleView;                        // 展示给用户的标题View，用户点击此栏会触发显示货关闭当前View事件
@property (weak, nonatomic) IBOutlet UILabel     *carModelLabel;                    // 车辆车型选择显示栏，用户选择车辆型号后名称显示在此栏
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;                    // 车辆车型数据显示列表
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;                   // 车辆型号数据显示列表

@property (nonatomic, weak)          id          <SCCarModelViewDelegate>delegate;

/**
 *  通过车辆品牌数据显示车辆车型View
 *
 *  @param carBrand 车辆品牌数据
 */
- (void)showWithCarBrand:(SCCarBrand *)carBrand;

/**
 *  清除数据缓存，以免用户造成数据错觉
 */
- (void)clearAllCache;

@end
