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

@interface NotificationTableViewController ()

@end

@implementation NotificationTableViewController
@synthesize NotificationListData;

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [super viewDidLoad];
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        NSLog(@"fffffffff");
        taskReminderTableViewController *tr = [[taskReminderTableViewController alloc] init];
        [self.navigationController pushViewController:tr animated:YES];
    }else if(indexPath.row == 1){
        NSLog(@"ffffffffferji");
        //NoticeTableViewController *view = [[NoticeTableViewController alloc]init];
        NoticeViewController *view = [[NoticeViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end
