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

#define APIPath             @"/v1"                                          // 接口路径
#define APIURL              [DoMain stringByAppendingString:APIPath]        // 接口链接


#define WearthAPI                   @"/Weather"                             // 天气API
#define SearchAPI                   @"/company_search"                      // 商户搜索API
#define MerchantDetailAPI           @"/Carshop"                             // 商户详情API
#define MerchantCollectionAPI       @"/Collection"                          // 商户收藏API
#define MerchantUnCollectionAPI     @"/Collection/delete"                   // 取消商户收藏API
#define CheckMerchantCollectionAPI  @"/Collection/user"                     // 检查商户收藏状态API

#define VerificationCodeAPI         @"/Verification"                        // 验证码获取API
#define RegisterAPI                 @"/User"                                // 用户注册API
#define LoginAPI                    RegisterAPI                             // 用户登陆API
#define UserLogAPI                  @"/Userlog"                             // 用户日志记录API


#define WearthAPIURL                    [APIURL stringByAppendingString:WearthAPI]                  // 天气接口URL - 用于主页模块获取天气信息
#define SearchAPIURL                    [APIURL stringByAppendingString:SearchAPI]                  // 商户搜索接口URL - 用于商户搜索和筛选
#define MerchantDetailAPIURL            [APIURL stringByAppendingString:MerchantDetailAPI]          // 商户详情接口URL - 用于获取短信或者语音验证码
#define MerchantCollectionAPIURL        [APIURL stringByAppendingString:MerchantCollectionAPI]      // 商户收藏接口URL - 用于商户收藏和获取商户收藏
#define MerchantUnCollectionAPIURL      [APIURL stringByAppendingString:MerchantUnCollectionAPI]    // 取消商户收藏接口URL - 用于商户详情页面取消收藏或者个人中心页面删除收藏
#define CheckMerchantCollectionAPIURL   [APIURL stringByAppendingString:CheckMerchantCollectionAPI] // 检查商户收藏状态接口URL - 用于商户详情页面检查商户收藏状态

#define VerificationCodeAPIURL      [APIURL stringByAppendingString:VerificationCodeAPI]    // 获取验证码接口URL - 用于获取短信或者语音验证码
#define RegisterAPIURL              [APIURL stringByAppendingString:RegisterAPI]            // 用户注册接口URL - 用于用户注册
#define LoginAPIURL                 [APIURL stringByAppendingString:LoginAPI]               // 用户登陆接口URL - 用于用户登陆
#define UserLogAPIURL               [APIURL stringByAppendingString:UserLogAPI]             // 用户日志记录接口URL - 打开APP后如果用户已经登录异步调用此URL记录

#endif
