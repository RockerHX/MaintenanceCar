//
//  API.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/24.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#ifndef MaintenanceCar_API_h
#define MaintenanceCar_API_h

typedef NS_ENUM(NSInteger, SCAPIRequestStatusCode) {
    SCAPIRequestStatusCodeGETSuccess  = 200,
    SCAPIRequestStatusCodePOSTSuccess = 201,
    SCAPIRequestStatusCodeError       = 404,
    SCAPIRequestStatusCodeServerError = 500
};

#define DoMain              @"https://api.yjclw.com"                        // 接口域名
#define ImageDoMain         @"http://static.yjclw.com"                      // 图片资源域名
#define InspectionURL       @"http://mobile.yjclw.com/Inspection"           // 检测进度

#define APIPath             @"/v1"                                          // 接口路径
#define APIURL              [DoMain stringByAppendingString:APIPath]        // 接口链接
#define ImagePath           @"/brand/brand_"                                // 图片资源路径
#define ImageURL            [ImageDoMain stringByAppendingString:ImagePath] // 图片资源链接

#define WearthAPI                   @"/Weather"                             // 天气API
#define SearchAPI                   @"/company_search"                      // 商户搜索API
#define MerchantDetailAPI           @"/Carshop"                             // 商户详情API
#define MerchantCollectionAPI       @"/Collection"                          // 商户收藏API
#define CancelCollectionAPI         @"/Collection/delete"                   // 取消商户收藏API
#define CheckMerchantCollectionAPI  @"/Collection/user"                     // 检查商户收藏状态API
#define MerchantReservationAPI      @"/Reservation"                         // 商户预约API

#define VerificationCodeAPI         @"/Verification"                        // 验证码获取API
#define RegisterAPI                 @"/User"                                // 用户注册API
#define LoginAPI                    RegisterAPI                             // 用户登陆API
#define UserLogAPI                  @"/Userlog"                             // 用户日志记录API

#define MyReservationAPI            @"/Reservation/all"                     // 我的预约接口
#define UpdateReservationAPI        @"/Reservation/update"                  // 更新预约接口

#define CarBrandAPI                 @"/Cars/brands"                         // 汽车品牌接口
#define CarModelAPI                 @"/Cars/models"                         // 汽车型号接口
#define CarsAPI                     @"/Cars"                                // 汽车款式接口
#define AddCarAPI                   @"/Usercar"                             // 添加车辆接口

#define MaintenanceAPI              @"/Baoyang/user"                        // 保养数据接口
#define UpdateCarAPI                @"/Usercar/update"                      // 更新车辆数据接口

#define AllDictionaryAPI            @"/Misc/dictAll"                        // 所有数据字典接口


#define WearthAPIURL                    [APIURL stringByAppendingString:WearthAPI]                  // 天气接口URL - 用于主页模块获取天气信息
#define SearchAPIURL                    [APIURL stringByAppendingString:SearchAPI]                  // 商户搜索接口URL - 用于商户搜索和筛选
#define MerchantDetailAPIURL            [APIURL stringByAppendingString:MerchantDetailAPI]          // 商户详情接口URL - 用于获取短信或者语音验证码
#define MerchantCollectionAPIURL        [APIURL stringByAppendingString:MerchantCollectionAPI]      // 商户收藏接口URL - 用于商户收藏和获取商户收藏
#define CancelCollectionAPIURL          [APIURL stringByAppendingString:CancelCollectionAPI]        // 取消商户收藏接口URL - 用于商户详情页面取消收藏或者个人中心页面删除收藏
#define CheckMerchantCollectionAPIURL   [APIURL stringByAppendingString:CheckMerchantCollectionAPI] // 检查商户收藏状态接口URL - 用于商户详情页面检查商户收藏状态
#define MerchantReservationAPIURL       [APIURL stringByAppendingString:MerchantReservationAPI]     // 商户预约接口URL - 用于商户预约项目

#define VerificationCodeAPIURL          [APIURL stringByAppendingString:VerificationCodeAPI]        // 获取验证码接口URL - 用于获取短信或者语音验证码
#define RegisterAPIURL                  [APIURL stringByAppendingString:RegisterAPI]                // 用户注册接口URL - 用于用户注册
#define LoginAPIURL                     [APIURL stringByAppendingString:LoginAPI]                   // 用户登陆接口URL - 用于用户登陆
#define UserLogAPIURL                   [APIURL stringByAppendingString:UserLogAPI]                 // 用户日志记录接口URL - 打开APP后如果用户已经登录异步调用此URL记录

#define MyReservationAPIURL             [APIURL stringByAppendingString:MyReservationAPI]           // 商户预约接口URL - 用于商户预约项目
#define UpdateReservationAPIURL         [APIURL stringByAppendingString:UpdateReservationAPI]       // 更新预约接口URL - 用于用户取消预约项目

#define CarBrandAPIURL                  [APIURL stringByAppendingString:CarBrandAPI]                // 汽车品牌接口URL - 用于更新汽车品牌
#define CarModelAPIURL                  [APIURL stringByAppendingString:CarModelAPI]                // 汽车型号接口URL - 用于更新汽车型号
#define CarsAPIURL                      [APIURL stringByAppendingString:CarsAPI]                    // 汽车款式接口URL - 用于更新汽车款式
#define AddCarAPIURL                    [APIURL stringByAppendingString:AddCarAPI]                  // 添加车辆接口URL - 用于用户添加车辆

#define MaintenanceAPIURL               [APIURL stringByAppendingString:MaintenanceAPI]             // 保养数据接口URL - 用于获取用户车辆保养数据
#define UpdateCarAPIURL                 [APIURL stringByAppendingString:UpdateCarAPI]               // 更新车辆数据接口URL - 用于用户更新车辆数据

#define AllDictionaryAPIURL             [APIURL stringByAppendingString:AllDictionaryAPI]           // 所有数据字典接口接口URL

#endif
