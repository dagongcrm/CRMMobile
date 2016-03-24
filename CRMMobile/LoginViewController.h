//
//  LoginViewController.h
//  Ratings
//   
//  Created by gwb on 15/8/3.
//  Copyright (c) 2015年 gwb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface LoginViewController : UIViewController
@property (strong,nonatomic)  IBOutlet UITextField *accountField;
@property (strong,nonatomic)  IBOutlet UITextField *passwdField;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAMapView *mapView;

@end
