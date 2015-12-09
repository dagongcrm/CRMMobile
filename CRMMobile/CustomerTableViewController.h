//
//  CustomerTableViewController.h
//  CRMMobile
//
//  Created by peng on 15/11/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitPlanNsObj.h"
#import "AddCustomerEntity.h"
#import "CustomerCallPlanDetailMessageEntity.h"
@interface CustomerTableViewController : UITableViewController

@property(strong,nonatomic)AddCustomerEntity *addCustomerEntity;
@property (strong,nonatomic) VisitPlanNsObj *dailyEntity;
@property ( retain , nonatomic ) CustomerCallPlanDetailMessageEntity *customerCallPlanEntity;
@end
