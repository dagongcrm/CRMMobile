//
//  MailListTableViewController.m
//  CRMMobile
//
//  Created by why on 16/4/16.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "MailListTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "SCLAlertView.h"
#import "MJRefresh.h"
#import "mailCell.h"
@interface MailListTableViewController ()
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
@property (nonatomic,strong) NSString *kSubtitle;
@property (nonatomic,strong) NSString *alertPhone;//电话
@property (nonatomic,strong) NSString *alertName;//联系人姓名
@property (nonatomic,strong) NSString *alertQiye;//企业
@property (nonatomic,strong) NSString *alertJilu;//上一次通话记录
@property  NSInteger index;
@end

@implementation MailListTableViewController
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
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"通讯录";
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
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
        NSDictionary *contactDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSArray *list = [contactDic objectForKey:@"obj"];
        NSLog(@"pagecountpagecountpagecountpagecount==>>%lu",(unsigned long)[list count]);
        
        if(![list count] ==0)
        {
            self.tableView.footerRefreshingText=@"加载中";
        }else
        {
            self.tableView.footerRefreshingText = @"没有更多数据";
        }
        for (int i = 0;i<[list count];i++) {
            NSDictionary *listDic =[list objectAtIndex:i];
            NSString *contactState = (NSString *)[listDic objectForKey:@"contactState"];
            if ([contactState isEqualToString:@"huoYue"]) {
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
                if (teamname==nil||teamname==NULL) {
                    teamname=@"暂无该联系人姓名";
                }
                if (telePhone==nil||telePhone==NULL) {
                    telePhone=@"暂无该联系人电话";
                }
                if (customerNameStr==nil||customerNameStr==NULL) {
                    customerNameStr=@"暂无企业信息";
                }
                if (contactID==nil||contactID==NULL) {
                    contactID=@"null";
                }
                [self.fakeData addObject:teamname];//1
                [self.contactData addObject:telePhone];//2
                [self.contactIDData addObject:contactID];//3
                [self.customerIDData addObject:customerID];//4
                [self.customerNameStrData addObject:customerNameStr];
            }
        }
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
    static NSString *cellId = @"mailCell";
    mailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"mailCell" owner:self options:nil]lastObject];
    }
    cell.photo.image = [UIImage imageNamed:@"txlphoto.png"];
    cell.lianxiR.text = self.fakeData[indexPath.row];
    cell.phone.text = (NSString *)[self.contactData objectAtIndex:indexPath.row];
    cell.company.text = [self.customerNameStrData objectAtIndex:indexPath.row];
    cell.phoneBtn.image = [UIImage imageNamed:@"phoneBtn.png"];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
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
//    NSLog(@"ggggggggggggg%@",self.phoneData);
//   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
//    NSLog(@"我们一起拨打电话吧%@",self.phone);
//
    _alertPhone = self.phone;
    [self  callLog];
    [self callYou
     ];
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
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
        
        NSDictionary *shipDIC  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
   
        NSLog(@"通讯录拨打的记录--》%@", shipDIC);
        NSLog(@"self.contactName==>>%@",self.contactName);
        NSLog(@"self.phone==>>%@",self.phone);
        NSLog(@"self.contactID==>>%@",self.contactID);
        NSLog(@"self.customerID==>>%@",self.customerID);
      
    }
}
-(void)callYou{
    NSLog(@"你好，先生！有什么可以帮到你的？");
    NSString *str = @"tel://";
    NSString *telephone = [str stringByAppendingString:_alertPhone];
    NSLog(@"你好，你的电话：%@",telephone);
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:telephone];
    // 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
}

@end
