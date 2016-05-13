//
//  NotificationTableViewController.m
//  CRMMobile
//
//  Created by gwb on 15/10/23.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "NotificationTableViewController.h"
#import "NoticeTableViewController.h"
#import "taskReminderTableViewController.h"
#import "GLReusableViewController.h"
#import "PureLayout.h"
#import "NoticeViewController.h"
#import "AppDelegate.h"
#import "config.h"
@interface NotificationTableViewController ()

@end

@implementation NotificationTableViewController
@synthesize NotificationListData;

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"Notification.plist" ofType:nil];
    NotificationListData= [NSMutableArray arrayWithContentsOfFile:dataPath];
    [self setExtraCellLineHidden:self.tableView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [NotificationListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [NotificationListData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[item objectForKey:@"Name"]];
    [cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"Image"]]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        NSLog(@"fffffffff");
        taskReminderTableViewController *tr = [[taskReminderTableViewController alloc] init];
        tr.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:tr animated:YES];
    }else if(indexPath.row == 1){
        NSLog(@"ffffffffferji");
        NoticeViewController *view = [[NoticeViewController alloc] init];
        view.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:view animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
        return 50;
    }else{
        return 60;
    }
}
@end
