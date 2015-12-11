//
//  AddCustomerInformationViewController.h
//  CRMMobile
//
//  Created by yd on 15/11/4.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#include "ZSYPopoverListViewSingle.h"

@interface AddCustomerInformationViewController : UIViewController<ZSYPopoverListDatasourceSingle, ZSYPopoverListDelegateSingle,ZSYPopoverListDatasource,ZSYPopoverListDelegate>


//@property (strong,nonatomic) options *options;
@property (strong,nonatomic) NSArray *nextArray;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;

@end
