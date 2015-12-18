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
#import "MJRefresh.h"
#import "SCLAlertView.h"
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
@property (nonatomic,strong) NSString *kSubtitle;
@property (nonatomic,strong) NSString *alertPhone;//电话
@property (nonatomic,strong) NSString *alertName;//联系人姓名
@property (nonatomic,strong) NSString *alertQiye;//企业
@property (nonatomic,strong) NSString *alertJilu;//上一次通话记录
@property  NSInteger index;
@property  UIViewController *uiview;
@end

NSString *kSuccessTitle = @"Congratulations";
NSString *kErrorTitle = @"Connection error";
NSString *kNoticeTitle = @"Notice";
NSString *kWarningTitle = @"Warning";
NSString *kInfoTitle = @"客户联系人详情";
NSString *kButtonTitle = @"取消";
NSString *kAttributeTitle = @"Attributed string operation successfully completed.";


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
//    //隐藏顶部的导航栏
//    self.hidesBottomBarWhenPushed = true;    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    searchBar.placeholder = @"搜索";
//    self.tableView.tableHeaderView = searchBar;
//    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    mySearchDisplayController.searchResultsDataSource = self;
//    mySearchDisplayController.searchResultsDelegate = self;
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
        NSLog(@"33333333333%@",customerNameStr);
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
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
//    NSLog(@"8888888%@",self.phoneData);
    
    [cell.imageView setImage:[UIImage imageNamed:@"txl-1"]];
    
    NSString *name =  self.fakeData[indexPath.row];
    NSString *phone = (NSString *)[self.contactData objectAtIndex:indexPath.row];
    NSString *text1 =[[name stringByAppendingString:@" "]stringByAppendingString:phone];
    cell.textLabel.text =text1;
        [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail = [self.customerNameStrData objectAtIndex:indexPath.row];
//    [cell.detailTextLabel setText:testDetail];
    NSString *phoneT= [@"通话记录:" stringByAppendingString:(NSString *)[self.phoneData objectAtIndex:indexPath.row]];
    NSString *Tdetail1 = [testDetail stringByAppendingString:@"\n"];
    NSString *Tdetail= [Tdetail1 stringByAppendingString:phoneT];
    [cell.detailTextLabel setNumberOfLines:3];//可以显示3行
    cell.detailTextLabel.text = [NSString stringWithFormat:Tdetail,indexPath.row + 1];// \n ，可以在这里实现换行
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.contactName = [self.fakeData objectAtIndex:indexPath.row];
    self.phone= [self.contactData objectAtIndex:indexPath.row];
     self.contactID = [self.contactIDData objectAtIndex:indexPath.row];
    self.customerID = [self.customerIDData objectAtIndex:indexPath.row];
    //NSLog(@"ggggggggggggg%@",self.phoneData);
    //[self bodadianhua];
//    SettingViewController *fl= [[SettingViewController alloc] init];
//    [self.navigationController pushViewController:fl animated:NO];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.phoneData]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://self.phoneData"]];
    
    //给弹框传值
    _alertPhone = self.phone;
    _alertName = self.contactName;
   _alertQiye = [self.customerNameStrData objectAtIndex:indexPath.row];
    _alertJilu = [self.phoneData objectAtIndex:indexPath.row];
    
    
//    NSString *str = @"tel://";
//    NSString *telephone = [str stringByAppendingString:self.phone];
//    
//    UIWebView *callWebview =[[UIWebView alloc] init];
//    NSURL *telURL =[NSURL URLWithString:telephone];
//    // 貌似tel:// 或者 tel: 都行
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    //记得添加到view上
//    [self.view addSubview:callWebview];
    [self showInfo];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
    NSLog(@"我们一起拨打电话吧%@",self.phone);
    
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
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{

    NSDictionary *shipDIC  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    if ([[shipDIC objectForKey:@"success"] boolValue] == YES) {
//        [self setupRefresh];
//    }
    NSLog(@"通讯录拨打的记录--》%@", shipDIC);
    NSLog(@"self.contactName==>>%@",self.contactName);
     NSLog(@"self.phone==>>%@",self.phone);
     NSLog(@"self.contactID==>>%@",self.contactID);
     NSLog(@"self.customerID==>>%@",self.customerID);

//    if ([[shipDIC objectForKey:@"success"] boolValue] == YES) {
//        [self setupRefresh];
// 
    }
   }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}
- (void)showInfo{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
     [alert addButton:@"拨打电话" target:self selector:@selector(callYou)];
    NSString * name1 =[@"姓名:" stringByAppendingString:_alertName];
//    NSString * cname = [@"企业名称:" stringByAppendingString:_alertQiye];
//    int index = cname.length;
    NSString * phone= [@"联系电话:" stringByAppendingString:_alertPhone];
//    NSString *Jilu = [@"上一次通话时间:" stringByAppendingString:_alertJilu];
     UITextField *textField1 = [alert addTextField:@""];
    textField1.text = name1;
    [textField1 setEnabled:NO];
     UITextField *textField2 = [alert addTextField:@""];
    textField2.text = _alertQiye;
     [textField2 setEnabled:NO];
     UITextField *textField3 = [alert addTextField:@""];
    textField3.text = phone;
     [textField3 setEnabled:NO];
//    UITextField *textField4 = [alert addTextField:@""];
//    textField4.text = Jilu;
//    [textField4 setEnabled:NO];
//    UILabel *label = [UILabel new];
//    label.text = @"             ";
//    NSString *blog =@"             ";
//    if (name1.length<16) {
//        name1 = [name1 stringByAppendingString:label.text];
//    }
//    if (cname.length<16){
//        cname = [cname stringByAppendingString:label.text];
//    }
//    if(phone.length<16){
//        phone = [phone stringByAppendingString:label.text];
//    }
//    _kSubtitle = [[name1 stringByAppendingFormat:@"\n%@",cname]stringByAppendingFormat:@"\n%@",phone];
     _kSubtitle = @"客户信息，可以拨打电话。";
//
//    _kSubtitle = [[[[[name1 stringByAppendingString:name1] stringByAppendingString:@"/n"] stringByAppendingString:cname] stringByAppendingString:@"/n"] stringByAppendingString:phone];
    alert.shouldDismissOnTapOutside = YES;
    [alert showInfo:self title:kInfoTitle subTitle:_kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
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
