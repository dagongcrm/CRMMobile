//
//  WorkTableViewController.m
//  CRMMobile
//
//  Created by gwb on 15/10/23.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "WorkTableViewController.h"
#import "AppDelegate.h"
#import "TaskReportTableViewController.h"
#import "SubmitTableViewController.h"
#import "auditTableViewController.h"
#import "trackingTableViewController.h"
#import "AppDelegate.h"
#import "config.h"

@interface WorkTableViewController ()
@property (strong,nonatomic) UINavigationController *iNav;
@property (strong,nonatomic) NSArray        *authTableDataCount;
@end

@implementation WorkTableViewController
@synthesize WorkListData;


-(NSArray *)authTableDataCount{
    if(!_authTableDataCount){
        NSMutableArray  *tablecount  = [[NSMutableArray alloc] init];
        NSString        *path        = [[NSBundle mainBundle]pathForResource:@"Work.plist" ofType:nil];
        NSMutableArray  *data        = [NSMutableArray arrayWithContentsOfFile:path];
        for(int i=0;i<[data count];i++){
            NSString *indexName=[[data objectAtIndex:i] objectForKey:@"authorityname"];
            if(![[APPDELEGATE.roleAuthority objectForKey:indexName]rangeOfString:@"N"].length>0){
                [tablecount addObject:[data objectAtIndex:i]];
            }
        }
        _authTableDataCount=[tablecount copy];
    }
    return  _authTableDataCount;
}



- (void)viewDidLoad {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"Work.plist" ofType:nil];
    WorkListData= [NSMutableArray arrayWithContentsOfFile:dataPath];
    self.tableView.tableFooterView=[[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [self.authTableDataCount objectAtIndex:indexPath.row];
    [cell.textLabel setText:[item objectForKey:@"Name"]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.WorkListData count];
    return [self.authTableDataCount count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        TaskReportTableViewController *fltv = [[TaskReportTableViewController alloc] init];
        [self.navigationController pushViewController:fltv animated:YES];
    }else if(indexPath.row==1){
        SubmitTableViewController *sub = [[SubmitTableViewController alloc] init];
        [self.navigationController pushViewController:sub animated:YES];
    }else if(indexPath.row==2){
        auditTableViewController *audit = [[auditTableViewController alloc] init];
        [self.navigationController pushViewController:audit animated:YES];
    }else if(indexPath.row==3){
        trackingTableViewController *track = [[trackingTableViewController alloc] init];
        [self.navigationController pushViewController:track animated:YES];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end
