//
//  CustomerCallPlanEditViewController.h
//  CRMMobile
//
//  Created by yd on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerCallPlanDetailMessageEntity.h"

@interface CustomerCallPlanEditViewController : UIViewController
@property ( retain , nonatomic ) CustomerCallPlanDetailMessageEntity *customerCallPlanEntity;

@property (strong,nonatomic) NSArray *nextArray;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;


@end
