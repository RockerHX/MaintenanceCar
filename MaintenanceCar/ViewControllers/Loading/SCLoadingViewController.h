//
//  SCLoadingViewController.h
//  BigCentral
//
//  Created by Kevin Mindeguia on 19/11/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCActivityIndicator.h"

@protocol SCLoadingViewControllerDelegate <NSObject>

@optional
- (void)retryRequest;

@end

@interface SCLoadingViewController : UIViewController

@property (weak, nonatomic) IBOutlet            UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet              UIView *errorView;
@property (weak, nonatomic) IBOutlet              UIView *noContentView;
@property (weak, nonatomic) IBOutlet SCActivityIndicator *activityIndicatorView;
@property (weak, nonatomic) IBOutlet              UIView *loadingView;

@property (weak, nonatomic) id <SCLoadingViewControllerDelegate>delegate;

- (IBAction)retryButtonPressed;

- (void)showLoadingView;
- (void)hiddenLoadingView;
- (void)showNoContentView;
- (void)showErrorView;

@end
