//
//  CustomerCallPlanViewController.m
//  CRMMobile
//
//  Created by yd on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CustomerCallPlanViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MJRefresh.h"
#import "CustomerCallPlanDetailMessageEntity.h"
#import "CustomerCallPlanDetailViewController.h"
#import "AddCustomerCallPlanViewController.h"

@interface CustomerCallPlanViewController ()
@property (strong, nonatomic) NSMutableArray *fakeData;  //拜访计划数组
@property (strong, nonatomic) NSMutableArray *customerCallPlanID;   //客户id数组
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong, nonatomic) NSMutableDictionary *uCustomerCallPlanID;

@property  NSInteger  index;

@end

@implementation CustomerCallPlanViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.customerCallPlanID = [NSMutableArray array];
        [self faker:@"1"];
        [self faker:@"2"];
    }
    return _fakeData;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];    //上拉刷新下拉加在方法
    self.uid=[NSMutableArray array];
    
    //添加图标
    [self addPage];
    
    }

//向后台发送请求查询数据
-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@",page,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    if(![list count] ==0)
    {
        
        self.tableView.footerRefreshingText=@"加载中";
    }else
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
    }
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        [self.uid addObject:listdic];
        NSString *teamname = (NSString *)[listdic objectForKey:@"customerNameStr"];//获取客户名称
        NSString *customerCallPlanID=(NSString *)[listdic objectForKey:@"customerCallPlanID"];//获取客户id
        if(teamname.length==0){   //若客户名称问null，将其赋值
            teamname=@"没有数据";
        }
        
        [self.customerCallPlanID     addObject:customerCallPlanID];
        [self.fakeData     addObject:teamname];
        
    }
//    [self customerIDReturn:self.customerCallPlanID];
    return self.fakeData;
}


//-(NSMutableArray *) customerIDReturn: (NSMutableArray *) uidArr
//{
//    return self.customerCallPlanID;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.fakeData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [self.fakeData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[self.fakeData objectAtIndex:indexPath.row]];
    return cell;
}


//上拉刷新下拉加载
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
    self.index=3;
    [self faker:@"1"];
    [self faker:@"2"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if(self.index==0){
        self.index=3;
    }
    self.index=self.index++;
    NSString *p= [NSString stringWithFormat: @"%ld", (long)self.index];
    NSLog(@"%@************",p);
    [self faker:p];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
    
}



//点击列表信息进入详情页面并传值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self customerCallPlanForName:self.fakeData :self.customerCallPlanID];
    
    if (tableView == self.tableView)
    {
        
        NSDictionary *nc =[self singlecustomerCallPlan:(NSString *)[_uCustomerCallPlanID objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
        NSString *customerNameStr  =(NSString *) [nc objectForKey:@"customerNameStr"];  //客户名称
        NSString *customerID  =(NSString *) [nc objectForKey:@"customerID"];  //客户ID
        NSString *customerCallPlanID  =(NSString *) [nc objectForKey:@"customerCallPlanID"];  // 拜访计划id
        NSString *theme  =(NSString *) [nc objectForKey:@"theme"];  //主题
        NSString *accessMethod =(NSString *) [nc objectForKey:@"accessMethod"]; // 访问方式
        NSString *accessMethodStr =(NSString *) [nc objectForKey:@"accessMethodStr"]; // 访问方式显示
        NSString *mainContent =(NSString *) [nc objectForKey:@"mainContent"]; //主要内容
        NSString *respondentPhone =(NSString *) [nc objectForKey:@"respondentPhone"];  //受访人电话
        NSString *respondent =(NSString *) [nc objectForKey:@"respondent"];  //受访人员
        NSString *address =(NSString *) [nc objectForKey:@"address"];  //受访人地址
        NSString *visitProfile =(NSString *) [nc objectForKey:@"visitProfile"];  //拜访概要
        NSString *visitDate =(NSString *) [nc objectForKey:@"visitDate"];  //拜访时间
        NSString *result =(NSString *) [nc objectForKey:@"result"];  //拜访结果
        NSString *customerRequirements =(NSString *) [nc objectForKey:@"customerRequirements"];  //客户需求
        NSString *customerChange =(NSString *) [nc objectForKey:@"customerChange"];  //客户变故
        NSString *visitorAttribution =(NSString *) [nc objectForKey:@"visitorAttribution"];  //拜访人归属
        NSString *visitorAttributionStr =(NSString *) [nc objectForKey:@"visitorAttributionStr"];  //拜访人归属显示
         NSString *baiFangRen =(NSString *) [nc objectForKey:@"visitor"];  //拜访人
         NSString *baiFangRenStr =(NSString *) [nc objectForKey:@"visitorStr"];  //拜访人显示
        
        CustomerCallPlanDetailMessageEntity *udetail =[[CustomerCallPlanDetailMessageEntity alloc] init];
        
        [udetail setCustomerNameStr:customerNameStr];
        [udetail setCustomerID:customerID];
        [udetail setCustomerCallPlanID:customerCallPlanID];
        [udetail setTheme:theme];
        [udetail setAccessMethod:accessMethod];
        [udetail setAccessMethodStr:accessMethodStr];
        [udetail setMainContent:mainContent];
        [udetail setRespondentPhone:respondentPhone];
        [udetail setRespondent:respondent];
        [udetail setAddress:address];
        [udetail setVisitProfile:visitProfile];
        [udetail setVisitDate:visitDate];
        [udetail setResult:result];
        [udetail setCustomerRequirements:customerRequirements];
        [udetail setCustomerChange:customerChange];
        [udetail setVisitorAttribution:visitorAttribution];
        [udetail setVisitorAttributionStr:visitorAttributionStr];
        [udetail setBaiFangRen:baiFangRen];
        [udetail setBaiFangRenStr:baiFangRenStr];
        
        CustomerCallPlanDetailViewController *uc =[[CustomerCallPlanDetailViewController alloc] init];
        [uc setCustomerCallPlanEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
        
        
    }else
    {
       
        
    }
}

// delcare id and index
-(void) customerCallPlanForName:(NSMutableArray *)utestname :(NSMutableArray *)customerCallPlanID{
    _uCustomerCallPlanID = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[utestname count];i++)
    {
        [_uCustomerCallPlanID setObject:[customerCallPlanID objectAtIndex:i] forKey:[utestname objectAtIndex:i]];
    }
}

// get a single user all message
-(NSDictionary *) singlecustomerCallPlan :(NSString *) customerCallPlanIDIn{
    for (int z = 0; z<[self.uid count]; z++) {
        NSDictionary *listdic = [self.uid objectAtIndex:z];
        NSString     *customerCallPlanID  = (NSString *)[listdic objectForKey:@"customerCallPlanID"];
        if([customerCallPlanID isEqualToString: customerCallPlanIDIn])
        {
            return listdic;
        }
    }
    return  nil;
}


//跳转至添加页面
-(void) addPage
{
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addCustomerCallPlan:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
}

- (IBAction)addCustomerCallPlan:(id)sender
{
    AddCustomerCallPlanViewController *jumpController = [[AddCustomerCallPlanViewController alloc] init];
    [self.navigationController pushViewController: jumpController animated:true];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



@end
