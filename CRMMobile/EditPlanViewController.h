//
//  EditPlanViewController.h
//  CRMMobile
//
//  Created by peng on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CostomerContactEntity.h"
#import "AddCustomerEntity.h"
#import "CostomerContactEntity.h"
#import "CustomerCallPlanDetailMessageEntity.h"
@interface EditPlanViewController : UIViewController
@property (strong,nonatomic)AddCustomerEntity *addCustomerEntity;
@property CostomerContactEntity *customerEntity;
@property (strong,nonatomic) NSArray *nextArray;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;
@property ( retain , nonatomic ) CustomerCallPlanDetailMessageEntity *customerCallPlanEntity;
@end
