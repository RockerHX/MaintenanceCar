//
//  SCStarView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCStarView.h"

@interface SCStarView ()

@property (weak, nonatomic) IBOutlet UIButton *starFirst;
@property (weak, nonatomic) IBOutlet UIButton *starSecond;
@property (weak, nonatomic) IBOutlet UIButton *starThird;
@property (weak, nonatomic) IBOutlet UIButton *starFourth;
@property (weak, nonatomic) IBOutlet UIButton *starFifth;

- (IBAction)starFirstButton:(id)sender;
- (IBAction)starSecondButton:(id)sender;
- (IBAction)starThirdButton:(id)sender;
- (IBAction)starFourthButton:(id)sender;
- (IBAction)starFifthButton:(id)sender;

@end

@implementation SCStarView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _enabled    = NO;
    _startValue = @"0";
}

#pragma mark - Setter And Getter Methods
// 根据星级数来显示对应星级图片
- (void)setValue:(NSString *)value
{
    _value = value;
    _startValue = value;
    NSInteger star = [value integerValue];
    
    switch (star)
    {
        case 1:
        {
            [self lightStar:_starFirst];
            [self unLightStar:_starSecond];
            [self unLightStar:_starThird];
            [self unLightStar:_starFourth];
            [self unLightStar:_starFifth];
        }
            break;
        case 2:
        {
            [self lightStar:_starFirst];
            [self lightStar:_starSecond];
            [self unLightStar:_starThird];
            [self unLightStar:_starFourth];
            [self unLightStar:_starFifth];
        }
            break;
        case 3:
        {
            [self lightStar:_starFirst];
            [self lightStar:_starSecond];
            [self lightStar:_starThird];
            [self unLightStar:_starFourth];
            [self unLightStar:_starFifth];
        }
            break;
        case 4:
        {
            [self lightStar:_starFirst];
            [self lightStar:_starSecond];
            [self lightStar:_starThird];
            [self lightStar:_starFourth];
            [self unLightStar:_starFifth];
        }
            break;
        case 5:
        {
            [self lightStar:_starFirst];
            [self lightStar:_starSecond];
            [self lightStar:_starThird];
            [self lightStar:_starFourth];
            [self lightStar:_starFifth];
        }
            break;
            
        default:
        {
            [self unLightStar:_starFirst];
            [self unLightStar:_starSecond];
            [self unLightStar:_starThird];
            [self unLightStar:_starFourth];
            [self unLightStar:_starFifth];
        }
            break;
    }
}

#pragma mark - Action Methods
- (IBAction)starFirstButton:(id)sender
{
    if (_enabled)
        self.value = @"1";
}

- (IBAction)starSecondButton:(id)sender
{
    if (_enabled)
        self.value = @"2";
}

- (IBAction)starThirdButton:(id)sender
{
    if (_enabled)
        self.value = @"3";
}

- (IBAction)starFourthButton:(id)sender
{
    if (_enabled)
        self.value = @"4";
}

- (IBAction)starFifthButton:(id)sender
{
    if (_enabled)
        self.value = @"5";
}

#pragma mark - Private Methods
- (void)lightStar:(UIButton *)star
{
    [star setImage:[UIImage imageNamed:@"Star-Light"] forState:UIControlStateNormal];
}

- (void)unLightStar:(UIButton *)star
{
    [star setImage:[UIImage imageNamed:@"Star-Unlight"] forState:UIControlStateNormal];
}

@end
