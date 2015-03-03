//
//  SCAboutTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAboutTableViewController.h"
#import "SCWebViewController.h"

#define kADURLKey       @"kADURLKey"

@interface SCAboutTableViewController () <UIAlertViewDelegate>
{
    NSDictionary *_updateInfo;
}

@end

@implementation SCAboutTableViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 关于"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 关于"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [MobClick checkUpdateWithDelegate:self selector:@selector(checekFinish:)];         // 集成友盟更新
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/xiu-yang/id960929849?mt=8"]];
        }
            break;
            
        default:
        {
            NSString *url = [USER_DEFAULT objectForKey:kADURLKey];
            if (!url || ![url length])
                url = [MobClick getAdURL];
            if ([url length])
            {
                @try {
                    SCWebViewController *webViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCWebViewController"];
                    webViewController.title = @"精彩推荐";
                    webViewController.loadURL = url;
                    [self.navigationController pushViewController:webViewController animated:YES];
                }
                @catch (NSException *exception) {
                    NSLog(@"SCAboutTableViewController Go to the SCWebViewController exception reasion:%@", exception.reason);
                }
                @finally {
                    [self performSelectorInBackground:@selector(getURL) withObject:nil];
                }
            }
        }
            break;
    }
}

#pragma mark - Private Methods
- (void)viewConfig
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    _logoImageView.layer.cornerRadius = 30.0f;
    _logoImageView.layer.borderWidth  = 1.0f;
    _logoImageView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    _versionLabel.text = [NSString stringWithFormat:@"修养 %@", version];
}

- (void)checekFinish:(NSDictionary *)info
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    _updateInfo = info;
    
    if ([info[@"update"] boolValue])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本：%@", info[@"version"]]
                                                            message:info[@"update_log"]
                                                           delegate:self
                                                  cancelButtonTitle:@"忽略此版本"
                                                  otherButtonTitles:@"AppStore更新", nil];
        [alertView show];
    }
    else
        ShowPromptHUDWithText(self.view, @"您所安装的是最新版本", 1.0f);
}

- (void)getURL
{
    [USER_DEFAULT setObject:[MobClick getAdURL] forKey:kADURLKey];
    [USER_DEFAULT synchronize];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateInfo[@"path"]]];
}

@end
