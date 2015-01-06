//
//  SCMapViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKMapView;

@interface SCMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

- (IBAction)listItemPressed:(UIBarButtonItem *)sender;

@end
