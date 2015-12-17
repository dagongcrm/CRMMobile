//
//  CustomerCallPlanEditViewController.h
//  CRMMobile
//
//  Created by yd on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerCallPlanDetailMessageEntity.h"
#import "ZSYPopoverListView.h"
#import "selectEntity.h"
#import "ZSYPopoverListViewSingle.h"

@interface CustomerCallPlanEditViewController : UIViewController<ZSYPopoverListDatasourceSingle, ZSYPopoverListDelegateSingle,ZSYPopoverListDatasource, ZSYPopoverListDelegate>{
    NSArray *nextArray;
}
@property ( retain , nonatomic ) CustomerCallPlanDetailMessageEntity *customerCallPlanEntity;
@property (retain ,nonatomic)       selectEntity *roleEntity;
@property (strong,nonatomic) NSArray *nextArray;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;


@end
