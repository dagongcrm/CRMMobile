//
//  AddCustomerCallPlanViewController.h
//  CRMMobile
//
//  Created by yd on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#import "CustomerCallPlanDetailMessageEntity.h"

@interface AddCustomerCallPlanViewController : UIViewController
@property (strong,nonatomic) NSArray *nextArray;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;

@property CustomerCallPlanDetailMessageEntity *customerCallPlanEntity;

@end
