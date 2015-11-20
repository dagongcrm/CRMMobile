//
//  editTaskViewController.h
//  CRMMobile
//
//  Created by zhang on 15/11/11.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#import "submitTaskEntity.h"
#import "selectEntity.h"

@interface editTaskViewController : UIViewController<ZSYPopoverListDatasource, ZSYPopoverListDelegate>{
    NSArray *nextArray;
}
@property (retain ,nonatomic)       selectEntity *roleEntity;
@property ( retain , nonatomic ) submitTaskEntity *submitTaskEntity;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPicker;
@property (strong,nonatomic) IBOutlet UIPickerView *selectPickerQiYe;

@end
