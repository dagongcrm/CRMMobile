//
//  CRMTableViewController.m
//  CRMMobile
//
//  Created by gwb on 15/10/23.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CRMTableViewController.h"
#import "CustomerInformationTableViewController.h"
#import "CustomerCallPlanViewController.h"
#import "SaleOppTableViewController.h"

@interface CRMTableViewController ()

@end

@implementation CRMTableViewController
@synthesize CRMListData;

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [super viewDidLoad];
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"CRM.plist" ofType:nil];
    CRMListData= [NSMutableArray arrayWithContentsOfFile:dataPath];
    [self setExtraCellLineHidden:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [CRMListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [CRMListData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[item objectForKey:@"Name"]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        CustomerInformationTableViewController *fltv= [[CustomerInformationTableViewController alloc] init];
        fltv.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController: fltv animated:YES];
    }else if(indexPath.row==1){
        
    }else if(indexPath.row==2){
        CustomerCallPlanViewController *fltv=[[CustomerCallPlanViewController alloc] init];
        fltv.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController: fltv animated:YES];
        
    }else if(indexPath.row==3){
        
    }else if(indexPath.row==4){
        
    }else if(indexPath.row==5){
        SaleOppTableViewController *saleopp= [[SaleOppTableViewController alloc] init];
        [self.navigationController pushViewController: saleopp animated:YES];
    }else if(indexPath.row==6){
        
    }
}


@end
