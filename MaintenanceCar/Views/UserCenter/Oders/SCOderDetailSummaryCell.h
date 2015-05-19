//
//  SCOderDetailSummaryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderBaseCell.h"
#import "SCOderDetail.h"

@protocol SCOderDetailSummaryCellDelegate <NSObject>

@optional
/**
 *  回调方法，给商家拨打电话
 *
 *  @param phone 商家电话号码
 */
- (void)shouldCallMerchantWithPhone:(NSString *)phone;

@end

@interface SCOderDetailSummaryCell : SCOderBaseCell
{
    SCOderDetail *_detail;
}

@property (weak, nonatomic) IBOutlet UILabel *oderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *arriveDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reserveUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, weak) IBOutlet id<SCOderDetailSummaryCellDelegate>delegate;

- (IBAction)callMerchantButtonPressed:(id)sender;

/**
 *  刷新订单数据
 *
 *  @param detail  订单数据模型
 *
 *  @return 刷新后cell的高度
 */
- (CGFloat)displayCellWithDetail:(SCOderDetail *)detail;

@end
