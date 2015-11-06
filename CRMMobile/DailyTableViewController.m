//
//  DailyTableViewController.m
//  CRMMobile
//
//  Created by why on 15/11/2.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "DailyTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "TaskReportDailyEntity.h"
#import "DailyViewController.h"
#import "TaskReportTableViewController.h"
#import "AddDailyViewController.h"
#import "UIImage+Tint.h"
#import "MJRefresh.h"

@interface DailyTableViewController (){
    UISearchDisplayController *mySearchDisplayController;
}
@property (strong, nonatomic) NSMutableArray *fakeData;//ribaoleixing daily
@property (strong, nonatomic) NSMutableArray *searchResultsData;
@property (strong, nonatomic) NSMutableArray *workIdData;//ribaoid workStatementActionID
@property (strong, nonatomic) NSMutableDictionary *wordId;//ribaoid
@property (strong,nonatomic) NSMutableArray *dateData;//shijian time
@property (strong,nonatomic) NSMutableArray *dailyObject;
@property (strong,nonatomic) NSMutableArray *typeData;//type
@property (strong,nonatomic) NSMutableArray *reportData;//report
@property  NSInteger index;
@property  UIViewController *uiview;
@end

@implementation DailyTableViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        [self faker:@"1"];
        [self faker:@"2"];
        NSLog(@"22222222");
    }
    return _fakeData;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
      [self setupRefresh];
    self.title=@"工作日报";
    self.dailyObject=[NSMutableArray array];
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
        if ([controller isKindOfClass:[TaskReportTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


- (IBAction)addUser:(id)sender
{
    AddDailyViewController *jumpController = [[AddDailyViewController alloc] init];
    [self.navigationController pushViewController: jumpController animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// hide the extraLine
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];//下拉刷新
    //[self.tableView headerBeginRefreshing]; //自动刷新
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
    self.index=myDelegate.index++;
    NSString *p= [NSString stringWithFormat: @"%ld", (long)self.index];
    [self faker:p];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
}

-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    self.fakeData = [[NSMutableArray alloc]init];//daily
    self.dateData = [[NSMutableArray alloc]init];//time
    self.dailyObject = [[NSMutableArray alloc]init];
    self.workIdData = [[NSMutableArray alloc]init];//workid
    self.typeData = [[NSMutableArray alloc]init];//type
    self.reportData = [[NSMutableArray alloc]init];//report
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSLog(@"sid为--》%@", sid);
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"taskReportAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"time";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&order=%@&sort=%@",sid,order,sort];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"dailyDic字典里面的内容为--》%@", dailyDic);
    NSArray *list = [dailyDic objectForKey:@"obj"];
    if([list count] ==0)
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
        
    }else
    {
        self.tableView.footerRefreshingText=@"加载中";
    }
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        [self.dailyObject addObject:listDic];
        NSString *dailyreport = (NSString *)[listDic objectForKey:@"daily"];
        NSString *date = (NSString*)[listDic objectForKey:@"time"];
        NSString *workId = (NSString*)[listDic objectForKey:@"workStatementActionID"];
        NSString *type = (NSString *)[listDic objectForKey:@"type"];
        NSString *report = (NSString*)[listDic objectForKey:@"report"];
        [self.fakeData addObject:dailyreport];
        [self.dateData addObject:date];
        [self.workIdData addObject:workId];
        [self.typeData addObject:type];
        [self.reportData addObject:report];
        NSLog(@"dailyreport===>>%@",dailyreport);
        NSLog(@"wordID333444%@",self.workIdData);
    }
    return self.fakeData;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (tableView == self.tableView)
//    {
//        return self.fakeData.count;
//        
//    }else
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",mySearchDisplayController.searchBar.text];
//        _searchResultsData =  [[NSMutableArray alloc] initWithArray:[self.fakeData filteredArrayUsingPredicate:predicate]];
//        return _searchResultsData.count;
//    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"333333333");
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
//    [cell.imageView setImage:[UIImage imageNamed:@"dianhua"]];
    cell.textLabel.text = self.fakeData[indexPath.row];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];

    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"日期:" stringByAppendingString:(NSString *)[self.dateData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText:testDetail];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"workid为%@",self.workIdData);

    if (tableView == self.tableView)
    {
    NSString *dailyreport  =[self.fakeData objectAtIndex:indexPath.row];
    NSString *time =[self.dateData objectAtIndex:indexPath.row];
    NSString *jihua       =[self.typeData objectAtIndex:indexPath.row];;
    NSString *zongjie      =[self.reportData objectAtIndex:indexPath.row];
    NSString *workId      =[self.workIdData objectAtIndex:indexPath.row];
    TaskReportDailyEntity *dailydetail =[[TaskReportDailyEntity alloc] init];
    [dailydetail setLeixing:dailyreport];
    [dailydetail setTime:time];
    [dailydetail setZongjie:zongjie];
    [dailydetail setMingrijihua:jihua];
    [dailydetail setWorkID:workId];
    DailyViewController *uc =[[DailyViewController alloc] init];
    [uc setDailyEntity:dailydetail];
    [self.navigationController pushViewController:uc animated:YES];
   
    }else
    {
        NSString *dailyreport  =[self.fakeData objectAtIndex:indexPath.row];
        NSString *time =[self.dateData objectAtIndex:indexPath.row];
        NSString *jihua       =[self.typeData objectAtIndex:indexPath.row];;
        NSString *zongjie      =[self.reportData objectAtIndex:indexPath.row];
        NSString *workId      =[self.workIdData objectAtIndex:indexPath.row];
        TaskReportDailyEntity *dailydetail =[[TaskReportDailyEntity alloc] init];
        [dailydetail setLeixing:dailyreport];
        [dailydetail setTime:time];
        [dailydetail setZongjie:zongjie];
        [dailydetail setMingrijihua:jihua];
        [dailydetail setWorkID:workId];
        DailyViewController *uc =[[DailyViewController alloc] init];
        [uc setDailyEntity:dailydetail];
        [self.navigationController pushViewController:uc animated:YES];
    }
}
@end
