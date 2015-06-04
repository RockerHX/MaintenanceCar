//
//  SCOrderCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderBaseCell.h"
#import "SCOrder.h"

@protocol SCOrderCellDelegate <NSObject>

@optional
/**
 *  回调方法，给商家拨打电话
 *
 *  @param phone 商家电话号码
 */
- (void)shouldCallMerchantWithPhone:(NSString *)phone;

/**
 *  评论按钮点击回调方法，评论订单
 *
 *  @param order 订单信息
 */
- (void)shouldAppraiseWithOrder:(SCOrder *)order;

@end

@class SCStarView;

@interface SCOrderCell : SCOrderBaseCell
{
    SCOrder *_order;
}

@property (weak, nonatomic) IBOutlet     UILabel *previousStateDateLabel;   // 订单上个状态时间栏
@property (weak, nonatomic) IBOutlet     UILabel *previousStateNameLabel;   // 订单上个状态名称栏
@property (weak, nonatomic) IBOutlet     UILabel *currentStateDateLabel;    // 订单当前状态时间栏
@property (weak, nonatomic) IBOutlet     UILabel *currentStateNameLabel;    // 订单当前状态名称栏
@property (weak, nonatomic) IBOutlet     UILabel *nextStateDateLabel;       // 订单下个状态时间栏
@property (weak, nonatomic) IBOutlet     UILabel *nextStateNameLabel;       // 订单下个状态名称栏

@property (weak, nonatomic) IBOutlet UIImageView *previousStateIcon;        // 订单上个状态图标
@property (weak, nonatomic) IBOutlet      UIView *previousStateLine;        // 订单上个状态线条
@property (weak, nonatomic) IBOutlet      UIView *nextStateLine;            // 订单下个状态图标
@property (weak, nonatomic) IBOutlet UIImageView *nextStateIcon;            // 订单下个状态线条

@property (weak, nonatomic) IBOutlet            UILabel *starPromptLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starPromptLabelTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starPromptLabelHeight;
@property (weak, nonatomic) IBOutlet         SCStarView *starView;
@property (weak, nonatomic) IBOutlet           UIButton *appraiseButton;

@property (nonatomic, weak) IBOutlet id<SCOrderCellDelegate>delegate;

- (IBAction)callMerchantButtonPressed:(id)sender;
- (IBAction)appraiseButtonPressed:(id)sender;

/**
 *  刷新订单数据
 *
 *  @param order 订单数据模型
 *  @param index cell所在row
 *
 *  @return 刷新后cell的高度
 */
- (CGFloat)displayCellWithOrder:(SCOrder *)order index:(NSInteger)index;

@end
