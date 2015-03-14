//
//  SCAppraiseViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAppraiseViewController.h"
#import "SCReservation.h"
#import "SCStarView.h"
#import "SCPlaceholderTextView.h"

@interface SCAppraiseViewController () <UITextViewDelegate>

@end

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
    [MobClick beginLogPageView:@"[我的订单] - 评价"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _starView.enabled = YES;
    
    _textView.delegate = self;
    _textView.placeholderText = @"请输入评论内容...";
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
            [self showAlertWithTitle:@"温馨提示" message:@"评论内容不能为空！"];
        else if (_textView.text.length > 140)
            [self showAlertWithTitle:@"温馨提示" message:@"评论内容请限制在140个字以内！"];
        else
            [self startCommentRequest];
    }
    else
        [self showAlertWithTitle:@"温馨提示" message:@"请为用户评星级"];
}

#pragma mark - Private Methods
- (void)displayView
{
    _merchantNameLabel.text = _reservation.name;
    _serviceLabel.text = _reservation.type;
    _dateLabel.text = _reservation.create_time;
}

- (void)startCommentRequest
{
    [self showHUDOnViewController:self];
    __weak typeof(self)weakSelf = self;
    NSDictionary *paramters = @{@"user_id": [SCUserInfo share].userID,
                             @"company_id": _reservation.company_id,
                             @"reserve_id": _reservation.reserve_id,
                                   @"star": @([_starView.startValue integerValue]*2),
                                 @"detail": _textView.text};
    [[SCAPIRequest manager] startCommentAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf];
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController delegate:weakSelf text:@"评论成功！" delay:0.5f];
        else
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"评论失败，请重试！" delay:0.5f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideHUDOnViewController:weakSelf];
        [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"评论失败，请重试！" delay:0.5f];
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
        [self showAlertWithTitle:@"温馨提示" message:@"评论内容请限制在140个字以内"];
        return NO;
    }
    else
        return YES;
}

#pragma mark - MBProgressHUDDelegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([_delegate respondsToSelector:@selector(appraiseSuccess)])
        [_delegate appraiseSuccess];
}

@end
