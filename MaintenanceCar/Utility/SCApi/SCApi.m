//
//  SCApi.m
//  MaintenanceCar
//
//  Created by Andy on 15/8/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCApi.h"


#pragma mark - Hard Code Prompt
NSString *const NetWorkingError = @"网络出错了，请稍后再试>_<!";
NSString *const DataError       = @"数据出错了，正在紧张处理中，请稍后>_<!";
NSString *const JsonParseError  = @"数据出错，请联系元景科技！";

#pragma mark - Api Domain
//NSString *const DoMain              = @"https://api.yjclw.com";
#warning @"发布时更改测试环境"
NSString *const DoMain              = @"http://testing.yjclw.com";
NSString *const ImageDoMain         = @"http://static.yjclw.com";
NSString *const InspectionURL       = @"http://mobile.yjclw.com/Inspection";
NSString *const MerchantImageDoMain = @"http://cdn1.yjclw.com/";

#pragma mark - Api Path
NSString *const V1ApiPath   = @"/v1";
NSString *const V2ApiPath   = @"/v2";
NSString *const ImagePath   = @"/brand/brand_";

#pragma mark - Api
NSString *const SearchApi                   = @"/company_search";
NSString *const MerchantDetailApi           = @"/Carshop";

NSString *const MerchantGroupProductApi     = @"/Group_product";
NSString *const GroupTicketsApi             = @"/Group_ticket/all";
NSString *const GroupTicketRefundApi        = @"/wepay/refund";

NSString *const CommentApi                  = @"/Comments";
NSString *const MerchantCommentApi          = @"/Comments/shop";

NSString *const VerificationCodeApi         = @"/User/code";
NSString *const LoginApi                    = @"/User";
NSString *const UserLogApi                  = @"/Userlog";
NSString *const RefreshTokenApi             = @"/User/refresh/";

NSString *const MerchantReservationApi      = @"/Reservation";
NSString *const UpdateReservationApi        = @"/Reservation/update";
NSString *const ReservationItemNumApi       = @"/Carshop/reservation_left";

NSString *const CarBrandApi                 = @"/Cars/brands";
NSString *const CarModelApi                 = @"/Cars/models";
NSString *const CarsApi                     = @"/Cars";
NSString *const AddCarApi                   = @"/Usercar";
NSString *const DeleteCarApi                = @"/Usercar/delete";

NSString *const MaintenanceApi              = @"/Baoyang/user";
NSString *const UpdateCarApi                = @"/Usercar/update";

NSString *const AllDictionaryApi            = @"/Misc/dictAll";
NSString *const FlagsColorExplainApi        = @"/Special/color_explain";
NSString *const MerchantTagsApi             = @"/Cars/tags";

NSString *const OperatADApi                 = @"/Special/ad";
NSString *const HomePageReservationApi      = @"/Reservation/latest";

NSString *const ShopsApi                    = @"/company_search/company_product";
NSString *const FilterCategoryApi           = @"/company_search/category";
NSString *const SearchShopsApi              = @"/company_search/input_result";

NSString *const ProgressOrdersApi           = @"/Reservation/doing";
NSString *const FinishedOrdersApi           = @"/Reservation/done";
NSString *const OrderDetailApi              = @"/Reservation";
NSString *const OrderTicketsApi             = @"/Group_ticket/order";

NSString *const ValidCouponsApi             = @"/coupon/get_effective_coupon";
NSString *const InvalidCouponsApi           = @"/coupon/get_invalid_coupon";
NSString *const AddCouponApi                = @"/coupon/add_coupon";
NSString *const UseCouponApi                = @"/coupon/use_coupon";
NSString *const CouponMerchantsApi          = @"/coupon/shop_list";

NSString *const MerchantCollectionApi       = @"/Collection";
NSString *const CancelCollectionApi         = @"/Collection/delete";

NSString *const WeiXinOrderApi              = @"/wepay";
NSString *const WeiXinPayOrderApi           = @"/wepay/custom";
NSString *const AliOrderApi                 = @"/zhipay";
NSString *const AliPayOrderApi              = @"/zhipay/custom";


@implementation SCApi

+ (NSString *)apiURLWithApi:(NSString *)api {
    return [self V2ApiURLWithApi:api];
}

+ (NSString *)V1ApiURLWithApi:(NSString *)Api {
    return [[DoMain stringByAppendingString:V1ApiPath] stringByAppendingString:Api];
}

+ (NSString *)V2ApiURLWithApi:(NSString *)Api {
    return [[DoMain stringByAppendingString:V1ApiPath] stringByAppendingString:Api];
}

+ (NSString *)imageURLWithImageName:(NSString *)imageName {
    return [[ImageDoMain stringByAppendingString:ImagePath] stringByAppendingString:imageName];
}

@end