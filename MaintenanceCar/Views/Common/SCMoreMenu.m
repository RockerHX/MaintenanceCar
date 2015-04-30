//
//  SCMoreMenu.m
//
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCMoreMenu.h"

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)       // 获取屏幕宽度

#define STATUS_BAR_HEIGHT               20.0f
#define NAVIGATION_BAR_HEIGHT           44.0f

#define ARROW_HEIGHT                    10.0f
#define SPACE                           2.0f
#define ROW_HEIGHT                      NAVIGATION_BAR_HEIGHT
#define TITLE_FONT                      [UIFont systemFontOfSize:16.0f]

@interface SCMoreMenuCell : UITableViewCell

- (void)displayCellWithTitles:(NSArray *)titles images:(NSArray *)images index:(NSInteger)index;

@end

@implementation SCMoreMenuCell

#pragma mark - Init Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor         = [UIColor clearColor];
        self.selectionStyle          = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

#pragma mark - Public methods
- (void)displayCellWithTitles:(NSArray *)titles images:(NSArray *)images index:(NSInteger)index
{
    if ([images count] == [titles count])
        self.imageView.image = [UIImage imageNamed:[images objectAtIndex:index]];
    self.textLabel.font      = TITLE_FONT;
    self.textLabel.text      = [titles objectAtIndex:index];
    self.textLabel.textColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
}

@end

static NSString *CellIdentifier = @"SCMoreMenuCell";
typedef void(^Block)(NSInteger selectedIndex);

@implementation SCMoreMenu
{
    Block _block;
}

#pragma mark - Init Methods
- (instancetype)initWithTitles:(NSArray *)titles
                        images:(NSArray *)images
{
    self = [super init];
    if (self)
    {
        _titles    = titles;
        _images    = images;
        
        [self initConfig];
        [self viewConfig];
    }
    return self;
}

#pragma mark - Config Methods
- (void)initConfig
{
    _menuColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.backgroundColor = [UIColor clearColor];
}

- (void)viewConfig
{
    self.frame = [self menuFrame];
    [self initMenu];
}

#pragma mark - Draw Methods
- (void)drawRect:(CGRect)rect
{
    CGPoint arrowPoint   = [self convertPoint:CGPointMake(SCREEN_WIDTH - 30.0f, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT - 10.0f) fromView:_window];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context, arrowPoint.x - ARROW_HEIGHT, ARROW_HEIGHT);               //设置起点
    CGContextAddLineToPoint(context, arrowPoint.x, arrowPoint.y);
    CGContextAddLineToPoint(context, arrowPoint.x + ARROW_HEIGHT - 6.0f, ARROW_HEIGHT);
    CGContextClosePath(context);                                                            //路径结束标志，不写默认封闭
    [_menuColor setFill];                                                                 //设置填充色
    [_menuColor setStroke];                                                               //设置边框颜色
    CGContextDrawPath(context, kCGPathFillStroke);                                          //绘制路径path
}

#pragma mark - Public Methods
- (void)show:(void(^)(NSInteger selectedIndex))block
{
    _block = block;
    _window = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [_window addGestureRecognizer:tap];
    [_window addSubview:self];
    
    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
    [appWindow addSubview:_window];
    
    self.layer.anchorPoint = CGPointMake(0.7f, 0.0f);
    self.frame = [self menuFrame];
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        weakSelf.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)dismiss:(BOOL)animate
{
    if (!animate)
    {
        [self removeMenu];
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        weakSelf.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [weakSelf removeMenu];
    }];
}

#pragma mark - Private Methods
- (CGRect)menuFrame
{
    CGRect frame = CGRectZero;
    frame.size.height = [_titles count] * ROW_HEIGHT + ARROW_HEIGHT;
    
    for (NSString *title in _titles)
    {
        CGFloat width = [self widthOfTitle:title];
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([_titles count] == [_images count])
        frame.size.width = 15.0f + 25.0f + 15.0f + frame.size.width + 20.0f;
    else
        frame.size.width = 15.0f + frame.size.width + 20.0f;
    
    frame.origin.x = SCREEN_WIDTH - frame.size.width;
    frame.origin.y = STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT - 10.0f;
    
    return frame;
}

- (void)initMenu
{
    CGRect rect      = self.frame;
    rect.origin.x    = 0.0f;
    rect.origin.y    = ARROW_HEIGHT;
    rect.size.width  -= SPACE * 2;
    rect.size.height -= ARROW_HEIGHT;
    
    _menu                                = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _menu.dataSource                     = self;
    _menu.delegate                       = self;
    _menu.scrollEnabled                  = NO;
    _menu.showsHorizontalScrollIndicator = NO;
    _menu.showsVerticalScrollIndicator   = NO;
    _menu.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    _menu.backgroundColor                = _menuColor;
    _menu.layer.cornerRadius             = 3.0f;
    
    [self addSubview:_menu];
}

- (void)dismiss
{
    [self dismiss:YES];
}

- (void)removeMenu
{
    [_menu removeFromSuperview];
    [self removeFromSuperview];
    [_window removeFromSuperview];
    _menu   = nil;
    _titles = nil;
    _images = nil;
    _window = nil;
    _block  = nil;
}

- (CGFloat)widthOfTitle:(NSString *)title
{
    NSDictionary *attributes = @{NSFontAttributeName: TITLE_FONT};
    return [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20.0f, ROW_HEIGHT) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMoreMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SCMoreMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell displayCellWithTitles:_titles images:_images index:indexPath.row];
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block)
        _block(indexPath.row);
    [self dismiss:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) ? NO : YES;
}

@end
