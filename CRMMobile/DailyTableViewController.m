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
#import "reportCell.h"

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
@property (strong,nonatomic) NSMutableArray *createData;//创建时间
@property  NSInteger index;
@property  UIViewController *uiview;

@end

@implementation DailyTableViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.dateData = [[NSMutableArray alloc]init];//time
        self.dailyObject = [[NSMutableArray alloc]init];
        self.workIdData = [[NSMutableArray alloc]init];//workid
        self.typeData = [[NSMutableArray alloc]init];//type
        self.reportData = [[NSMutableArray alloc]init];//report
        self.createData = [[NSMutableArray alloc]init];
        [self faker:@"1"];
    }
    return _fakeData;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self.fakeData removeAllObjects];
    
    [self.dateData removeAllObjects];
    
    [self.dailyObject removeAllObjects];
    
    [self.workIdData removeAllObjects];
    
    [self.typeData removeAllObjects];
    
    [self.reportData removeAllObjects];
    
     [self.createData removeAllObjects];
    self.index =1;
    
    [self faker:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    self.title=@"工作日报";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addUser:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    [self setExtraCellLineHidden:self.tableView];

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
      
}

- (IBAction)addUser:(id)sender
{
    AddDailyViewController *jumpController = [[AddDailyViewController alloc] init];
    [self.navigationController pushViewController: jumpController animated:true];
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
-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSLog(@"sid为--》%@", sid);
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"taskReportAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"createTime";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@&order=%@&sort=%@",sid,page,order,sort];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
    NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    NSLog(@"dailyDic字典里面的内容为--》%@", dailyDic);
    
    NSArray *list = [dailyDic objectForKey:@"obj"];
    NSLog(@"page:%@",page);
    NSLog(@"..........%ld",[list count]);
    if(![list count] ==0)
    {
        self.tableView.footerRefreshingText=@"加载中";
    }else
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
    }

    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        [self.dailyObject addObject:listDic];
        NSString *dailyreport = (NSString *)[listDic objectForKey:@"daily"];
        NSString *date = (NSString*)[listDic objectForKey:@"time"];
        NSString *workId = (NSString*)[listDic objectForKey:@"workStatementActionID"];
        NSString *type = (NSString *)[listDic objectForKey:@"type"];
        NSString *report = (NSString*)[listDic objectForKey:@"report"];
        
        if(dailyreport.length==0){
        dailyreport=@"暂无数据";
        }else if(date.length==0){
        date=@"暂无数据";
        }else if(type.length==0){
        type=@"暂无数据";
        }else if(report.length==0){
        report=@"暂无数据";
        }
        [self.fakeData addObject:dailyreport];
        [self.dateData addObject:date];
        [self.workIdData addObject:workId];
        [self.typeData addObject:type];
        [self.reportData addObject:report];
        [self.createData addObject:(NSString*)[listDic objectForKey:@"createTime"]];
    }
    }
    return self.fakeData;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"report";
    reportCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"reportCell" owner:self options:nil]lastObject];
    }
    cell.myImg.image = [UIImage imageNamed:@"日报1.png"];
    cell.title.text= [self.fakeData objectAtIndex:indexPath.row];
    NSString *createDetail =[@"创建日期:" stringByAppendingString:(NSString *)[self.createData objectAtIndex:indexPath.row]];
    cell.content1.text = createDetail;
     NSString *testDetail =[@"报告日期:" stringByAppendingString:(NSString *)[self.dateData objectAtIndex:indexPath.row]];
    cell.content2.text= testDetail;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
        uc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:uc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

@end
