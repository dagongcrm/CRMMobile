//
//  TXLTableViewController.m
//  CRMMobile
//
//  Created by why on 15/10/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "TXLTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "MJRefresh.h"
@interface TXLTableViewController (){
    UISearchDisplayController *mySearchDisplayController;
}
@property (nonatomic, strong) NSMutableArray *fakeData;//
@property (nonatomic, strong) NSMutableArray *contactData;//联系方式2
@property (nonatomic, strong) NSMutableArray *customerNameStrData;//联系人1
@property (nonatomic, strong) NSMutableArray *phoneData;//电话数据
@property (nonatomic, strong) NSMutableArray *userName;
@property (nonatomic, strong) NSMutableArray *orgName;
@property (nonatomic, strong) NSMutableArray *contactIDData;//3
@property (nonatomic, strong) NSMutableArray *customerIDData;//4
@property (nonatomic,strong) NSString *contactName;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *contactID;
@property (nonatomic,strong) NSString *customerID;
@property  NSInteger index;
@property  UIViewController *uiview;
@end

@implementation TXLTableViewController
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData = [[NSMutableArray alloc]init];
        self.contactData = [[NSMutableArray alloc]init];
        self.customerNameStrData = [[NSMutableArray alloc]init];
        self.phoneData = [[NSMutableArray alloc]init];
        self.contactIDData = [[NSMutableArray alloc]init];
        self.customerIDData = [[NSMutableArray alloc]init];
        [self faker:@"1"];
        
    }
    return _fakeData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"通讯录";
    [self setupRefresh];
     [self setExtraCellLineHidden:self.tableView];
    }
// hide the extraLine隐藏分割线
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

//获取数据
-(NSMutableArray *)faker:(NSString *)page{
    NSLog(@"page==>%@",page);
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@",sid,page];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *contactDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *list = [contactDic objectForKey:@"obj"];
    NSLog(@"pagecountpagecountpagecountpagecount==>>%lu",[list count]);

    if(![list count] ==0)
    {
        self.tableView.footerRefreshingText=@"加载中";
    }else
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
    }
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        [self.userName addObject:listDic];
        NSString *teamname = (NSString *)[listDic objectForKey:@"contactName"];//1
        NSString *telePhone = (NSString *)[listDic objectForKey:@"telePhone"];//2
        NSString *callphone = (NSString *)[listDic objectForKey:@"cellPhone"];//2-
        NSString *contactID = (NSString *)[listDic objectForKey:@"contactID"];//3
        NSString *customerID = (NSString *)[listDic objectForKey:@"customerID"];//4
        NSString *customerNameStr = (NSString *)[listDic objectForKey:@"customerNameStr"];
        NSString *phoneTime = (NSString *)[listDic objectForKey:@"phoneTime"];
        if (phoneTime  == nil || phoneTime == NULL) {
            [self.phoneData addObject:@"暂无通话记录"];
        }else{
            [self.phoneData addObject:phoneTime];
        }
        
        [self.fakeData addObject:teamname];//1
        [self.contactData addObject:telePhone];//2
        [self.contactIDData addObject:contactID];//3
        [self.customerIDData addObject:customerID];//4
        [self.customerNameStrData addObject:customerNameStr];
    }
    return self.fakeData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

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
//    NSLog(@"8888888%@",self.phoneData);
    
    [cell.imageView setImage:[UIImage imageNamed:@"lianxiren"]];
        cell.textLabel.text = self.customerNameStrData[indexPath.row];
        [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSString *testDetail =[@"联系电话:" stringByAppendingString:(NSString *)[self.contactData objectAtIndex:indexPath.row]];
//    [cell.detailTextLabel setText:testDetail];
    NSString *phoneT= [@"通话记录:" stringByAppendingString:(NSString *)[self.phoneData objectAtIndex:indexPath.row]];
    NSString *Tdetail1 = [testDetail stringByAppendingString:@"\n"];
    NSString *Tdetail= [Tdetail1 stringByAppendingString:phoneT];
    [cell.detailTextLabel setNumberOfLines:3];//可以显示3行
    cell.detailTextLabel.text = [NSString stringWithFormat:Tdetail,indexPath.row + 1];// \n ，可以在这里实现换行
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.contactName = [self.fakeData objectAtIndex:indexPath.row];
    self.phone= [self.contactData objectAtIndex:indexPath.row];
     self.contactID = [self.contactIDData objectAtIndex:indexPath.row];
    self.customerID = [self.customerIDData objectAtIndex:indexPath.row];
    NSString *str = @"tel://";
    NSString *telephone = [str stringByAppendingString:self.phone];
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:telephone];
    // 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
    [self  callLog];
}
-(void)callLog{
//    [self.tableView reloadData];//重新加载数据
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"callLogAction!add.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&contactName=%@&phone=%@&userID=%@&customerID=%@",sid,self.contactName,self.phone,self.contactID,self.customerID];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *shipDIC  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    if ([[shipDIC objectForKey:@"success"] boolValue] == YES) {
//        [self setupRefresh];
//    }
//    NSLog(@"通讯录拨打的记录--》%@", shipDIC);
//    NSLog(@"self.contactName==>>%@",self.contactName);
//     NSLog(@"self.phone==>>%@",self.phone);
//     NSLog(@"self.contactID==>>%@",self.contactID);
//     NSLog(@"self.customerID==>>%@",self.customerID);

   }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}
@end
