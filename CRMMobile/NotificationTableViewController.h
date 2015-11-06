//
//  NotificationTableViewController.h
//  CRMMobile
//
//  Created by gwb on 15/10/23.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *NotificationListData;          
}
@property (nonatomic,retain) NSArray *NotificationListData;
@end
