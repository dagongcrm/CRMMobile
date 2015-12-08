//
//  TaskReportTableViewController.m
//  CRMMobile
//
//  Created by peng on 15/10/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "TaskReportTableViewController.h"
#import "AppDelegate.h"
#import "DailyTableViewController.h"
#import "WeekTableViewController.h"
#import "MonthTableViewController.h"
@interface TaskReportTableViewController ()
@property (strong,nonatomic) UINavigationController *iNav;
@end

@implementation TaskReportTableViewController
@synthesize taskReportListData;//数
@synthesize refresh;//刷新
@synthesize tableview;//表
@synthesize timeArray;//数组
- (void)viewDidLoad {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [super viewDidLoad];
    self.title = @"工作报告";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.timeArray = [[NSMutableArray alloc]init];
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"taskReport.plist" ofType:nil];
    taskReportListData= [NSMutableArray arrayWithContentsOfFile:dataPath];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [taskReportListData objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:@"bao1"]];
    [cell.textLabel setText:[item objectForKey:@"Name"]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    return [self.taskReportListData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        DailyTableViewController *fltv = [[DailyTableViewController alloc] init];
        [self.navigationController pushViewController:fltv animated:YES];
    }else if(indexPath.row==1){
        WeekTableViewController *week = [[WeekTableViewController alloc] init];
        [self.navigationController pushViewController:week animated:YES];
    }else if(indexPath.row==2){
        MonthTableViewController *month = [[MonthTableViewController alloc]init];
        [self.navigationController pushViewController:month animated:YES];
    }
}

@end
