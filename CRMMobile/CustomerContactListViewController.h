//
//  CustomerContactListViewController.h
//  CRMMobile
//
//  Created by why on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CostomerContactEntity.h"
#import "VisitPlanNsObj.h"
#import "AddCustomerEntity.h"
#import "CustomerCallPlanDetailMessageEntity.h"

@interface CustomerContactListViewController : UITableViewController
@property(strong,nonatomic)CostomerContactEntity *customerEntity;
@property(strong,nonatomic)AddCustomerEntity *addCustomerEntity;
@property (strong,nonatomic) VisitPlanNsObj *dailyEntity;
@end
