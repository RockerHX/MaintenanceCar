//
//  SCAboutTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAboutTableViewController.h"
#import <UMengAnalytics/MobClick.h>

@interface SCAboutTableViewController ()

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
            [MobClick checkUpdate];         // 检查更新
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/xiu-yang/id960929849?mt=8"]];
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

@end
