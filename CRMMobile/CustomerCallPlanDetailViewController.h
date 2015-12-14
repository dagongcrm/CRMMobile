//
//  CustomerCallPlanDetailViewController.h
//  CRMMobile
//
//  Created by yd on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerCallPlanDetailMessageEntity.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface CustomerCallPlanDetailViewController : UIViewController
@property ( retain , nonatomic ) CustomerCallPlanDetailMessageEntity *customerCallPlanEntity;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end
