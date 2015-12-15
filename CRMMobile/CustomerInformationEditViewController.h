//
//  CustomerInformationEditViewController.h
//  CRMMobile
//
//  Created by yd on 15/11/4.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfermationDetailMessageEntity.h"
#import "ZSYPopoverListView.h"
#import "ZSYPopoverListViewSingle.h"

@interface CustomerInformationEditViewController : UIViewController<ZSYPopoverListDatasourceSingle, ZSYPopoverListDelegateSingle,ZSYPopoverListDatasource,ZSYPopoverListDelegate>
@property ( retain , nonatomic ) CustomerInfermationDetailMessageEntity *customerInformationEntity;
@property (strong,nonatomic) NSArray *nextArray;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;

@end
