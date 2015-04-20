//
//  SCNavigationTableViewController.h
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import <MJRefresh/MJRefresh.h>

@class SCNavigationTab;

typedef NS_ENUM(NSInteger, SCRequestRefreshType) {
    SCRequestRefreshTypeDropDown,
    SCRequestRefreshTypePullUp
};

@interface SCNavigationTableViewController : UIViewController
{
    id              _deleteDataCache;    // 删除数据的缓存
    NSMutableArray *_dataList;           // 列表数据缓存
}

@property (weak, nonatomic) IBOutlet SCNavigationTab *navigationTab;
@property (weak, nonatomic) IBOutlet     UITableView *tableView;

@property (nonatomic, assign)                 BOOL showTrashItem;
@property (nonatomic, assign)            NSInteger page;           // 商家列表请求偏移量，用户上拉刷新的分页请求操作
@property (nonatomic, assign) SCRequestRefreshType requestType;    // 请求类型，是上拉刷新还是下拉刷新

- (void)initConfig;
- (void)viewConfig;

- (void)restartDropDownRefreshRequest;
- (void)startDropDownRefreshReuqest;
- (void)startPullUpRefreshRequest;

- (void)endRefresh;
- (void)readdFooter;
- (void)removeFooter;

- (void)clearListData;
- (void)deleteFailureAtIndex:(NSInteger)index;

@end
