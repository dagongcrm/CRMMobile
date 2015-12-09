//
//  PlanDetalViewController.h
//  CRMMobile
//
//  Created by peng on 15/11/6.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitPlanNsObj.h"
#import "CustomerCallPlanDetailMessageEntity.h"
@interface PlanDetalViewController : UIViewController
@property (strong,nonatomic) VisitPlanNsObj *DailyEntity;
@property ( retain , nonatomic ) CustomerCallPlanDetailMessageEntity *customerCallPlanEntity;
@end
