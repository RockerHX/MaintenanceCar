//
//  SCAppraiseViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAppraiseViewController.h"
#import "SCOrder.h"
#import "SCStarView.h"
#import "SCTextView.h"

@implementation SCAppraiseViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[我的订单] - 评价"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[我的订单] - 评价"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameComment];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _starView.enabled = YES;
    _textView.placeholderText = @"请输入评价内容...";
    // 初始化的时候加入单击手势，用于页面点击收起数字键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
}

- (void)viewConfig
{
    [self displayView];
}

#pragma mark - Action Methods
- (IBAction)commitAppraiseButtonPressed:(id)sender
{
    if ([_starView.startValue integerValue])
    {
        if (_textView.text.length == Zero)
            [self showAlertWithTitle:@"温馨提示" message:@"评价内容不能为空！"];
        else if (_textView.text.length > 140)
            [self showAlertWithTitle:@"温馨提示" message:@"评价内容请限制在140个字以内！"];
        else
            [self startCommentRequest];
    }
    else
        [self showAlertWithTitle:@"温馨提示" message:@"请为用户评星级"];
}

#pragma mark - Private Methods
- (void)displayView
{
    _merchantNameLabel.text = _order.merchantName;
    _serviceLabel.text      = _order.serviceName;
    _dateLabel.text         = _order.currentStateDate;
}

- (void)startCommentRequest
{
    WEAK_SELF(weakSelf);
    [self showHUDOnViewController:self];
    NSDictionary *paramters = @{@"user_id": [SCUserInfo share].userID,
                             @"company_id": _order.companyID,
                             @"reserve_id": _order.reserveID,
                                   @"star": _starView.startValue,
                                 @"detail": _textView.text};
    [[SCAPIRequest manager] startCommentAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf];
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            if (statusCode == SCAPIRequestErrorCodeNoError)
                [weakSelf showHUDAlertToViewController:weakSelf.navigationController delegate:weakSelf text:statusMessage delay:0.5f];
            else if (![statusMessage isEqualToString:@"success"])
                [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:statusMessage];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hanleFailureResponseWtihOperation:operation];
    }];
}

/**
 *  页面单击手势事件
 */
- (void)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate Methods
#define MaxTextLenth 140
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location > MaxTextLenth)
    {
        [self showAlertWithTitle:@"温馨提示" message:@"评价内容请限制在140个字以内"];
        return NO;
    }
    else if ([textView.textInputMode.primaryLanguage isEqualToString:@"emoji"] || !textView.textInputMode.primaryLanguage)
        return NO;
    else
        return YES;
}

#pragma mark - MBProgressHUDDelegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(appraiseSuccess)])
        [_delegate appraiseSuccess];
}

@end
