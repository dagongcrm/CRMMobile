//
//  VisitPlanTableViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/4.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddPlanViewController.h"
#import "GLReusableViewController.h"
#import "PlanDetalViewController.h"
#import "VisitPlanNsObj.h"
#import "VisitPlanTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "UIImage+Tint.h"
#import "MJRefresh.h"

@interface VisitPlanTableViewController (){
    UISearchDisplayController *mySearchDisplayController;
}
@property (strong, nonatomic) NSMutableArray *customerCallPlanID;//id
@property (strong, nonatomic) NSMutableArray *fakeData;//客户名称
@property (strong, nonatomic) NSMutableArray *visitDate;//拜访时间
@property (strong, nonatomic) NSMutableArray *theme;//主题
@property (nonatomic, strong) NSMutableArray *userName;
@property  NSInteger index;
@end

@implementation VisitPlanTableViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        [self faker:@"1"];
    }
    return _fakeData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];    //上拉刷新下拉加在方法
    self.title=@"拜访计划";
    self.userName=[NSMutableArray array];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    self.tableView.tableHeaderView = searchBar;
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addUser:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    [self setExtraCellLineHidden:self.tableView];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"可复用" style:UIBarButtonItemStyleDone	 target:self action:@selector(ResView)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage imageNamed:@"back001"] imageWithTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0, 0, 20, 20);
    //[button setImageEdgeInsets:UIEdgeInsetsMake(-10, -30, -6, -30)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ResView) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -5;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,rightItem];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
}
- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[GLReusableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (IBAction)addUser:(id)sender
{
    AddPlanViewController *jumpController = [[AddPlanViewController alloc] init];
    [self.navigationController pushViewController: jumpController animated:true];
}
-(NSMutableArray *) faker: (NSString *) page{
    self.customerCallPlanID = [[NSMutableArray alloc]init];
    self.fakeData = [[NSMutableArray alloc]init];
    self.visitDate = [[NSMutableArray alloc]init];
    self.theme = [[NSMutableArray alloc]init];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!datagrid.action"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"time";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&order=%@&sort=%@",sid,order,sort];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"tytytytytyty=====>>>>>>%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    if(![list count] ==0)//
    {
        
        self.tableView.footerRefreshingText=@"加载中";
    }else
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
    }
    for (int i = 0; i<[list count]; i++) {
        
        NSDictionary *listDic =[list objectAtIndex:i];
        [self.userName addObject:listDic];
        
        NSString *teamname = (NSString *)[listDic objectForKey:@"customerNameStr"];
        NSString *teamname1 = (NSString *)[listDic objectForKey:@"customerCallPlanID"];
        NSString *teamname2 = (NSString *)[listDic objectForKey:@"visitDate"];
        NSString *teamname3 = (NSString *)[listDic objectForKey:@"theme"];
        //NSLog(@"%@",teamname);
        if (teamname == nil) {
            teamname = @"fff";
        }
        [self.fakeData addObject:teamname];
        [self.customerCallPlanID addObject:teamname1];
        [self.visitDate addObject:teamname2];
        [self.theme addObject:teamname3];
        
    }
    
    return self.fakeData;
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.fakeData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.fakeData[indexPath.row];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"拜访时间:" stringByAppendingString:(NSString *)[self.visitDate objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText:testDetail];
    return cell;
    
}
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
    NSLog(@"***************************************");
    [self.fakeData removeAllObjects];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.index =2;
    [self faker:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    NSLog(@"------------------------------------------");
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if(myDelegate.index==0){
        myDelegate.index=2;
    }
    self.index=myDelegate.index++;
    NSString *p= [NSString stringWithFormat: @"%ld", (long)self.index];
    NSLog(@"%@************",p);
    //NSLog(p);
    [self faker:p];
    //    [self faker:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *customerCallPlanID =[self.customerCallPlanID objectAtIndex:indexPath.row];
    NSString *customerNameStr  =[self.fakeData objectAtIndex:indexPath.row];
    NSString *visitDate =[self.visitDate objectAtIndex:indexPath.row];
    NSString *theme =[self.theme objectAtIndex:indexPath.row];;
    VisitPlanNsObj *visitPlan =[[VisitPlanNsObj alloc] init];
    [visitPlan setCustomerNameStr:customerNameStr];
    [visitPlan setCustomerCallPlanID:customerCallPlanID];
    [visitPlan setVisitDate:visitDate];
    [visitPlan setTheme:theme];
    PlanDetalViewController *uc =[[PlanDetalViewController alloc] init];
    [uc setDailyEntity:visitPlan];
    [self.navigationController pushViewController:uc animated:YES];

}
@end