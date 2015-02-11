//
//  SCMaintenanceTypeItem.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCMaintenanceType) {
    SCMaintenanceTypeNormal = 2000,
    SCMaintenanceTypeAccurate,
    SCMaintenanceTypeSelf
};

@class SCMaintenanceTypeItem;

@protocol SCMaintenanceTypeItemDelegate <NSObject>

@optional
- (void)typeViewSelected:(SCMaintenanceTypeItem *)typeView;

@end

@interface SCMaintenanceTypeItem : UIView

@property (weak, nonatomic) IBOutlet UIImageView       *checkBox;
@property (weak, nonatomic) IBOutlet UILabel           *nameLabel;

@property (nonatomic, weak)          id                <SCMaintenanceTypeItemDelegate>delegate;
@property (nonatomic, assign)        SCMaintenanceType type;

- (void)selected;
- (void)unSelected;

@end
