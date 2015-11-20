//
//  EditPlanViewController.h
//  CRMMobile
//
//  Created by peng on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitPlanNsObj.h"
#import "CostomerContactEntity.h"
@interface EditPlanViewController : UIViewController
@property (strong,nonatomic) VisitPlanNsObj *DailyEntity;
@property(strong,nonatomic) CostomerContactEntity *contactEntity;
@end
