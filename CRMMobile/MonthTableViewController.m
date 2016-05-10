//
//  MonthTableViewController.m
//  CRMMobile
//
//  Created by why on 15/11/5.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "MonthTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "TaskReportMonthEntity.h"
#import "ShowAndDeleteViewController.h"
#import "TaskReportTableViewController.h"
#import "AddMonthViewController.h"
#import "UIImage+Tint.h"
#import "MJRefresh.h"
#import "trackCell.h"
@interface MonthTableViewController (){
    UISearchDisplayController *mySearchDisplayController;
}
@property (strong, nonatomic) NSMutableArray *fakeData;//ribaoleixing daily
@property (strong, nonatomic) NSMutableArray *searchResultsData;
@property (strong, nonatomic) NSMutableArray *workIdData;//ribaoid workStatementActionID
@property (strong, nonatomic) NSMutableDictionary *wordId;//ribaoid
@property (strong,nonatomic) NSMutableArray *dateData;//shijian time
@property (strong,nonatomic) NSMutableArray *typeData;//type
@property (strong,nonatomic) NSMutableArray *reportData;//report
@property  NSInteger index;
@property  UIViewController *uiview;
@end


@implementation MonthTableViewController
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.dateData = [[NSMutableArray alloc]init];//time
        self.workIdData = [[NSMutableArray alloc]init];//workid
        self.typeData = [[NSMutableArray alloc]init];//type
        self.reportData = [[NSMutableArray alloc]init];//report
        [self faker:@"1"];
    }
    return _fakeData;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self.fakeData removeAllObjects];
    
    [self.dateData removeAllObjects];
    
    [self.workIdData removeAllObjects];
    
    [self.typeData removeAllObjects];
    
    [self.reportData removeAllObjects];
    
    self.index =1;
    
    [self faker:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    self.title=@"工作月报";
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
    AddMonthViewController *jumpController = [[AddMonthViewController alloc] init];
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
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSLog(@"sid为--》%@", sid);
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"taskReportMAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"time";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@&order=%@&sort=%@",sid,page,order,sort];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
    NSDictionary *monthDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    NSLog(@"monthDic字典里面的内容为--》%@", monthDic);
    NSArray *list = [monthDic objectForKey:@"obj"];
    NSLog(@"page:%@",page);
    NSLog(@"....month......%ld",[list count]);

    if([list count] ==0)
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
        
    }else
    {
        self.tableView.footerRefreshingText=@"加载中";
    }
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        NSString *monthreport = (NSString *)[listDic objectForKey:@"month"];
        NSString *date = (NSString*)[listDic objectForKey:@"time"];
        NSString *workId = (NSString*)[listDic objectForKey:@"workStatementActionID"];
        NSString *type = (NSString *)[listDic objectForKey:@"type"];
        NSString *report = (NSString*)[listDic objectForKey:@"report"];
        [self.fakeData addObject:monthreport];
        [self.dateData addObject:date];
        [self.workIdData addObject:workId];
        [self.typeData addObject:type];
        [self.reportData addObject:report];
    }
    }
    return self.fakeData;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"trackCell";
    trackCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"trackCell" owner:self options:nil]lastObject];
    }
    //换算多少月
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableString *months = [self.dateData objectAtIndex:indexPath.row];
    NSDate *date = [formatter dateFromString:months];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    int month = [dateComponent month];
    if (month==0) {
        NSRange range = [months rangeOfString:@"年"];//匹配得到的下标
        NSRange range1 = [months rangeOfString:@"月"];//匹配得到的下标
        NSRange range2 = [months rangeOfString:@"日"];
        NSLog(@"rang:%@",NSStringFromRange(range));
//        string = [string substringToIndex:7];//截取掉下标7之后的字符串
        NSString * str = [months substringToIndex:range1.location];//截取范围类的字符串
        NSLog(@"截取的值为：%@",str);
       NSString *mon =  [str substringFromIndex:range.location+1];
        NSLog(@"截取的值为：%@",mon);
        month = [mon intValue];
        
    }
    //    NSCalendar *gregorian = [NSCalendar currentCalendar];
    //    NSDateComponents *weekOfYearComponents = [gregorian components:NSWeekOfYearCalendarUnit fromDate:date];
    //    NSInteger monthofyear = [weekOfYearComponents weekOfYear];
    NSString *testDetail1 =[@"   报告日期:" stringByAppendingString:months];
    NSString *monthes = [NSString stringWithFormat:@"%d",month];
    NSString *testDetail2 =[[@"第" stringByAppendingString:monthes] stringByAppendingString:@"月"];
    NSString *testDetail = [testDetail2 stringByAppendingString:testDetail1];
    [cell.detailTextLabel setText:testDetail];
    cell.myImg.image = [UIImage imageNamed:@"月报1.png"];
//    CGSize itemSize = CGSizeMake(20, 20);
//    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    [cell.myImg.image drawInRect:imageRect];
//    cell.myImg.image = UIGraphicsGetImageFromCurrentImageContext();
    cell.mylbl1.text= [self.fakeData objectAtIndex:indexPath.row];
    //    cell.mylbl2.frame = CGRectMake(65, 65, 400, 5);
    cell.mylbl2.text= testDetail;

//    
//    static NSString *cellId = @"mycell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//    }
//    [cell.imageView setImage:[UIImage imageNamed:@"work-5"]];
//    cell.textLabel.text = self.fakeData[indexPath.row];
//    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
//    
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    //换算多少周
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *months = [self.dateData objectAtIndex:indexPath.row];
//    NSDate *date = [formatter dateFromString:months];
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//     NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
//      int month = [dateComponent month];
//    
////    NSCalendar *gregorian = [NSCalendar currentCalendar];
////    NSDateComponents *weekOfYearComponents = [gregorian components:NSWeekOfYearCalendarUnit fromDate:date];
////    NSInteger monthofyear = [weekOfYearComponents weekOfYear];
//    NSString *testDetail1 =[@"   报告日期:" stringByAppendingString:months];
//    NSString *monthes = [NSString stringWithFormat:@"%d",month];
//     NSString *testDetail2 =[[@"第" stringByAppendingString:monthes] stringByAppendingString:@"月"];
//    NSString *testDetail = [testDetail2 stringByAppendingString:testDetail1];
//    [cell.detailTextLabel setText:testDetail];
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
    TaskReportMonthEntity *monthdetail =[[TaskReportMonthEntity alloc] init];
    [monthdetail setLeixing:dailyreport];
    [monthdetail setTime:time];
    [monthdetail setZongjie:zongjie];
    [monthdetail setMingrijihua:jihua];
    [monthdetail setWorkID:workId];
    ShowAndDeleteViewController *sd =[[ShowAndDeleteViewController alloc] init];
    [sd setMonthEntity:monthdetail];
    sd.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:sd animated:YES];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
//        return 50;
//    }else{
//        return 60;
//    }
    return 70;
}


@end
