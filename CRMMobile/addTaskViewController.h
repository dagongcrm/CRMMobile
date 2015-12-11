//
//  addTaskViewController.h
//  CRMMobile
//
//  Created by zhang on 15/11/2.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#import "selectEntity.h"
#import "ZSYPopoverListViewSingle.h"

@interface addTaskViewController : UIViewController<ZSYPopoverListDatasourceSingle, ZSYPopoverListDelegateSingle,ZSYPopoverListDatasource, ZSYPopoverListDelegate>{
    NSArray *nextArray;
}
@property (retain ,nonatomic)       selectEntity *roleEntity;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPickerQiYe;
@end
