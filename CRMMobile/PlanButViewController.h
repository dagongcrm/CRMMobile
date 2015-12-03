//
//  PlanButViewController.h
//  CRMMobile
//
//  Created by peng on 15/11/20.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitPlanNsObj.h"
#import "AddCustomerEntity.h"
#import "CostomerContactEntity.h"
@interface PlanButViewController : UIViewController
@property CostomerContactEntity *customerEntity;
@property AddCustomerEntity *addCustomerEntity;
@property (strong,nonatomic)NSString *context;
@end
