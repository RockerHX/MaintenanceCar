//
//  SCPickerView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPickerView.h"
#import "UIConstants.h"

@implementation SCPickerView
{
    id _item;            // 选择数据Cache
}

#pragma mark - Action Methods
- (IBAction)enterButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:didSelectRow:item:)])
        [_delegate pickerView:self didSelectRow:[self indexOfItem:_item] item:(_item ? _item : [_pickerItmes firstObject])];
    [self removePickerView];
}

#pragma mark - Init Methods
- (id)initWithItems:(NSArray *)items type:(SCPickerType)type delegate:(id<SCPickerViewDelegate>)delegate
{
    // 从Xib加载View
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCPickerView" owner:self options:nil] firstObject];
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    // 设置代理，初始化数据
    _picker.dataSource = self;
    _picker.delegate   = self;
    _delegate          = delegate;
    _type              = type;
    
    switch (type)
    {
        case SCPickerTypeCar:
        {
            SCUserCar *car = [[SCUserCar alloc] init];
            car.brandName  = @"添加车辆";
            car.modelName  = @"";
            car.userCarID  = @"";
            NSMutableArray *cars = [NSMutableArray arrayWithArray:[SCUserInfo share].cars];
            [cars addObject:car];
            _pickerItmes = cars;
        }
            break;
        case SCPickerTypeService:
            _pickerItmes = [SCAllDictionary share].serviceItems;
            break;
            
        default:
            _pickerItmes = items;
            break;
    }
    
    [self initConfig];
    
    return self;
}

#pragma mark - Picker View Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerItmes.count;
}

#pragma mark - Picker View Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 选择器选择栏被点击之后缓存选择数据
    @try {
        switch (_type)
        {
            case SCPickerTypeCar:
            {
                SCUserCar *car = _pickerItmes[row];
                return [car.brandName stringByAppendingString:car.modelName];
            }
                break;
            case SCPickerTypeService:
                return ((SCServiceItem *)_pickerItmes[row]).service_name;
                break;
                
            default:
                return _pickerItmes[row];
                break;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SCPickerView Get Item Error:%@", exception.reason);
    }
    @finally {
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 选择器选择栏被点击之后缓存选择数据
    @try {
        _item = _pickerItmes[row];
    }
    @catch (NSException *exception) {
        NSLog(@"SCPickerView Get Item Error:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Private Methods
- (void)initConfig
{
    // 添加单机手势，初始化数据
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addGestureRecognizer)]];
    self.alpha = ZERO_POINT;
}

- (void)addGestureRecognizer
{
    // 空白区域被点击之后关闭筛选器
    [self removePickerView];
}

- (void)removePickerView
{
    // 关闭动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.alpha = ZERO_POINT;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Public Methods
- (void)show
{
    // 显示动画
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _bottomConstraint.constant = _bottomConstraint.constant / 8;
    [_containerView needsUpdateConstraints];
    [UIView animateWithDuration:0.15f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.alpha = 0.2f;
        [weakSelf.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        _bottomConstraint.constant = ZERO_POINT;
        [_containerView needsUpdateConstraints];
        [UIView animateWithDuration:0.15f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.alpha = 1.0f;
            [weakSelf.containerView layoutIfNeeded];
        } completion:nil];
    }];
}

- (void)hidde
{
    [self removePickerView];
}

- (NSInteger)indexOfItem:(id)item
{
    return [_pickerItmes indexOfObject:item];
}

- (BOOL)firstItem:(id)item
{
    return [[_pickerItmes firstObject] isEqual:item];
}

- (BOOL)lastItem:(id)item
{
    return [[_pickerItmes lastObject] isEqual:item];
}

@end
