//
//  SCListViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import <MJRefresh/MJRefresh.h>

@interface SCListViewController : UITableViewController
{
    id              _deleteDataCache;    // 删除数据的缓存
    NSMutableArray *_dataList;           // 列表数据缓存
}

@property (nonatomic, assign)                 BOOL showTrashItem;
@property (nonatomic, assign)            NSInteger offset;         // 商家列表请求偏移量，用户上拉刷新的分页请求操作
@property (nonatomic, assign) SCRequestRefreshType requestType;    // 请求类型，是上拉刷新还是下拉刷新

/**
 *  数据初始化
 */
- (void)initConfig;

/**
 *  视图配置
 */
- (void)viewConfig;

/**
 *  下拉刷新
 */
- (void)startDropDownRefreshReuqest;

/**
 *  上拉刷新
 */
- (void)startPullUpRefreshRequest;

/**
 *  结束刷新
 */
- (void)endRefresh;
- (void)addRefreshHeader;
- (void)removeRefreshHeader;
- (void)addRefreshFooter;
- (void)removeRefreshFooter;

/**
 *  清空列表缓存数据
 */
- (void)clearListData;

/**
 *  数据删除错误
 *
 *  @param index 删除错误的下标
 */
- (void)deleteFailureAtIndex:(NSInteger)index;

@end
