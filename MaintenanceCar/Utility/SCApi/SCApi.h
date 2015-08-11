//
//  SCApi.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/24.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Prompt
FOUNDATION_EXPORT NSString *const NetWorkingError;              // 网络出错提示
FOUNDATION_EXPORT NSString *const DataError;                    // 数据出错提示
FOUNDATION_EXPORT NSString *const JsonParseError;               // 数据解析出错提示

#pragma mark - Api Domain
FOUNDATION_EXPORT NSString *const DoMain;                       // 接口域名
FOUNDATION_EXPORT NSString *const ImageDoMain;                  // 图片资源域名
FOUNDATION_EXPORT NSString *const MerchantImageDoMain;          // 商家图片资源域名


#pragma mark - Api Path
FOUNDATION_EXPORT NSString *const V1ApiPath;                    // V1接口路径
FOUNDATION_EXPORT NSString *const V2ApiPath;                    // V2接口路径
FOUNDATION_EXPORT NSString *const ImagePath;                    // 图片资源路径

#pragma mark - Api
FOUNDATION_EXPORT NSString *const SearchApi;                        // 商家搜索Api
FOUNDATION_EXPORT NSString *const MerchantDetailApi;                // 商家详情Api

FOUNDATION_EXPORT NSString *const MerchantGroupProductApi;          // 商家团购详情Api
FOUNDATION_EXPORT NSString *const GroupTicketsApi;                  // 团购券Api
FOUNDATION_EXPORT NSString *const GroupTicketRefundApi;             // 团购券退款的Api

FOUNDATION_EXPORT NSString *const CommentApi;                       // 评价Api
FOUNDATION_EXPORT NSString *const MerchantCommentApi;               // 商家的评价

FOUNDATION_EXPORT NSString *const VerificationCodeApi;              // 验证码获取Api
FOUNDATION_EXPORT NSString *const LoginApi;                         // 用户登录Api
FOUNDATION_EXPORT NSString *const UserLogApi;                       // 用户日志记录Api
FOUNDATION_EXPORT NSString *const RefreshTokenApi;                  // 刷新Token的Api

FOUNDATION_EXPORT NSString *const MerchantReservationApi;           // 商家预约Api
FOUNDATION_EXPORT NSString *const UpdateReservationApi;             // 更新预约Api
FOUNDATION_EXPORT NSString *const ReservationItemNumApi;            // 预约日期数量Api

FOUNDATION_EXPORT NSString *const CarBrandApi;                      // 汽车品牌Api
FOUNDATION_EXPORT NSString *const CarModelApi;                      // 汽车型号Api
FOUNDATION_EXPORT NSString *const CarsApi;                          // 汽车款式Api
FOUNDATION_EXPORT NSString *const AddCarApi;                        // 添加车辆Api
FOUNDATION_EXPORT NSString *const DeleteCarApi;                     // 删除车辆Api

FOUNDATION_EXPORT NSString *const MaintenanceApi;                   // 保养数据Api
FOUNDATION_EXPORT NSString *const UpdateCarApi;                     // 更新车辆数据Api

FOUNDATION_EXPORT NSString *const AllDictionaryApi;                 // 所有数据字典Api
FOUNDATION_EXPORT NSString *const FlagsColorExplainApi;             // 获取商家对应Flag数据Api
FOUNDATION_EXPORT NSString *const MerchantTagsApi;                  // 获取商家对应Tag标签Api

FOUNDATION_EXPORT NSString *const OperatADApi;                      // 首页运营位Api
FOUNDATION_EXPORT NSString *const HomePageReservationApi;           // 最新预约信息Api

FOUNDATION_EXPORT NSString *const ShopsApi;                         // 商家列表的Api
FOUNDATION_EXPORT NSString *const FilterCategoryApi;                // 筛选分类Api
FOUNDATION_EXPORT NSString *const SearchShopsApi;                   // 搜索商家Api

FOUNDATION_EXPORT NSString *const ProgressOrdersApi;                // 我的进行中订单Api
FOUNDATION_EXPORT NSString *const FinishedOrdersApi;                // 我的已完成订单Api
FOUNDATION_EXPORT NSString *const OrderDetailApi;                   // 订单详情Api
FOUNDATION_EXPORT NSString *const OrderTicketsApi;                  // 买单成功获取团购券Api

FOUNDATION_EXPORT NSString *const ValidCouponsApi;                  // 有效优惠券Api
FOUNDATION_EXPORT NSString *const InvalidCouponsApi;                // 无效优惠券Api
FOUNDATION_EXPORT NSString *const AddCouponApi;                     // 添加优惠券Api
FOUNDATION_EXPORT NSString *const UseCouponApi;                     // 使用优惠券Api
FOUNDATION_EXPORT NSString *const CouponMerchantsApi;               // 优惠券商家Api

FOUNDATION_EXPORT NSString *const MerchantCollectionApi;            // 商家收藏Api
FOUNDATION_EXPORT NSString *const CancelCollectionApi;              // 取消商家收藏Api

FOUNDATION_EXPORT NSString *const WeiXinOrderApi;                   // 微信支付下单Api
FOUNDATION_EXPORT NSString *const WeiXinPayOrderApi;                // 微信支付买单Api
FOUNDATION_EXPORT NSString *const AliOrderApi;                      // 支付宝下单Api
FOUNDATION_EXPORT NSString *const AliPayOrderApi;                   // 支付宝买单Api


@interface SCApi : NSObject

+ (NSString *)apiURLWithApi:(NSString *)api;
+ (NSString *)V1ApiURLWithApi:(NSString *)api;
+ (NSString *)V2ApiURLWithApi:(NSString *)api;
+ (NSString *)imageURLWithImageName:(NSString *)imageName;

@end
