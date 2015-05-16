//
//  SCMoreMenu.h
//
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMoreMenu : UIView <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UITableView *_menu;
    NSArray     *_titles;
    NSArray     *_images;
    UIView      *_window;
}

@property (nonatomic, copy) UIColor *menuColor;         // 菜单颜色

/**
 *  Menu初始化方法
 *
 *  @param titles Menu显示文字集合
 *  @param images Menu显示图片集合
 *
 *  @return Menu实例
 */
- (instancetype)initWithTitles:(NSArray *)titles
                        images:(NSArray *)images;

/**
 *  显示Menu
 *
 *  @param block 回调方法
 */
- (void)show:(void(^)(NSInteger selectedIndex))block;

/**
 *  关闭Menu
 *
 *  @param animated 是否显示动画
 */
- (void)dismiss:(BOOL)animated;

@end
