//
//  SCWebViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@interface SCWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, copy) NSString *loadURL;

@end