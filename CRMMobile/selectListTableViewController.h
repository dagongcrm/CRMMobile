//
//  selectListTableViewController.h
//  CRMMobile
//
//  Created by zhang on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "selectEntity.h"

@interface selectListTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray *CRMListData;
}
@property (nonatomic,retain) NSArray *CRMListData;
@property (retain ,nonatomic)       selectEntity *roleEntity;
@end
