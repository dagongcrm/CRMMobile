//
//  VisitPlanTableViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/4.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "IndexViewController.h"
#import "GLReusableViewController.h"
#import "PlanDetalViewController.h"
#import "VisitPlanNsObj.h"
#import "CustomerCallPlanDetailMessageEntity.h"
#import "VisitPlanTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "UIImage+Tint.h"
#import "MJRefresh.h"
#import "HttpHelper.h"
#import "NStringUtil.h"
#import "VisitPlanTableViewCell.h"
#import "AddCustomerCallPlanViewController.h"

@interface VisitPlanTableViewController ()
@property (strong, nonatomic) NSMutableArray *fakeData;  //拜访计划数组
@property (strong, nonatomic) NSMutableArray *customerCallPlanID;   //客户id数组
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong, nonatomic) NSMutableDictionary *uCustomerCallPlanID;
@property (strong, nonatomic) NSMutableArray *visitDate;//拜访时间
@property (strong, nonatomic) NSMutableArray *respondent;
@property (strong, nonatomic) NSMutableArray *visitorData;//拜访人
@property  NSInteger  index;

@end

@implementation VisitPlanTableViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.customerCallPlanID = [NSMutableArray array];
        self.visitDate = [[NSMutableArray alloc]init];
        self.respondent=[[NSMutableArray alloc]init];
        self.visitorData = [[NSMutableArray alloc]init];
        [self faker:@"1"];
    }
    return _fakeData;
}

-(void) viewWillAppear:(BOOL)animated{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.fakeData removeAllObjects];
        [self.customerCallPlanID removeAllObjects];
        [self.visitDate removeAllObjects];
        [self.respondent removeAllObjects];
        [self.visitorData removeAllObjects];
        self.index =1;
        [self faker:@"1"];
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"拜访计划";
    //上拉刷新下拉加在方法
    [self setupRefresh];
    self.uid=[NSMutableArray array];
    //去掉返回的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self  action:nil];
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addUser:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self setExtraCellLineHidden:self.tableView];
}

- (IBAction)addUser:(id)sender
{
    AddCustomerCallPlanViewController *addCustomer = [[AddCustomerCallPlanViewController alloc] init];
    [self.navigationController pushViewController: addCustomer animated:true];
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
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
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
            NSString *teamname2 =[NStringUtil returnStringDepondOnStringLength:[listdic objectForKey:@"visitDate"]];
            NSString *teamname3 =[NStringUtil returnStringDepondOnStringLength:[listdic objectForKey:@"respondent"]];
            
            NSString *baiFangRenStr =[NStringUtil returnStringDepondOnStringLength:[listdic objectForKey:@"visitorStr"]];  //拜访人显示
            if(teamname.length==0){   //若客户名称问null，将其赋值
                teamname=@"没有数据";
            }
            [self.customerCallPlanID     addObject:customerCallPlanID];
            [self.fakeData               addObject:teamname];
            [self.visitDate              addObject:teamname2];
            [self.respondent             addObject:teamname3];
            [self.visitorData            addObject:baiFangRenStr];
        }
    }
    return self.fakeData;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
      return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.fakeData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"visitplan";
    VisitPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VisitPlanTableViewCell" owner:self options:nil]lastObject];
    }
    cell.photo.image = [UIImage imageNamed:@"拜访计划1.png"];
    cell.company.text = self.fakeData[indexPath.row];
    NSString *baifangren=(NSString *)[self.visitorData objectAtIndex:indexPath.row];
    cell.visitor.text = [@"拜访人：" stringByAppendingString:baifangren];
    cell.visitDate.text = [self.visitDate objectAtIndex:indexPath.row];
    
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
        
        PlanDetalViewController *uc =[[PlanDetalViewController alloc] init];
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

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
