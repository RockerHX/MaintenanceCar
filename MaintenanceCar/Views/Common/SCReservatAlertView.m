//
//  SCReservatAlertView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCReservatAlertView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIConstants.h"
#import "MicroConstants.h"
#import "VersionConstants.h"
#import "AppDelegate.h"
#import "SCAllDictionary.h"
#import "SCReservationItemCell.h"

@interface SCReservatAlertView ()
{
    SCAlertAnimation _animation;
    NSMutableArray   *_itmes;
}

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end

@implementation SCReservatAlertView

- (id)initWithDelegate:(id<SCReservatAlertViewDelegate>)delegate animation:(SCAlertAnimation)anmation
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCReservatAlertView" owner:self options:nil] firstObject];
    self.frame = APP_DELEGATE_INSTANCE.window.bounds;
    _delegate = delegate;
    _animation = anmation;
    
    _itmes = [@[] mutableCopy];
    
    [self initConfig];
    [self viewConfig];
    
    return self;
}

#pragma mark - Private Methods
- (void)initConfig
{
    if (IS_IPHONE_5_PRIOR)
        _flowLayout.itemSize = CGSizeMake(90.0f, _flowLayout.itemSize.height);
    else if (IS_IPHONE_6)
        _flowLayout.itemSize = CGSizeMake(120.0f, _flowLayout.itemSize.height);
}

- (void)viewConfig
{
    _alertView.layer.cornerRadius = 10.0f;
    _titleView.layer.cornerRadius = _alertView.layer.cornerRadius;
    _alertView.layer.borderWidth  = 1.0f;
    _alertView.layer.borderColor  = [UIColor colorWithWhite:0.8f alpha:.2f].CGColor;
    [_collectionView registerNib:[UINib nibWithNibName:@"SCReservationItemCell" bundle:nil] forCellWithReuseIdentifier:@"SCReservationItemCell"];
}

- (void)removeAlertView
{
    __weak typeof(self) weakSelf = self;
    switch (_animation)
    {
        case SCAlertAnimationEnlarge:
        {
            [UIView animateWithDuration:0.2f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _alertView.transform = CGAffineTransformIdentity;
                weakSelf.alpha = ZERO_POINT;
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
            }];
        }
            break;
        case SCAlertAnimationMove:
        {
            [UIView animateWithDuration:0.2f animations:^{
                weakSelf.alpha = ZERO_POINT;
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

#pragma mark - Public Methods
- (void)show
{
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE_INSTANCE.window addSubview:self];
    switch (_animation)
    {
        case SCAlertAnimationEnlarge:
        {
            [UIView animateWithDuration:0.3f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.alpha = 1.0f;
                _alertView.hidden = NO;
                _alertView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
                if (IS_IOS7)
                    _alertView.translatesAutoresizingMaskIntoConstraints = YES;
            } completion:nil];
        }
            break;
        case SCAlertAnimationMove:
        {
            [UIView animateWithDuration:0.2f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _alertView.hidden = NO;
                    _alertView.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
            self.alpha = 1.0f;
            break;
    }
}

#pragma mark - Collection View Data Soure Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [SCAllDictionary share].serviceItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCReservationItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCReservationItemCell" forIndexPath:indexPath];
    
    SCServiceItem *item = [SCAllDictionary share].serviceItems[indexPath.row];
    cell.textLabel.text = item.service_name;
    cell.backgroundColor = [item.service_name isEqualToString:@"免费检测"] ? [UIColor colorWithWhite:0.3f alpha:1.0f] : cell.backgroundColor;
    return cell;
}

#pragma mark - Collection View Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWithServiceItem:)])
        [_delegate selectedWithServiceItem:[SCAllDictionary share].serviceItems[indexPath.row]];
    [self removeAlertView];
}

@end
