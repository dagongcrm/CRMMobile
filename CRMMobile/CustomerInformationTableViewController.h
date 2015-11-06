//
//  CustomerInformationTableViewController.h
//  CRMMobile
//  
//  Created by yd on 15/10/27.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInformationTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray *CRMListData;
}
@property (nonatomic,retain) NSArray *CRMListData;

@end
