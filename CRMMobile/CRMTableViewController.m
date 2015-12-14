//
//  CRMTableViewController.m
//  CRMMobile
//
//  Created by gwb on 15/10/23.
//  Copyright (c) 2015年 dagong. All rights reserved.
//
#import "TaskRecordsTableViewController.h"
#import "CRMTableViewController.h"
#import "CustomerInformationTableViewController.h"
#import "CustomerCallPlanViewController.h"
#import "SaleOppTableViewController.h"
#import "CustomercontactTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "saleLeadsTableViewController.h"
#import "MarketManagementViewController.h"
@interface CRMTableViewController ()
@property (strong,nonatomic) NSArray        *authTableDataCount;
@end

@implementation CRMTableViewController
@synthesize CRMListData;


-(NSArray *)authTableDataCount{
    if(!_authTableDataCount){
        NSMutableArray  *tablecount  = [[NSMutableArray alloc] init];
        NSString        *path        = [[NSBundle mainBundle]pathForResource:@"CRM.plist" ofType:nil];
        NSMutableArray  *data        = [NSMutableArray arrayWithContentsOfFile:path];
        for(int i=0;i<[data count];i++){
            NSString *indexName=[[data objectAtIndex:i] objectForKey:@"authorityname"];
            NSString *authname=[APPDELEGATE.roleAuthority objectForKey:indexName];
            int countForN=[self numberOfCharaterInString:authname characterToCount:@"N"];
                if(countForN != authname.length){
                    [tablecount addObject:[data objectAtIndex:i]];
                }
        }
        _authTableDataCount=[tablecount copy];
    }
    return  _authTableDataCount;
}

-(int) numberOfCharaterInString:(NSString *)stringToCount characterToCount:(NSString *) character{
    int numberPoint = 0;
    
    for (int i = 0; i<stringToCount.length; i++)
    {
        NSString * temp = [stringToCount substringWithRange:NSMakeRange(i, 1)];
        
        if ([temp isEqualToString:character])
        {
            numberPoint ++;
        }
    }
    return  numberPoint;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:NAVBLUECOLOR];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.tableFooterView=[[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.authTableDataCount count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *item = [self.authTableDataCount objectAtIndex:indexPath.row];
    [cell.textLabel setText:[item objectForKey:@"Name"]];
    [cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"Image"]]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [self.authTableDataCount objectAtIndex:indexPath.row];
    NSString *authid=[item objectForKey:@"authorityname"];
    if([authid isEqualToString:@"kehudangan"]){
        CustomerInformationTableViewController *fltv= [[CustomerInformationTableViewController alloc] init];
        fltv.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController: fltv animated:YES];
    }else if([authid isEqualToString:@"kehulianxiren"]){
        CustomercontactTableViewController *customercontact = [[CustomercontactTableViewController alloc]init];
        customercontact.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController: customercontact animated:YES];
    }else if([authid isEqualToString:@"baifangjihua"]){
        CustomerCallPlanViewController *fltv=[[CustomerCallPlanViewController alloc] init];
        fltv.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController: fltv animated:YES];
        
    }else if([authid isEqualToString:@"baifangjilu"]){
        TaskRecordsTableViewController *fltv=[[TaskRecordsTableViewController alloc] init];
        fltv.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController: fltv animated:YES];
    }else if([authid isEqualToString:@"xiaoshouxiansuo"]){
        saleLeadsTableViewController *saleLeads = [[saleLeadsTableViewController alloc] init];
        saleLeads.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:saleLeads animated:YES];
    }else if([authid isEqualToString:@"xiaoshoujihui"]){
        SaleOppTableViewController *saleopp= [[SaleOppTableViewController alloc] init];
         saleopp.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController: saleopp animated:YES];
    }else if([authid isEqualToString:@"huodongtongji"]){
        MarketManagementViewController *marketManagement= [[MarketManagementViewController alloc] init];
        [self.navigationController pushViewController: marketManagement animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
