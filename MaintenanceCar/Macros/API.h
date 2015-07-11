//
//  API.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/24.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#ifndef MaintenanceCar_API_h
#define MaintenanceCar_API_h

#pragma mark - Hard Code Prompt
#define NetWorkError        @"网络出错了，请稍后再试>_<!"
#define DataError           @"数据出错了，正在紧张处理中，请稍后>_<!"

#define DefaultQuery        @"default:'深圳'"


#pragma mark - API Domain
//#define DoMain              @"https://api.yjclw.com"                        // 接口域名
#warning @"发布时更改测试环境"
#define DoMain              @"http://testing.yjclw.com"                     // 接口域名
#define ImageDoMain         @"http://static.yjclw.com"                      // 图片资源域名
#define InspectionURL       @"http://mobile.yjclw.com/Inspection"           // 检测进度
#define MerchantImageDoMain @"http://cdn1.yjclw.com/"                       // 商家图片资源域名


#pragma mark - API Path
#define V1APIPath           @"/v1"                                          // V1接口路径
#define V2APIPath           @"/v2"                                          // V2接口路径
#define V1APIURL            [DoMain stringByAppendingString:V1APIPath]      // V1接口链接
#define V2APIURL            [DoMain stringByAppendingString:V2APIPath]      // V2接口链接
#define ImagePath           @"/brand/brand_"                                // 图片资源路径
#define ImageURL            [ImageDoMain stringByAppendingString:ImagePath] // 图片资源链接

#pragma mark - API
#define SearchAPI                   @"/company_search"                      // 商家搜索API
#define MerchantDetailAPI           @"/Carshop"                             // 商家详情API

#define MerchantGroupProductAPI     @"/Group_product"                       // 商家团购详情API
#define GroupTicketsAPI             @"/Group_ticket/all"                    // 团购券API
#define GroupTicketRefundAPI        @"/wepay/refund"                        // 团购券退款的API

#define CommentAPI                  @"/Comments"                            // 评价API
#define MerchantCommentAPI          @"/Comments/shop"                       // 商家的评价

#define VerificationCodeAPI         @"/User/code"                           // 验证码获取API
#define LoginAPI                    @"/User"                                // 用户登录API
#define UserLogAPI                  @"/Userlog"                             // 用户日志记录API
#define RefreshTokenAPI             @"/User/refresh/"                       // 刷新Token的API

#define MerchantReservationAPI      @"/Reservation"                         // 商家预约API
#define UpdateReservationAPI        @"/Reservation/update"                  // 更新预约API
#define ReservationItemNumAPI       @"/Carshop/reservation_left"            // 预约日期数量API

#define CarBrandAPI                 @"/Cars/brands"                         // 汽车品牌API
#define CarModelAPI                 @"/Cars/models"                         // 汽车型号API
#define CarsAPI                     @"/Cars"                                // 汽车款式API
#define AddCarAPI                   @"/Usercar"                             // 添加车辆API
#define DeleteCarAPI                @"/Usercar/delete"                      // 删除车辆API

#define MaintenanceAPI              @"/Baoyang/user"                        // 保养数据API
#define UpdateCarAPI                @"/Usercar/update"                      // 更新车辆数据API

#define AllDictionaryAPI            @"/Misc/dictAll"                        // 所有数据字典API
#define FlagsColorExplainAPI        @"/Special/color_explain"               // 获取商家对应Flag数据API
#define MerchantTagsAPI             @"/Cars/tags"                           // 获取商家对应Tag标签API

#define OperatADAPI                 @"/Special/ad"                          // 首页运营位API
#define HomePageReservationAPI      @"/Reservation/latest"                  // 最新预约信息API
#define HomePageSpecialAPI          @"/Special"                             // 首页第四个按钮数据API


#pragma mark - V2
#define ShopsAPI                    @"/company_search/company_product"      // 商家列表的API
#define FilterCategoryAPI           @"/company_search/category"             // 筛选分类API

#define ProgressOrdersAPI           @"/Reservation/doing"                   // 我的进行中订单API
#define FinishedOrdersAPI           @"/Reservation/done"                    // 我的已完成订单API
#define OrderDetailAPI              @"/Reservation"                         // 订单详情API
#define OrderTicketsAPI             @"/Group_ticket/order"                  // 买单成功获取团购券API

#define ValidCouponsAPI             @"/coupon/get_effective_coupon"         // 有效优惠券API
#define InvalidCouponsAPI           @"/coupon/get_invalid_coupon"           // 无效优惠券API
#define AddCouponAPI                @"/coupon/add_coupon"                   // 添加优惠券API
#define UseCouponAPI                @"/coupon/use_coupon"                   // 使用优惠券API
#define CouponMerchantsAPI          @"/coupon/shop_list"                    // 优惠券商家API

#define MerchantCollectionAPI       @"/Collection"                          // 商家收藏API
#define CancelCollectionAPI         @"/Collection/delete"                   // 取消商家收藏API

#define WeiXinOrderAPI              @"/wepay"                               // 微信支付下单API
#define WeiXinPayOrderAPI           @"/wepay/custom"                        // 微信支付买单API
#define AliOrderAPI                 @"/zhipay"                              // 支付宝下单API
#define AliPayOrderAPI              @"/zhipay/custom"                       // 支付宝买单API


#pragma mark - API URL
#define SearchAPIURL                    [V1APIURL stringByAppendingString:SearchAPI]                  // 商家搜索接口URL - 用于商家搜索和筛选
#define MerchantDetailAPIURL            [V1APIURL stringByAppendingString:MerchantDetailAPI]          // 商家详情接口URL - 用于获取短信或者语音验证码

#define MerchantGroupProductAPIURL      [V1APIURL stringByAppendingString:MerchantGroupProductAPI]    // 商家团购详情接口URL - 用于商家团购项目
#define GroupTicketsAPIURL              [V2APIURL stringByAppendingString:GroupTicketsAPI]            // 团购券列表接口URL - 用于获取用户所有团购券列表
#define GroupTicketRefundAPIURL         [V1APIURL stringByAppendingString:GroupTicketRefundAPI]       // 团购券退款的接口URL - 用于团购券详情申请退款

#define CommentAPIURL                   [V2APIURL stringByAppendingString:CommentAPI]                 // 评价接口URL - 用于添加评价
#define MerchantCommentAPIURL           [V2APIURL stringByAppendingString:MerchantCommentAPI]         // 商家评价接口URL - 用于获取商家评价列表

#define VerificationCodeAPIURL          [V2APIURL stringByAppendingString:VerificationCodeAPI]        // 获取验证码接口URL - 用于获取短信或者语音验证码
#define LoginAPIURL                     [V2APIURL stringByAppendingString:LoginAPI]                   // 用户登录接口URL - 用于用户登录
#define UserLogAPIURL                   [V2APIURL stringByAppendingString:UserLogAPI]                 // 用户日志记录接口URL - 打开APP后如果用户已经登录异步调用此URL记录
#define RefreshTokenAPIURL              [V2APIURL stringByAppendingString:RefreshTokenAPI]            // 刷新Token接口URL - 刷新token过期时间

#define MerchantReservationAPIURL       [V2APIURL stringByAppendingString:MerchantReservationAPI]     // 商家预约接口URL - 用于商家预约项目
#define UpdateReservationAPIURL         [V2APIURL stringByAppendingString:UpdateReservationAPI]       // 更新预约接口URL - 用于用户取消预约项目
#define ReservationItemNumAPIURL        [V2APIURL stringByAppendingString:ReservationItemNumAPI]      // 预约日期数量接口URL - 用于获取预约项目数量

#define CarBrandAPIURL                  [V1APIURL stringByAppendingString:CarBrandAPI]                // 汽车品牌接口URL - 用于更新汽车品牌
#define CarModelAPIURL                  [V1APIURL stringByAppendingString:CarModelAPI]                // 汽车型号接口URL - 用于更新汽车型号
#define CarsAPIURL                      [V1APIURL stringByAppendingString:CarsAPI]                    // 汽车款式接口URL - 用于更新汽车款式
#define AddCarAPIURL                    [V1APIURL stringByAppendingString:AddCarAPI]                  // 添加车辆接口URL - 用于用户添加车辆
#define DeleteCarAPIURL                 [V1APIURL stringByAppendingString:DeleteCarAPI]               // 删除车辆接口URL - 用于用户删除车辆

#define MaintenanceAPIURL               [V1APIURL stringByAppendingString:MaintenanceAPI]             // 保养数据接口URL - 用于获取用户车辆保养数据
#define UpdateCarAPIURL                 [V1APIURL stringByAppendingString:UpdateCarAPI]               // 更新车辆数据接口URL - 用于用户更新车辆数据

#define AllDictionaryAPIURL             [V1APIURL stringByAppendingString:AllDictionaryAPI]           // 所有数据字典接口URL
#define FlagsColorExplainAPIURL         [V1APIURL stringByAppendingString:FlagsColorExplainAPI]       // 获取商家对应Flag颜色值接口URL
#define MerchantTagsAPIURL              [V1APIURL stringByAppendingString:MerchantTagsAPI]            // 获取商家对应Tag标签接口URL

#define OperatADAPIURL                  [V1APIURL stringByAppendingString:OperatADAPI]                // 首页运营位接口URL - 用于首页运营位数据
#define HomePageReservationAPIURL       [V2APIURL stringByAppendingString:HomePageReservationAPI]     // 最新预约信息接口URL - 用于首页获取
#define HomePageSpecialAPIURL           [V1APIURL stringByAppendingString:HomePageSpecialAPI]         // 首页第四个按钮数据接口URL


#pragma mark - V2
#define ShopsAPIURL                     [V2APIURL stringByAppendingString:ShopsAPI]                   // 商家列表接口URL - 用于请求商家列表数据
#define FilterCategoryAPIURL            [V2APIURL stringByAppendingString:FilterCategoryAPI]          // 筛选分类接口URL - 用于请求筛选的分类数据

#define ProgressOrdersAPIURL            [V2APIURL stringByAppendingString:ProgressOrdersAPI]          // 进行中订单接口URL - 用于进行中订单数据获取
#define FinishedOrdersAPIURL            [V2APIURL stringByAppendingString:FinishedOrdersAPI]          // 已完成订单接口URL - 用于已完成订单数据获取
#define OrderDetailAPIURL               [V2APIURL stringByAppendingString:OrderDetailAPI]             // 订单详情接口URL - 用于订单详情数据获取
#define OrderTicketsAPIURL              [V2APIURL stringByAppendingString:OrderTicketsAPI]            // 买单成功获取团购券接口URL - 用于团购券买单成功之后回去购买成功的优惠券

#define ValidCouponsAPIURL              [V2APIURL stringByAppendingString:ValidCouponsAPI]            // 有效优惠券接口URL - 用于获取用户所有有效优惠券
#define InvalidCouponsAPIURL            [V2APIURL stringByAppendingString:InvalidCouponsAPI]          // 无效优惠券接口URL - 用于获取用户所有无效优惠券
#define AddCouponAPIURL                 [V2APIURL stringByAppendingString:AddCouponAPI]               // 添加优惠券接口URL - 用于输入优惠码兑换可用优惠券
#define UseCouponAPIURL                 [V2APIURL stringByAppendingString:UseCouponAPI]               // 使用优惠券接口URL - 用于优惠券消费
#define CouponMerchantsAPIURL           [V2APIURL stringByAppendingString:CouponMerchantsAPI]         // 优惠券商家接口URL - 用于根据优惠券码获取能够使用的商户列表

#define MerchantCollectionAPIURL        [V2APIURL stringByAppendingString:MerchantCollectionAPI]      // 商家收藏接口URL - 用于商家收藏和获取商家收藏
#define CancelCollectionAPIURL          [V2APIURL stringByAppendingString:CancelCollectionAPI]        // 取消商家收藏接口URL - 用于商家详情页面取消收藏或者个人中心页面删除收藏

#define WeiXinOrderAPIURL               [V2APIURL stringByAppendingString:WeiXinOrderAPI]             // 微信支付下单接口URL - 用于团购支付时获取微信支付下单信息
#define WeiXinPayOrderAPIURL            [V2APIURL stringByAppendingString:WeiXinPayOrderAPI]          // 微信支付买单接口URL - 用于团购支付时获取微信支付买单信息
#define AliOrderAPIURL                  [V2APIURL stringByAppendingString:AliOrderAPI]                // 支付宝下单接口URL - 用于团购支付时获取支付宝下单信息
#define AliPayOrderAPIURL               [V2APIURL stringByAppendingString:AliPayOrderAPI]             // 支付宝买单接口URL - 用于团购支付时获取支付宝买单信息

#endif
