//
//  TaskReportTableViewController.h
//  CRMMobile
//
//  Created by peng on 15/10/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskReportTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray *taskReportListData;
    NSMutableArray *timeArray;
    UIRefreshControl *refresh;
}
@property (nonatomic,retain)  NSArray *taskReportListData;
@property (strong,nonatomic)  NSMutableArray *timeArray;
@property (strong,nonatomic)  UIRefreshControl *refresh;
@property (strong,nonatomic)  IBOutlet UITableView *tableview;
@property (strong,nonatomic)  UIWindow *window;
@end
