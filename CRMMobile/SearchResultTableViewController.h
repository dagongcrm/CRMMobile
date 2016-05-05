//
//  SearchResultTableViewController.h
//  CRMMobile
//
//  Created by 刘国江 on 16/5/5.
//  Copyright © 2016年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SearchResultTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,retain) NSArray *CRMListData;
@property (nonatomic,retain) NSString *searchCondation;
@end
