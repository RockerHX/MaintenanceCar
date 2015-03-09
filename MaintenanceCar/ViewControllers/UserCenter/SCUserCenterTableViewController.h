//
//  SCUserCenterTableViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"
#import "MJRefresh.h"

// 刷新操作的请求类型
typedef NS_ENUM(NSInteger, SCFavoriteListRequestType) {
    SCFavoriteListRequestTypeUp = 1000,
    SCFavoriteListRequestTypeDown
};

@interface SCUserCenterTableViewController : UITableViewController
{
    id                        _deleteDataCache;     // 删除数据的缓存
    NSMutableArray            *_dataList;           // 列表数据缓存
}

@property (nonatomic, assign)                      BOOL showTrashItem;
@property (nonatomic, assign)                 NSInteger offset;         // 商家列表请求偏移量，用户上拉刷新的分页请求操作
@property (nonatomic, assign) SCFavoriteListRequestType requestType;    // 请求类型，是上拉刷新还是下拉刷新

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
- (void)startDownRefreshReuqest;

/**
 *  上拉刷新
 */
- (void)startUpRefreshRequest;

/**
 *  显示HUD
 *
 *  @param view 需要显示HUD的View
 */
- (void)showHUDToView:(UIView *)view;

/**
 *  隐藏HUD
 */
- (void)hiddenHUD;

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
