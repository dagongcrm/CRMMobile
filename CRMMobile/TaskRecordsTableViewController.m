
#import "RecordsDetalViewController.h"
#import "TaskRecordsTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MJRefresh.h"
#import "UIImage+Tint.h"
#import "RecordsNsObj.h"
@interface TaskRecordsTableViewController (){
    UISearchDisplayController *mySearchDisplayController;
}
@property (strong, nonatomic) NSMutableArray *fakeData;//客户名称
@property (strong, nonatomic) NSMutableArray *visitDate;//拜访时间
@property (strong, nonatomic) NSMutableArray *theme;//主题
@property (strong, nonatomic) NSMutableArray *accessMethodStr;//访问方式
@property (strong, nonatomic) NSMutableArray *mainContent;//主要内容
@property (strong, nonatomic) NSMutableArray *respondentPhone;//受访人电话
@property (strong, nonatomic) NSMutableArray *respondent;//受访人员
@property (strong, nonatomic) NSMutableArray *address;//地址
@property (strong, nonatomic) NSMutableArray *visitProfile;//拜访概要
@property (strong, nonatomic) NSMutableArray *result;//达成结果
@property (strong, nonatomic) NSMutableArray *customerRequirements;//客户需求
@property (strong, nonatomic) NSMutableArray *customerChange;//客户变更
@property (strong, nonatomic) NSMutableArray *visitorAttributionStr;//拜访人归属
@property (strong, nonatomic) NSMutableArray *visitor;//拜访人
@property (strong, nonatomic) NSMutableArray *callRecordsID;//id
@property (nonatomic, strong) NSMutableArray *userName;
@property  NSInteger index;//
@end

@implementation TaskRecordsTableViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.callRecordsID = [[NSMutableArray alloc]init];
        self.fakeData = [[NSMutableArray alloc]init];
        self.visitDate = [[NSMutableArray alloc]init];
        self.theme = [[NSMutableArray alloc]init];
        self.accessMethodStr = [[NSMutableArray alloc]init];
        self.mainContent = [[NSMutableArray alloc]init];
        self.respondentPhone = [[NSMutableArray alloc]init];
        self.respondent= [[NSMutableArray alloc]init];
        self.address = [[NSMutableArray alloc]init];
        self.visitProfile = [[NSMutableArray alloc]init];
        self.result = [[NSMutableArray alloc]init];
        self.customerRequirements = [[NSMutableArray alloc]init];
        self.customerChange = [[NSMutableArray alloc]init];
        self.visitor = [[NSMutableArray alloc]init];
        [self faker:@"1"];
        [self faker:@"2"];
    }
    return _fakeData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];    //上拉刷新下拉加在方法
    self.title=@"拜访记录";
   
  }

-(NSMutableArray *) faker: (NSString *) page{
   
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallRecordsAction!mDatagrid.action"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"visitDate";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&order=%@&sort=%@&page=%@",sid,order,sort,page];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
     NSError *error;
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
       
        NSDictionary *listDic =[list objectAtIndex:i];
        [self.userName addObject:listDic];
        NSString *teamname = (NSString *)[listDic objectForKey:@"callRecordsID"];
        NSString *teamname1 = (NSString *)[listDic objectForKey:@"customerName"];
        NSString *teamname2= (NSString *)[listDic objectForKey:@"visitDate"];
        NSString *teamname3 = (NSString *)[listDic objectForKey:@"theme"];
        NSString *teamname4 = (NSString *)[listDic objectForKey:@"accessMethodStr"];
        NSString *teamname5 = (NSString *)[listDic objectForKey:@"mainContent"];
        NSString *teamname6 = (NSString *)[listDic objectForKey:@"respondentPhone"];
        NSString *teamname7 = (NSString *)[listDic objectForKey:@"respondent"];
        NSString *teamname8 = (NSString *)[listDic objectForKey:@"address"];
        NSString *teamname9 = (NSString *)[listDic objectForKey:@"visitProfile"];
        NSString *teamname10 = (NSString *)[listDic objectForKey:@"result"];
        NSString *teamname11 = (NSString *)[listDic objectForKey:@"customerRequirements"];
        NSString *teamname12 = (NSString *)[listDic objectForKey:@"customerChange"];
        NSString *teamname13 = (NSString *)[listDic objectForKey:@"visitorAttributionStr"];
        NSString *teamname14 = (NSString *)[listDic objectForKey:@"visitor"];
        if(teamname.length==0){
            teamname=@"";
        }
                if (teamname1.length==0) {
                    teamname1=@"暂无数据";
                }
                if (teamname2.length==0) {
                    teamname2=@"暂无数据";
                }
                if (teamname3.length==0) {
                    teamname3=@"暂无数据";
                }
                if (teamname4.length==0) {
                    teamname4=@"暂无数据";
                }
                if (teamname5.length==0) {
                    teamname5=@"暂无数据";
                }
                if (teamname6.length==0) {
                    teamname6=@"暂无数据";
                }
                if (teamname7.length==0) {
                    teamname7=@"暂无数据";
                }
                if (teamname8.length==0) {
                    teamname8=@"暂无数据";
                }
                if (teamname9.length==0) {
                    teamname9=@"暂无数据";
                }
                if (teamname10.length==0) {
                    teamname10=@"暂无数据";
                }
                if (teamname11.length==0) {
                    teamname11=@"暂无数据";
                }
                if (teamname12.length==0) {
                    teamname12=@"暂无数据";
                }
                if (teamname13.length==0) {
                    teamname13=@"暂无数据";
                }
        [self.callRecordsID addObject:teamname];
        [self.fakeData addObject:teamname1];
        [self.visitDate addObject:teamname2];
        [self.theme addObject:teamname3];
        [self.accessMethodStr addObject:teamname4];
        [self.mainContent addObject:teamname5];
        [self.respondentPhone addObject:teamname6];
        [self.respondent addObject:teamname7];
        [self.address addObject:teamname8];
        [self.visitProfile addObject:teamname9];
        [self.result addObject:teamname10];
        [self.customerRequirements addObject:teamname11];
        [self.customerChange addObject:teamname12];
        [self.visitorAttributionStr addObject:teamname13];
        [self.visitor addObject:teamname14];
       
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *callRecordsID =[self.callRecordsID objectAtIndex:indexPath.row];
    NSString *customerNameStr  =[self.fakeData objectAtIndex:indexPath.row];
    NSString *visitDate =[self.visitDate objectAtIndex:indexPath.row];
    NSString *theme =[self.theme objectAtIndex:indexPath.row];
    NSString *accessMethodStr =[self.accessMethodStr objectAtIndex:indexPath.row];
    NSString *mainContent  =[self.mainContent objectAtIndex:indexPath.row];
    NSString *respondentPhone =[self.respondentPhone objectAtIndex:indexPath.row];
    NSString *respondent =[self.respondent objectAtIndex:indexPath.row];
    NSString *address =[self.address objectAtIndex:indexPath.row];
    NSString *visitProfile  =[self.visitProfile objectAtIndex:indexPath.row];
    NSString *result =[self.result objectAtIndex:indexPath.row];
    NSString *customerRequirements =[self.customerRequirements objectAtIndex:indexPath.row];
    NSString *customerChange =[self.customerChange objectAtIndex:indexPath.row];
    NSString *visitorAttributionStr  =[self.visitorAttributionStr objectAtIndex:indexPath.row];
    NSString *visitor =[self.visitor objectAtIndex:indexPath.row];
    
    RecordsNsObj *visitPlan =[[RecordsNsObj alloc] init];
    [visitPlan setCustomerNameStr:customerNameStr];
    [visitPlan setCallRecordsID:callRecordsID];
    [visitPlan setVisitDate:visitDate];
    [visitPlan setTheme:theme];
    [visitPlan setAccessMethodStr:accessMethodStr];
    [visitPlan setMainContent:mainContent];
    [visitPlan setRespondent:respondent];
    [visitPlan setRespondentPhone:respondentPhone];
    [visitPlan setAddress:address];
    [visitPlan setVisitProfile:visitProfile];
    [visitPlan setResult:result];
    [visitPlan setCustomerRequirements:customerRequirements];
    [visitPlan setCustomerChange:customerChange];
    [visitPlan setVisitorAttributionStr:visitorAttributionStr];
    [visitPlan setVisitor:visitor];
    RecordsDetalViewController *uc =[[RecordsDetalViewController alloc] init];
    [uc setDailyEntity:visitPlan];
    [self.navigationController pushViewController:uc animated:YES];
    
}
@end