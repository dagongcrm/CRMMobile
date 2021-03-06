//
//  CustomerContactListViewController.m
//  CRMMobile
//
//  Created by why on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "PlanButViewController.h"
#import "EditPlanViewController.h"
#import "CustomerContactListViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "EditCustomerContactController.h"
#import "AddCustomerContactController.h"
#import "AddCustomerCallPlanViewController.h"
#import "CustomerCallPlanEditViewController.h"
#import "AddSaleOppViewController.h"
#import "EditSaleOppViewController.h"
#import "addSaleLeadsViewController.h"
#import "saleLeads.h"

@interface CustomerContactListViewController ()
@property (strong, nonatomic) NSMutableArray *fakeData;//用户联系人名称
@property (strong, nonatomic) NSMutableArray *customerIDData;
@property (strong, nonatomic) NSMutableArray *industryIDStrData;//用户联系人名称
@property  NSInteger index;
@property  UIViewController *uiview;
@end

@implementation CustomerContactListViewController
@synthesize customerEntity=_customerEntity;
@synthesize addCustomerEntity =_addCustomerEntity;
@synthesize CustomerCallPlanEntity =_customerCallPlanEntity;   //客户拜访计划
@synthesize saleOppEntity =_saleOppEntity;   //销售机会
@synthesize saleLeads =_saleLeads;   //销售线索
@synthesize dailyEntity =_dailyEntity;
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.customerIDData = [[NSMutableArray alloc]init];
        self.industryIDStrData = [[NSMutableArray alloc]init];
        [self faker:@"1"];
//        [self faker:@"2"];
    }
    return _fakeData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"客户列表";
    [self setupRefresh];
    NSLog(@"123123123123123132%@",_addCustomerEntity.contactName);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self  action:nil];

//    [self faker:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
    self.index =1;
    [self faker:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if(self.index==0){
        self.index=2;
    }else{
        self.index++;
    }
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
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
    NSDictionary *listDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"listDic字典里面的内容为--》%@", listDic);
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
        NSLog(@"industryIDStr////////%@",industryIDStr);
    }
    }
    return self.fakeData;
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
    [cell.imageView setImage:[UIImage imageNamed:@"gongsi"]];
    cell.textLabel.text = self.fakeData[indexPath.row];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"所属行业:" stringByAppendingString:(NSString *)[self.industryIDStrData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText:testDetail];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *index = _customerEntity.index;
    NSString *customerID = [self.customerIDData objectAtIndex:indexPath.row];
    if ([index isEqualToString:@"1"]) {
        EditCustomerContactController *editCustomer = [[EditCustomerContactController alloc]init];
        NSString *customerName=[self.fakeData objectAtIndex:indexPath.row];
        [_customerEntity setCustomerName:customerName];
        [_customerEntity setCustomerID:customerID];
        //    _customerEntity.customerName = customerName;
        [editCustomer setContactEntity:_customerEntity];
        [self.navigationController pushViewController:editCustomer animated:YES];
    }
    if ([index isEqualToString:@"2"]){
        AddCustomerContactController *AddCustomer =[[AddCustomerContactController alloc]init];
        NSString *customerName1=[self.fakeData objectAtIndex:indexPath.row];
        NSLog(@"sxccxcxcxcccxcxcxc%@",customerName1);
//        NSString *customerID = [self.customerIDData objectAtIndex:indexPath.row];
//        _addCustomerEntity = [[AddCustomerEntity alloc]init];
        [_addCustomerEntity setCustomerID:customerID];
        NSLog(@"777777777%@",_addCustomerEntity.contactName);
        [AddCustomer setContext:customerName1];
        [AddCustomer setAddCustomerEntity:_addCustomerEntity];
        [self.navigationController pushViewController:AddCustomer animated:YES];
    }
    if ([index isEqualToString:@"3"]) {
        EditPlanViewController *editCustomer3 = [[EditPlanViewController alloc]init];
        NSString *customerName3=[self.fakeData objectAtIndex:indexPath.row];
        [_dailyEntity setCustomerNameStr:customerName3];
        //    _customerEntity.customerName = customerName;
        [editCustomer3 setCustomerCallPlanEntity:_customerCallPlanEntity];
        [self.navigationController pushViewController:editCustomer3 animated:YES];
    }else if([_customerCallPlanEntity.index isEqualToString:@"addCustomerCallPlan"]){   //客添加户拜访纪录中添加客户名称
        NSString *customerName1=[self.fakeData objectAtIndex:indexPath.row];
        NSString *customerID = [self.customerIDData objectAtIndex:indexPath.row];
        [_customerCallPlanEntity setCustomerID:customerID ];
        [_customerCallPlanEntity setCustomerNameStr:customerName1 ];
        AddCustomerCallPlanViewController *addCustomerCallPlan=[[AddCustomerCallPlanViewController alloc]init];
        [addCustomerCallPlan setCustomerCallPlanEntity:_customerCallPlanEntity];
        [self.navigationController pushViewController:addCustomerCallPlan animated:YES];
    }else if([_customerCallPlanEntity.index isEqualToString:@"editCustomerCallPlan"]){   //修改客户拜访纪录中添加客户名称
        NSString *customerName1=[self.fakeData objectAtIndex:indexPath.row];
        NSString *customerID = [self.customerIDData objectAtIndex:indexPath.row];
        [_customerCallPlanEntity setCustomerID:customerID ];
        [_customerCallPlanEntity setCustomerNameStr:customerName1 ];
        CustomerCallPlanEditViewController *editCustomerCallPlan=[[CustomerCallPlanEditViewController alloc]init];
        [editCustomerCallPlan setCustomerCallPlanEntity:_customerCallPlanEntity];
        [self.navigationController pushViewController:editCustomerCallPlan animated:YES];
    }else if([_saleOppEntity.index isEqualToString:@"addSaleOpp"]){   //添加销售机会中添加客户名称
        NSString *customerName1=[self.fakeData objectAtIndex:indexPath.row];
        NSString *customerID = [self.customerIDData objectAtIndex:indexPath.row];
        [_saleOppEntity setCustomerName:customerID ];
        [_saleOppEntity setCustomerNameStr:customerName1 ];
        AddSaleOppViewController *addSaleOpp=[[AddSaleOppViewController alloc]init];
        [addSaleOpp setSaleOppEntity:_saleOppEntity];
        [self.navigationController pushViewController:addSaleOpp animated:NO];
    }else if([_saleOppEntity.index isEqualToString:@"editSaleOpp"]){   //修改销售机会中添加客户名称
        NSString *customerName1=[self.fakeData objectAtIndex:indexPath.row];
        NSString *customerID = [self.customerIDData objectAtIndex:indexPath.row];
        [_saleOppEntity setCustomerName:customerID ];
        [_saleOppEntity setCustomerNameStr:customerName1 ];
        EditSaleOppViewController *editSaleOpp=[[EditSaleOppViewController alloc]init];
        [editSaleOpp setSaleOppEntity:_saleOppEntity];
        [self.navigationController pushViewController:editSaleOpp animated:YES];
    }else if([_saleLeads.index isEqualToString:@"addSaleLeads"]){   //添加销售线索中添加客户名称
        NSString *customerName1=[self.fakeData objectAtIndex:indexPath.row];
        NSString *customerID = [self.customerIDData objectAtIndex:indexPath.row];
        [_saleLeads setCustomerID:customerID ];
        [_saleLeads setCustomerNameStr:customerName1 ];
        addSaleLeadsViewController *addSaleLeads = [[addSaleLeadsViewController alloc] init];
        [addSaleLeads setSaleLeads:_saleLeads];
        [self.navigationController pushViewController:addSaleLeads animated:YES];
    }else if([_saleLeads.index isEqualToString:@"editSaleLeads"]){   //添加销售线索中添加客户名称
        NSString *customerName1=[self.fakeData objectAtIndex:indexPath.row];
        NSString *customerID = [self.customerIDData objectAtIndex:indexPath.row];
        [_saleLeads setCustomerID:customerID ];
        [_saleLeads setCustomerNameStr:customerName1 ];
        addSaleLeadsViewController *addSaleLeads = [[addSaleLeadsViewController alloc] init];
        [addSaleLeads setSaleLeads:_saleLeads];
        [self.navigationController pushViewController:addSaleLeads animated:YES];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
        return 50;
    }else{
        return 60;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}
@end
