//
//  SCCouponsViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponsViewController.h"
#import "SCCouponCell.h"
#import "SCInvalidCouponsViewController.h"
#import "SCCouponDetailViewController.h"
#import "SCWebViewController.h"

static NSString *const CouponNavControllerID = @"CouponsNavigationController";

@implementation SCCouponsViewController {
    NSMutableArray *_coupons;
    SCCouponCell   *_couponCell;
}

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance {
    static UINavigationController *navigationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navigationController = [SCStoryBoardManager navigaitonControllerWithIdentifier:CouponNavControllerID
                                                                        storyBoardName:SCStoryBoardNameCoupon];
    });
    return navigationController;
}

+ (instancetype)instance {
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameCoupon];
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 优惠券"];
    
    [self startCouponsRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self panGestureSupport:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 优惠券"];
    
    [self panGestureSupport:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
    [self startCouponsRequest];
}

#pragma mark - Config Methods
- (void)initConfig {
    _coupons = [@[] mutableCopy];
}

- (void)viewConfig {
    _headerView.layer.shadowColor = [UIColor grayColor].CGColor;
    _headerView.layer.shadowOpacity = 1.0f;
    _headerView.layer.shadowRadius = 6.0f;
    _enterCodeBGView.layer.shadowColor = [UIColor grayColor].CGColor;
    _enterCodeBGView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _enterCodeBGView.layer.shadowOpacity = 1.0f;
    _enterCodeBGView.layer.shadowRadius = 1.0f;
}

#pragma mark - Setter And Getter
- (void)setPayEnter:(BOOL)payEnter {
    _payEnter = payEnter;
    if (_payEnter) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButtonIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(popToPreviousViewController)];
    }
}

#pragma mark - Action
- (IBAction)menuButtonPressed {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldShowMenu)]) {
        [_delegate shouldShowMenu];
    }
}

- (IBAction)exchangeButtonPressed {
    if (_codeField.text.length > Zero) {
        [_codeField resignFirstResponder];
        [self startAddCouponRequest];
    } else {
        [self showHUDAlertToViewController:self text:@"请输入优惠券再兑换"];
    }
}

- (IBAction)ruleButtonPressed {
    SCWebViewController *webViewController = [SCWebViewController instance];
    webViewController.title = @"优惠券使用规则";
    webViewController.loadURL = @"";
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)showInvalidCoupons {
    [self.navigationController pushViewController:[SCInvalidCouponsViewController instance] animated:YES];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _coupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCell" forIndexPath:indexPath];
    if (_coupons.count) {
        [cell displayCellWithCoupon:_coupons[indexPath.row]];
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = Zero;
    if (_coupons.count) {
        if(!_couponCell) {
            _couponCell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCell"];
        }
        height = [_couponCell displayCellWithCoupon:_coupons[indexPath.row]];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SCCouponDetailViewController *couponDetailViewController = [SCCouponDetailViewController instance];
    couponDetailViewController.coupon = _coupons[indexPath.row];
    [self.navigationController pushViewController:couponDetailViewController animated:YES];
}

#pragma mark - Private Methods
- (void)popToPreviousViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startCouponsRequest {
    WEAK_SELF(weakSelf);
    [self showHUDOnViewController:self];
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                             @"sort_method": @"time"};
    [[SCAppApiRequest manager] startValidCouponsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf];
        if (operation.response.statusCode == SCApiRequestStatusCodeGETSuccess) {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode) {
                case SCAppApiRequestErrorCodeNoError: {
                    [_coupons removeAllObjects];
                    [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SCCoupon *coupon = [SCCoupon objectWithKeyValues:obj];
                        [_coupons addObject:coupon];
                    }];
                    [weakSelf.tableView reloadData];
                }
                    break;
            }
            if (statusMessage.length) {
                [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hanleFailureResponseWtihOperation:operation];
        [weakSelf hideHUDOnViewController:weakSelf];
    }];
}

- (void)startAddCouponRequest {
    WEAK_SELF(weakSelf);
    [self showHUDOnViewController:self];
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                    @"code": _codeField.text};
    [[SCAppApiRequest manager] startAddCouponAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf];
        if (operation.response.statusCode == SCApiRequestStatusCodeGETSuccess) {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode) {
                case SCAppApiRequestErrorCodeNoError: {
                    _codeField.text = @"";
                    [_coupons removeAllObjects];
                    [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SCCoupon *coupon = [SCCoupon objectWithKeyValues:obj];
                        [_coupons addObject:coupon];
                    }];
                    
                    [weakSelf.tableView reloadData];
                    if (_delegate && [_delegate respondsToSelector:@selector(userAddCouponSuccess)]) {
                        [_delegate userAddCouponSuccess];
                    }
                }
                    break;
            }
            if (statusMessage.length) {
                [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
            }
            [_coupons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCCoupon *coupon = obj;
                if (coupon.current)
                    [weakSelf showAlertWithTitle:@"兑换成功" message:[NSString stringWithFormat:@"%@（%@），有效期至%@。请按优惠券使用规则使用。", coupon.title, coupon.prompt, coupon.validDate]];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hanleFailureResponseWtihOperation:operation];
        [weakSelf hideHUDOnViewController:weakSelf];
    }];
}

- (void)panGestureSupport:(BOOL)support {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldSupportPanGesture:)]) {
        [_delegate shouldSupportPanGesture:support];
    }
}

@end
