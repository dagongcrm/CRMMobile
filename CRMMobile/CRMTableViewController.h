//
//  CRMTableViewController.h
//  CRMMobile
//   
//  Created by gwb on 15/10/23.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRMTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *CRMListData;
}
@property (nonatomic,retain) NSArray *CRMListData;
@end
