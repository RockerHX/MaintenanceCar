//
//  SCReservatAlertView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCReservatAlertView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "AppDelegate.h"
#import "SCAllDictionary.h"

@interface SCReservatAlertView ()
{
    SCAlertAnimation _animation;
    NSArray          *_items;
}

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

- (IBAction)cancelButtonPressed:(UIButton *)sender;
- (IBAction)itemPressed:(UIButton *)sender;

@end

@implementation SCReservatAlertView

- (id)initWithDelegate:(id<SCReservatAlertViewDelegate>)delegate animation:(SCAlertAnimation)anmation
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCReservatAlertView" owner:self options:nil] firstObject];
    self.frame = APP_DELEGATE_INSTANCE.window.bounds;
    _delegate = delegate;
    _animation = anmation;
    [self viewConfig];
    
    return self;
}

#pragma mark - Private Methods
- (void)viewConfig
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[SCAllDictionary share] requestWithType:SCDictionaryTypeOderType finfish:^(NSArray *items) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        @try {
            weakSelf.buttonOne.tag   = [((SCDictionaryItem *)items[0]).dict_id integerValue];
            weakSelf.buttonTwo.tag   = [((SCDictionaryItem *)items[1]).dict_id integerValue];
            weakSelf.buttonThree.tag = [((SCDictionaryItem *)items[2]).dict_id integerValue];
            weakSelf.buttonOther.tag = [((SCDictionaryItem *)items[3]).dict_id integerValue];

            [weakSelf.buttonOne setTitle:((SCDictionaryItem *)items[0]).name forState:UIControlStateNormal];
            [weakSelf.buttonTwo setTitle:((SCDictionaryItem *)items[1]).name forState:UIControlStateNormal];
            [weakSelf.buttonThree setTitle:((SCDictionaryItem *)items[2]).name forState:UIControlStateNormal];
            [weakSelf.buttonOther setTitle:((SCDictionaryItem *)items[3]).name forState:UIControlStateNormal];
        }
        @catch (NSException *exception) {
            NSLog(@"SCReservatAlertView Set Button Title Error:%@", exception.reason);
        }
        @finally {
            weakSelf.alpha                        = DOT_COORDINATE;
            weakSelf.alertView.hidden             = YES;
            weakSelf.alertView.layer.cornerRadius = 8.0f;
            weakSelf.titleView.layer.cornerRadius = weakSelf.alertView.layer.cornerRadius;
            weakSelf.alertView.layer.borderWidth  = 1.0f;
            weakSelf.alertView.layer.borderColor  = [UIColor colorWithWhite:0.8f alpha:.2f].CGColor;
        }
    }];
}

- (void)removeAlertView
{
    __weak typeof(self) weakSelf = self;
    switch (_animation)
    {
        case SCAlertAnimationEnlarge:
        {
            [UIView animateWithDuration:0.2f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _alertView.transform = CGAffineTransformIdentity;
                weakSelf.alpha = DOT_COORDINATE;
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
            }];
        }
            break;
        case SCAlertAnimationMove:
        {
            [UIView animateWithDuration:0.2f animations:^{
                weakSelf.alpha = DOT_COORDINATE;
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
            }];
        }
            break;
            
        default:
        {
            [weakSelf removeFromSuperview];
        }
            break;
    }
}

#pragma mark - Action Methods
- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self removeAlertView];
}

- (IBAction)itemPressed:(UIButton *)sender
{
    [_delegate selectedAtButton:sender.tag];
    [self removeAlertView];
}

#pragma mark - Public Methods
- (void)show
{
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE_INSTANCE.window addSubview:self];
    switch (_animation)
    {
        case SCAlertAnimationEnlarge:
        {
            [UIView animateWithDuration:0.3f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.alpha = 1.0f;
                _alertView.hidden = NO;
                _alertView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
            } completion:nil];
        }
            break;
        case SCAlertAnimationMove:
        {
            [UIView animateWithDuration:0.2f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _alertView.hidden = NO;
                    _alertView.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        _alertView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1f animations:^{
                            _alertView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
                        }];
                    }];
                }];
            }];
        }
            break;
            
        default:
        {
            self.alpha = 1.0f;
        }
            break;
    }
}

@end
