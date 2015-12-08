//
//  CustomerTableViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CustomerTableViewController.h"
#import "PlanButViewController.h"
#import "EditPlanViewController.h"
#import "CustomerContactListViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "EditCustomerContactController.h"
#import "AddCustomerContactController.h"
@interface CustomerTableViewController ()
@property (strong, nonatomic) NSMutableArray *fakeData;//用户联系人名称
@property (strong, nonatomic) NSMutableArray *customerIDData;
@property (strong, nonatomic) NSMutableArray *industryIDStrData;//用户联系人
@property  NSInteger index;
@property  UIViewController *uiview;
@end

@implementation CustomerTableViewController
@synthesize dailyEntity=_dailyEntity;
@synthesize addCustomerEntity =_addCustomerEntity;
@synthesize customerCallPlanEntity=_customerCallPlanEntity;
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.customerIDData = [[NSMutableArray alloc]init];
        self.industryIDStrData = [[NSMutableArray alloc]init];
        [self faker:@"1"];
        [self faker:@"2"];
    }
    return _fakeData;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"客户列表";
    [self setupRefresh];
}
//刷新
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];//下拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];//上拉加载更多
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新中";
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
}

- (void)headerRereshing
{
    [self.fakeData removeAllObjects];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.index =3;
    [self faker:@"1"];
    [self faker:@"2"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if(myDelegate.index==0){
        myDelegate.index=3;
    }
    self.index=myDelegate.index++;
    NSString *p= [NSString stringWithFormat: @"%ld", (long)self.index];
    [self faker:p];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
    
}
-(NSMutableArray *) faker: (NSString *) page{
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerInformationAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    //    NSString *order = @"desc";
    //    NSString *sort = @"time";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@",sid,page];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *listDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //NSLog(@"listDic字典里面的内容为--》%@", listDic);
    NSArray *list = [listDic objectForKey:@"obj"];
    if(![list count] ==0)
    {
        self.tableView.footerRefreshingText=@"加载中";
    }else
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
    }
    
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        NSString *customerName = (NSString *)[listDic objectForKey:@"customerName"];
        NSString *customerID = (NSString *)[listDic objectForKey:@"customerID"];
        NSString *industryIDStr = (NSString *)[listDic objectForKey:@"industryIDStr"];
        if (industryIDStr.length==0) {
            industryIDStr=@"暂无数据";
        }
        [self.fakeData addObject:customerName];
        [self.customerIDData addObject:customerID];
        [self.industryIDStrData addObject:industryIDStr];
        //NSLog(@"industryIDStr////////%@",industryIDStr);
    }
    return self.fakeData;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"arrow-left"]];
    cell.textLabel.text = self.fakeData[indexPath.row];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"所属行业:" stringByAppendingString:(NSString *)[self.industryIDStrData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText:testDetail];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *index = _dailyEntity.index;
    //NSLog(@"pppppppppppp%@",index);
    if ([index isEqualToString:@"1"]) {
        EditPlanViewController *editCustomer = [[EditPlanViewController alloc]init];
        NSString *customerNameStr=[self.fakeData objectAtIndex:indexPath.row];
        [_customerCallPlanEntity setCustomerNameStr:customerNameStr];
        [editCustomer setCustomerCallPlanEntity:_customerCallPlanEntity];
        [self.navigationController pushViewController:editCustomer animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}
@end
