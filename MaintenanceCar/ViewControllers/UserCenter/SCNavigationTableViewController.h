//
//  SCNavigationTableViewController.h
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import <MJRefresh/MJRefresh.h>
#import "SCNavigationTab.h"

typedef NS_ENUM(NSInteger, SCRequestRefreshType) {
    SCRequestRefreshTypeDropDown,
    SCRequestRefreshTypePullUp
};

@interface SCNavigationTableViewController : UIViewController <SCNavigationTabDelegate>
{
    id              _deleteDataCache;    // 删除数据的缓存
    NSMutableArray *_dataList;           // 列表数据缓存
}

@property (weak, nonatomic) IBOutlet SCNavigationTab *navigationTab;
@property (weak, nonatomic) IBOutlet     UITableView *tableView;

@property (nonatomic, assign)            NSInteger offset;         // 商家列表请求偏移量，用户上拉刷新的分页请求操作
@property (nonatomic, assign) SCRequestRefreshType requestType;    // 请求类型，是上拉刷新还是下拉刷新

// 配置方法
- (void)initConfig;
- (void)viewConfig;

// 刷新请求方法
- (void)restartDropDownRefreshRequest;
- (void)startDropDownRefreshReuqest;
- (void)startPullUpRefreshRequest;

// 结束刷新方法
- (void)endRefresh;
- (void)readdFooter;
- (void)removeFooter;

// 清除数据方法
- (void)clearListData;
- (void)deleteFailureAtIndex:(NSInteger)index;

@end
