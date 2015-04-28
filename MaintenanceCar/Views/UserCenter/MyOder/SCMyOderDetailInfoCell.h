//
//  SCMyOderDetailInfoCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderCell.h"
#import "SCMyOderDetail.h"

@protocol SCMyOderDetailInfoCellDelegate <NSObject>

@optional
/**
 *  回调方法，给商家拨打电话
 *
 *  @param phone 商家电话号码
 */
- (void)shouldCallMerchantWithPhone:(NSString *)phone;

@end

@interface SCMyOderDetailInfoCell : SCOderCell
{
    SCMyOderDetail *_detail;
}

@property (weak, nonatomic) IBOutlet UILabel *oderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *arriveDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reserveUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, weak) IBOutlet id<SCMyOderDetailInfoCellDelegate>delegate;

- (IBAction)callMerchantButtonPressed:(id)sender;

/**
 *  刷新订单数据
 *
 *  @param detail  订单数据模型
 *
 *  @return 刷新后cell的高度
 */
- (CGFloat)displayCellWithDetail:(SCMyOderDetail *)detail;

@end
