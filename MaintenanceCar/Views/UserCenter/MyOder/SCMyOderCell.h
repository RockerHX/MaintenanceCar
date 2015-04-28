//
//  SCMyOderCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"
#import "UIConstants.h"
#import "SCMyOder.h"

@protocol SCMyOderCellDelegate <NSObject>

@optional
/**
 *  回调方法，给商家拨打电话
 *
 *  @param phone 商家电话号码
 */
- (void)shouldCallMerchantWithPhone:(NSString *)phone;

@end

@interface SCMyOderCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *serviceTypeIcon;          // 服务类型图标
@property (weak, nonatomic) IBOutlet     UILabel *carModelLabel;            // 车辆车型栏
@property (weak, nonatomic) IBOutlet     UILabel *serviceNameLabel;         // 服务名称栏
@property (weak, nonatomic) IBOutlet     UILabel *merchantNameLabel;        // 商家名称栏

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

@property (nonatomic, weak) IBOutlet id<SCMyOderCellDelegate>delegate;

/**
 *  刷新进行中订单数据
 *
 *  @param oder  订单数据模型
 *  @param index cell所在row
 *
 *  @return 刷新后cell的高度
 */
- (CGFloat)displayCellWithReservation:(SCMyOder *)oder index:(NSInteger)index;

- (IBAction)callMerchantButtonPressed:(id)sender;

@end
