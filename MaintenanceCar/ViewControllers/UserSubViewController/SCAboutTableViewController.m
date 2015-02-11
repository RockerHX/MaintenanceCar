//
//  SCAboutTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAboutTableViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"

@interface SCAboutTableViewController () <UIAlertViewDelegate>
{
    NSDictionary *_updateInfo;
}

@end

@implementation SCAboutTableViewController

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

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateInfo[@"path"]]];
}

@end
