//
//  SCMerchantDetail.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import "SCGroupProduct.h"
#import "SCMerchantSummary.h"
#import "SCMerchantProductGroup.h"
#import "SCQuotedPriceGroup.h"
#import "SCMerchantInfo.h"
#import "SCCommentGroup.h"
#import "SCComment.h"

// 商家详情Model
@interface SCMerchantDetail : NSObject

@property (nonatomic, assign)      BOOL  collected;             // 收藏状态
@property (nonatomic, copy)    NSString *address;               // 商家地址
@property (nonatomic, copy)    NSString *companyID;             // 商家ID
@property (nonatomic, copy)    NSString *latitude;              // 商家地理位置 - 纬度
@property (nonatomic, copy)    NSString *longtitude;            // 商家地理位置 - 经度
@property (nonatomic, copy)    NSString *name;                  // 商家名称
@property (nonatomic, copy)    NSString *service;               // 服务内容
@property (nonatomic, copy)    NSString *telephone;             // 联系电话
@property (nonatomic, copy)    NSString *flags;                 // 商家标签
@property (nonatomic, copy)    NSString *tags;                  // 商家特色
@property (nonatomic, copy)    NSString *timeOpen;              // 商家营业时间
@property (nonatomic, copy)    NSString *timeClosed;            // 商家打样时间
@property (nonatomic, copy)    NSString *majors;                // 专修品牌
@property (nonatomic, copy)    NSString *star;                  // 商家星级
@property (nonatomic, copy)    NSString *now;                   // 服务器时间
@property (nonatomic, assign)      BOOL  haveComment;           // 该商家是否拥有评论
@property (nonatomic, assign) NSInteger  commentsCount;         // 评价数量

@property (nonatomic, copy) NSDictionary *serviceItems;         // 服务项目
@property (nonatomic, copy)      NSArray *products;             // 团购项目
@property (nonatomic, copy)      NSArray *normalProducts;       // 项目报价
@property (nonatomic, copy)      NSArray *comments;             // 用户评价
@property (nonatomic, copy)      NSArray *images;               // 商家图片


@property (nonatomic, copy, readonly)     NSString *distance;           // 手机当前位置与商家的距离
@property (nonatomic, copy, readonly)     NSString *serverItemsPrompt;  // 商家服务描述
@property (nonatomic, copy, readonly)      NSArray *merchantImages;     // 商家图片集合
@property (nonatomic, copy, readonly)      NSArray *reservationItems;   // 可预约项目
@property (nonatomic, copy, readonly) NSDictionary *diplayDerviceItems; // 商家服务项目


@property (nonatomic, strong, readonly)      SCMerchantSummary *summary;
@property (nonatomic, strong, readonly) SCMerchantProductGroup *productGroup;
@property (nonatomic, strong, readonly)     SCQuotedPriceGroup *quotedPriceGroup;
@property (nonatomic, strong, readonly)         SCMerchantInfo *info;
@property (nonatomic, strong, readonly)          SCCommentMore *commentMore;
@property (nonatomic, strong, readonly)         SCCommentGroup *commentGroup;

@property (nonatomic, copy, readonly) NSArray *cellDisplayData;

@end
