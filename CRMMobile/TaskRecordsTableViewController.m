
#import "RecordsDetalViewController.h"
#import "TaskRecordsTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MJRefresh.h"
#import "UIImage+Tint.h"
#import "RecordsNsObj.h"
#import "ReminderTableViewController.h"
#import "IndexViewController.h"
#import "MTableViewCell.h"
#import "NullString.h"
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
@property (strong, nonatomic) NSMutableArray *visitorAttribution;//拜访人归属
@property (strong, nonatomic) NSMutableArray *visitorStr;//拜访人
@property (strong, nonatomic) NSMutableArray *callRecordsID;//id
@property (nonatomic, strong) NSMutableArray *userName;
@property (strong, nonatomic) NSString       *refreshOrNot;
@property  NSInteger index;
@end

@implementation TaskRecordsTableViewController
-(void)viewWillAppear:(BOOL)animated{
    if([[[NSUserDefaults alloc] init] objectForKey:@"taskTableDateSource"]&&[APPDELEGATE.userChangeOrNot isEqualToString:@"nochange"]){
        self.refreshOrNot=@"NO";
    }else{
        self.refreshOrNot=@"YES";
    }
}

- (NSMutableArray *)fakeData
{
    NSLog(@"%@",self.refreshOrNot);
    if([self.refreshOrNot isEqualToString:@"NO"]){
        NSUserDefaults *ud = [[NSUserDefaults alloc] init];
        NSDictionary *ds=[[ud objectForKey:@"taskTableDateSource"] mutableCopy];
        self.callRecordsID=[[ds objectForKey:@"callRecordsID"] mutableCopy],
        self.fakeData=[[ds objectForKey:@"fakeData"] mutableCopy],
        self.visitDate=[[ds objectForKey:@"visitDate"] mutableCopy],
        self.theme=[[ds objectForKey:@"theme"] mutableCopy],
        self.accessMethodStr=[[ds objectForKey:@"accessMethodStr"] mutableCopy],
        self.mainContent=[[ds objectForKey:@"mainContent"] mutableCopy],
        self.respondentPhone=[[ds objectForKey:@"respondentPhone"] mutableCopy],
        self.respondent=[[ds objectForKey:@"respondent"] mutableCopy],
        self.address=[[ds objectForKey:@"address"] mutableCopy],
        self.visitProfile=[[ds objectForKey:@"visitProfile"] mutableCopy],
        self.result=[[ds objectForKey:@"result"] mutableCopy],
        self.customerRequirements=[[ds objectForKey:@"customerRequirements"] mutableCopy],
        self.customerChange=[[ds objectForKey:@"customerChange"] mutableCopy],
        self.visitorAttributionStr=[[ds objectForKey:@"visitorAttributionStr"] mutableCopy],
        self.visitor=[[ds objectForKey:@"userName"] mutableCopy];
    }
    if([self.refreshOrNot isEqualToString:@"YES"]){
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
            self.visitorAttributionStr = [[NSMutableArray alloc]init];
            self.visitorStr = [[NSMutableArray alloc]init];
            [self faker:@"1"];
            //          [self faker:@"2"];
        }
    }
    
    return _fakeData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"拜访记录";
    [self setupRefresh];
    [self setExtraCellLineHidden:self.tableView];
    //去除返回按钮的文本
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  }


-(NSMutableArray *) faker: (NSString *) page{
    NSString *sid = [[APPDELEGATE.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallRecordsAction!mDatagrid.action"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"time";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&order=%@&sort=%@&page=%@",sid,order,sort,page];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
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
            NSDictionary *listDic =[list objectAtIndex:i];
            [self.userName addObject:listDic];
            NSLog(@"%@",listDic);
            NSString *teamname  = (NSString *)[listDic  objectForKey:@"callRecordsID"];
            NSString *teamname1 = (NSString *)[listDic  objectForKey:@"customerName"];
            NSString *teamname2 = (NSString *)[listDic  objectForKey:@"visitDate"];
            NSString *teamname3 = (NSString *)[listDic  objectForKey:@"theme"];
            NSString *teamname4 = (NSString *)[listDic  objectForKey:@"accessMethodStr"];
            NSString *teamname5 = (NSString *)[listDic  objectForKey:@"mainContent"];
            NSString *teamname6 = (NSString *)[listDic  objectForKey:@"respondentPhone"];
            NSString *teamname7 = (NSString *)[listDic  objectForKey:@"respondent"];
            NSString *teamname8 = (NSString *)[listDic  objectForKey:@"address"];
            NSString *teamname9 = (NSString *)[listDic  objectForKey:@"visitProfile"];
            NSString *teamname10 = (NSString *)[listDic objectForKey:@"result"];
            NSString *teamname11 = (NSString *)[listDic objectForKey:@"customerRequirements"];
            NSString *teamname12 = (NSString *)[listDic objectForKey:@"customerChange"];
            NSString *teamname13 = (NSString *)[listDic objectForKey:@"visitorAttributionStr"];
            NSString *teamname14 = (NSString *)[listDic objectForKey:@"userName"];
            if(teamname.length==0){
                teamname=@"";
            }
            if (teamname1.length==0) {
                teamname1=@" ";
            }
            if (teamname2.length==0) {
                teamname2=@" ";
            }
            if (teamname3.length==0) {
                teamname3=@" ";
            }
            if (teamname4.length==0) {
                teamname4=@" ";
            }
            if (teamname5.length==0) {
                teamname5=@" ";
            }
            if (teamname6.length==0) {
                teamname6=@" ";
            }
            if (teamname7.length==0) {
                teamname7=@" ";
            }
            if (teamname8.length==0) {
                teamname8=@" ";
            }
            if (teamname9.length==0) {
                teamname9=@" ";
            }
            if (teamname10.length==0) {
                teamname10=@" ";
            }
            if (teamname11.length==0) {
                teamname11=@" ";
            }
            if (teamname12.length==0) {
                teamname12=@" ";
            }
            if (teamname13.length==0) {
                teamname13=@" ";
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
            [self.visitorAttributionStr addObject:teamname13];
            [self.visitor addObject:teamname14];
            //        [self.visitorAttribution addObject:teamname15];
            //        [self.visitorStr addObject:teamname16];
        }
        
        NSDictionary * visitTableDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         self.callRecordsID,@"callRecordsID",
                                         self.fakeData,@"fakeData",
                                         self.visitDate,@"visitDate",
                                         self.theme,@"theme",
                                         self.accessMethodStr,@"accessMethodStr",
                                         self.mainContent,@"mainContent",
                                         self.respondentPhone,@"respondentPhone",
                                         self.respondent,@"respondent",
                                         self.address,@"address",
                                         self.visitProfile,@"visitProfile",
                                         self.result,@"result",
                                         self.customerRequirements,@"customerRequirements",
                                         self.customerChange,@"customerChange",
                                         self.visitorAttributionStr,@"visitorAttributionStr",
                                         self.visitor,@"userName",
                                         nil];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:visitTableDate forKey:@"taskTableDateSource"];
    }
    return self.fakeData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"MTableViewCell";
    //自定义cell类
    MTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MTableViewCell" owner:self options:nil] lastObject];
    }
    //添加测试数据
    cell.qiyeName.text = [self.fakeData objectAtIndex:indexPath.row];
    NSString *bfl = [self.accessMethodStr objectAtIndex:indexPath.row];
    cell.myImg.image = [UIImage imageNamed:@"baifanJL.png"];
    if ([bfl isEqualToString:@"电话"]) {
        cell.bfLeixing.textColor = [UIColor colorWithRed:0.f/255.f green:100.f/255.f blue:0.f/255.f alpha:1];
        cell.bfLeixing.text = bfl;
    }else{
       
        cell.bfLeixing.textColor = [UIColor redColor];;
        cell.bfLeixing.text = bfl;
    }
    cell.bfLeixing.font = [UIFont systemFontOfSize:10];
   
    NSString * bfr = [self.visitor objectAtIndex:indexPath.row];
    if ([NullString isBlankString:bfr]) {
        cell.bfRen.text =@"拜访人:暂无信息" ;
    }else{
        cell.bfRen.text = [@"拜访人:" stringByAppendingString:bfr];
    }
    NSString * bfs = [self.visitDate objectAtIndex:indexPath.row];
    if ([NullString isBlankString:bfs]) {
        cell.bfShijian.text =@"暂无信息" ;
    }else{
        if(bfs.length>10){
            cell.bfShijian.text = [bfs substringToIndex:10];
        }else{
            cell.bfShijian.text =bfs;
        }
    }
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
    self.refreshOrNot =@"YES";
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
    
    [visitPlan setRespondentPhone:respondentPhone];
    [visitPlan setRespondent:respondent];
    [visitPlan setAddress:address];
    [visitPlan setVisitProfile:visitProfile];
    [visitPlan setResult:result];
    [visitPlan setCustomerRequirements:customerRequirements];
    [visitPlan setCustomerChange:customerChange];
    [visitPlan setVisitorAttributionStr:visitorAttributionStr];
    [visitPlan setVisitor:visitor];
    //  [visitPlan setVisitorAttribution:visitorAttribution];
    //    [visitPlan setVisitorStr:visitorStr];
    RecordsDetalViewController *uc =[[RecordsDetalViewController alloc] init];
    [uc setDailyEntity:visitPlan];
    [self.navigationController pushViewController:uc animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
    //        return 44;
    //    }else{
    //        return 55;
    //    }
    return 70;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    NSLog(@"heightForHeaderInSection-->%zi",section);
//    return 10;
//}


@end