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
#define WearthAPI                   @"/Weather"                             // 天气API
#define SearchAPI                   @"/company_search"                      // 商家搜索API
#define OperateSearchAPI            @"/company_search/operate"              // 运营位商家搜索API
#define MerchantDetailAPI           @"/Carshop"                             // 商家详情API
#define MerchantCollectionAPI       @"/Collection"                          // 商家收藏API
#define CancelCollectionAPI         @"/Collection/delete"                   // 取消商家收藏API
#define CheckMerchantCollectionAPI  @"/Collection/user"                     // 检查商家收藏状态API

#define MerchantGroupProductAPI     @"/Group_product"                       // 商家团购详情API
#define WeiXinPayAPI                @"/wepay"                               // 微信支付API
#define AliPayAPI                   @"/zhipay"                              // 支付宝钱包API
#define GenerateCouponAPI           @"/Group_ticket"                        // 生成团购券API
#define MyGroupProductAPI           @"/Group_ticket/all"                    // 我的团购券列表API
#define CouponDetailAPI             GenerateCouponAPI                       // 团购券详情API
#define CouponRefundAPI             @"/wepay/refund"                        // 团购券退款的API

#define CommentAPI                  @"/Comments"                            // 评价API
#define MerchantCommentAPI          @"/Comments/shop"                       // 商家的评价

#define VerificationCodeAPI         @"/User/code"                           // 验证码获取API
#define LoginAPI                    @"/User"                                // 用户登录API
#define UserLogAPI                  @"/Userlog"                             // 用户日志记录API
#define RefreshTokenAPI             @"/User/refresh/"                       // 刷新Token的API

#define MerchantReservationAPI      @"/Reservation"                         // 商家预约API
#define MyReservationAPI            @"/Reservation/all"                     // 我的预约API
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
#define MyOderAPI                   @"/Reservation/doing"                   // 我的订单API


#pragma mark - API URL
#define WearthAPIURL                    [V1APIURL stringByAppendingString:WearthAPI]                  // 天气接口URL - 用于主页模块获取天气信息
#define SearchAPIURL                    [V1APIURL stringByAppendingString:SearchAPI]                  // 商家搜索接口URL - 用于商家搜索和筛选
#define OperateSearchAPIURL             [V1APIURL stringByAppendingString:OperateSearchAPI]           // 运营位商家搜索接口URL - 用于运营位商家搜索和筛选
#define MerchantDetailAPIURL            [V1APIURL stringByAppendingString:MerchantDetailAPI]          // 商家详情接口URL - 用于获取短信或者语音验证码
#define MerchantCollectionAPIURL        [V1APIURL stringByAppendingString:MerchantCollectionAPI]      // 商家收藏接口URL - 用于商家收藏和获取商家收藏
#define CancelCollectionAPIURL          [V1APIURL stringByAppendingString:CancelCollectionAPI]        // 取消商家收藏接口URL - 用于商家详情页面取消收藏或者个人中心页面删除收藏
#define CheckMerchantCollectionAPIURL   [V1APIURL stringByAppendingString:CheckMerchantCollectionAPI] // 检查商家收藏状态接口URL - 用于商家详情页面检查商家收藏状态

#define MerchantGroupProductAPIURL      [V1APIURL stringByAppendingString:MerchantGroupProductAPI]    // 商家团购详情接口URL - 用于商家团购项目
#define WeiXinPayAPIURL                 [V1APIURL stringByAppendingString:WeiXinPayAPI]               // 微信支付订单接口URL - 用于团购支付时获取微信支付订单信息
#define AliPayAPIURL                    [V1APIURL stringByAppendingString:AliPayAPI]                  // 支付宝钱包支付订单接口URL - 用于团购支付时获取支付宝钱包订单信息
#define GenerateCouponAPIURL            [V1APIURL stringByAppendingString:GenerateCouponAPI]          // 生成团购券接口URL - 用于付款成功后生成团购券
#define MyGroupProductAPIURL            [V2APIURL stringByAppendingString:MyGroupProductAPI]          // 我的团购券列表接口URL - 用于获取用户所有团购券列表
#define CouponDetailAPIURL              [V1APIURL stringByAppendingString:CouponDetailAPI]            // 团购券详情接口URL - 用于获取团购券详情
#define CouponRefundAPIURL              [V1APIURL stringByAppendingString:CouponRefundAPI]            // 团购券退款的接口URL - 用于团购券详情申请退款

#define CommentAPIURL                   [V1APIURL stringByAppendingString:CommentAPI]                 // 评价接口URL - 用于添加评价
#define MerchantCommentAPIURL           [V1APIURL stringByAppendingString:MerchantCommentAPI]         // 商家评价接口URL - 用于获取商家评价列表

#define VerificationCodeAPIURL          [V1APIURL stringByAppendingString:VerificationCodeAPI]        // 获取验证码接口URL - 用于获取短信或者语音验证码
#define LoginAPIURL                     [V1APIURL stringByAppendingString:LoginAPI]                   // 用户登录接口URL - 用于用户登录
#define UserLogAPIURL                   [V1APIURL stringByAppendingString:UserLogAPI]                 // 用户日志记录接口URL - 打开APP后如果用户已经登录异步调用此URL记录
#define RefreshTokenAPIURL              [V1APIURL stringByAppendingString:RefreshTokenAPI]            // 刷新Token接口URL - 刷新token过期时间

#define MerchantReservationAPIURL       [V2APIURL stringByAppendingString:MerchantReservationAPI]     // 商家预约接口URL - 用于商家预约项目
#define MyReservationAPIURL             [V2APIURL stringByAppendingString:MyReservationAPI]           // 商家预约接口URL - 用于商家预约项目
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
#define HomePageReservationAPIURL       [V1APIURL stringByAppendingString:HomePageReservationAPI]     // 最新预约信息接口URL - 用于首页获取
#define HomePageSpecialAPIURL           [V1APIURL stringByAppendingString:HomePageSpecialAPI]         // 首页第四个按钮数据接口URL


#pragma mark - V2
#define MyOderAPIURL                    [V2APIURL stringByAppendingString:MyOderAPI]                  // 我的订单接口URL - 用于我的订单数据获取

#endif
