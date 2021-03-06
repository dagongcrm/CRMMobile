//
//  SubmitTableViewController.m
//  CRMMobile
//
//  Created by zhang on 15/10/30.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "SubmitTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "UIImage+Tint.h"
#import "WorkTableViewController.h"
#import "addTaskViewController.h"
#import "submitTaskEntity.h"
#import "submitTaskDetailViewController.h"
#import "selectEntity.h"
#import "MJRefresh.h"
#import "taskCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD+NJ.h"
@interface SubmitTableViewController ()<MBProgressHUDDelegate>

@property (strong, nonatomic) NSMutableArray *bianHao;
@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *userIdData;
@property (strong, nonatomic) NSMutableArray *dataing;
@property (strong, nonatomic) NSMutableArray *time;
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong, nonatomic) NSMutableArray *searchResultsData;
@property (strong, nonatomic) NSMutableDictionary *uSubmitId;
@property (strong, nonatomic) MBProgressHUD  *progress;
@property  NSInteger index;
@end

@implementation SubmitTableViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.bianHao=[[NSMutableArray alloc] init];
        self.fakeData=[[NSMutableArray alloc] init];
        self.dataing=[[NSMutableArray alloc] init];
        self.time=[[NSMutableArray alloc] init];
        self.uid=[[NSMutableArray alloc] init];
        [self faker:@"1"];
        
    }
    return _fakeData;
}

-(void)viewWillAppear:(BOOL)animated{
    if([APPDELEGATE.customerForAddSaleLead isEqualToString:@"fromSubmit"]||[APPDELEGATE.customerForAddSaleLead isEqualToString:@"fromEdit"]||[APPDELEGATE.customerForAddSaleLead isEqualToString:@"fromAdd"]){
    APPDELEGATE.customerForAddSaleLead=@"";
    [self.fakeData removeAllObjects];
    [self.bianHao removeAllObjects];
    [self.dataing removeAllObjects];
    [self.time removeAllObjects];
    [self.uid removeAllObjects];
    dispatch_async(dispatch_get_main_queue(),^{
        [self faker:@"1"];
        [self.tableView reloadData];
    });
    }
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"任务提交";
    [self setupRefresh];
    [self leftButtonInit];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.tableFooterView=[[UIView alloc] init];
}


-(NSMutableArray *) faker:(NSString *)page {
    self.progress=[[MBProgressHUD alloc] initWithView:self.view];
    self.progress.progress=0.4;
    [self.view addSubview:self.progress];
    self.progress.dimBackground=NO;
    self.progress.labelText=@"加载中，请稍后";
    [self.progress show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSDictionary *parameters = @{@"MOBILE_SID":sid,
                                 @"page":page,
                                 @"zhuangtai":@"0"};
    [manager POST:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!renWuJBXXTJDatagrid.action?"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSArray *list = [responseObject objectForKey:@"obj"];
            if(![list count] ==0)
            {
                self.tableView.footerRefreshingText=@"加载中";
            }else
            {
                self.tableView.footerRefreshingText = @"没有更多数据";
            }
            for (int i = 0; i<[list count]; i++) {
                NSDictionary *listdic = [list objectAtIndex:i];
                NSLog(@"%@",listdic);
                [self.uid addObject:listdic];
                NSString *submitID = (NSString *)[listdic objectForKey:@"bianHao"];
                NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];
                NSLog(@"%@",teamname);
                NSString *userId   = (NSString *)[listdic objectForKey:@"yeWuZLMC_cn"];
                NSString *time   = (NSString *)[listdic objectForKey:@"renWuTJSJStr"];
                NSString *yeWuZLBH   = (NSString *)[listdic objectForKey:@"yeWuZLBH"];
                [self.fakeData    addObject:teamname];
                [self.time        addObject:time];
                [self.dataing     addObject:userId];
                [self.bianHao     addObject:submitID];
            }
            [self submitIDReturn:self.bianHao];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.progress hide:YES];
            });
            }else{
            [self.progress hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.progress hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求错误" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
        }];
    return self.fakeData;
}







//-(NSMutableArray *) faker: (NSString *) page{
//    NSError *error;
//    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
//    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!renWuJBXXTJDatagrid.action?"]];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval=10.0;
//    request.HTTPMethod=@"POST";
//    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@&zhuangTai=0",page,sid];
//    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
//        [alert show];
//        NSLog(@"--------%@",error);
//    }else{
//        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        NSLog(@"%@",weatherDic);
//        NSArray *list = [weatherDic objectForKey:@"obj"];
//        if(![list count] ==0)
//        {
//            self.tableView.footerRefreshingText=@"加载中";
//        }else
//        {
//            self.tableView.footerRefreshingText = @"没有更多数据";
//        }
//        for (int i = 0; i<[list count]; i++) {
//            NSDictionary *listdic = [list objectAtIndex:i];
//            NSLog(@"%@",listdic);
//            [self.uid addObject:listdic];
//            NSString *submitID = (NSString *)[listdic objectForKey:@"bianHao"];
//            NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];
//            NSLog(@"%@",teamname);
//            NSString *userId   = (NSString *)[listdic objectForKey:@"yeWuZLMC_cn"];
//            
//            NSString *time   = (NSString *)[listdic objectForKey:@"renWuTJSJStr"];
//            NSString *yeWuZLBH   = (NSString *)[listdic objectForKey:@"yeWuZLBH"];
//            [self.fakeData    addObject:teamname];
//            [self.time        addObject:time];
//            [self.dataing     addObject:userId];
//            [self.bianHao     addObject:submitID];
//        }
//        [self submitIDReturn:self.bianHao];
//    }
//    return self.fakeData;
//}

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
  }

// hide the extraLine
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(NSMutableArray *) submitIDReturn: (NSMutableArray *) uidArr
{
    return self.bianHao;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"taskCell";
    taskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"taskCell" owner:self options:nil] lastObject];
    }
    if(![self.fakeData count]==0){
    cell.myImg.image = [UIImage imageNamed:@"任务提交1.png"];
    cell.mylbl1.text = [self.fakeData objectAtIndex:indexPath.row];
    cell.mylbl2.text = self.dataing[indexPath.row];
    cell.mylbl3.text = self.time [indexPath.row];
    }
    return cell;
}

- (IBAction)addFlow:(id)sender
{
    addTaskViewController *la = [[addTaskViewController alloc] init];
    [self.navigationController pushViewController:la animated:YES];
}

-(void) leftButtonInit{
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addFlow:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
}
-(void) submitIDuserName:(NSMutableArray *)utestname :(NSMutableArray *)submitID{
    _uSubmitId = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[utestname count];i++)
    {
        [_uSubmitId setObject:[submitID objectAtIndex:i] forKey:[utestname objectAtIndex:i]];
    }
}
-(NSDictionary *) singleUserInfo :(NSString *) submitIDIn{
    NSLog(@"%@",self.uid);
    for (int z = 0; z<[self.uid count]; z++) {
        NSDictionary *listdic = [self.uid objectAtIndex:z];
        NSString     *submitID  = (NSString *)[listdic objectForKey:@"bianHao"];
        if([submitID isEqualToString: submitIDIn])
        {
            return listdic;
        }
    }
    return  nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self submitIDuserName:self.fakeData :self.bianHao];
    NSLog(@"%@",self.fakeData);
    NSLog(@"%@",self.bianHao);
    
    if (tableView == self.tableView)
    {
        
        NSDictionary *nc =[self singleUserInfo:(NSString *)[_uSubmitId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
        NSString *submitName  =(NSString *) [nc objectForKey:@"qiYeMC"];//
        NSString *submitID  =(NSString *) [nc objectForKey:@"bianHao"];
        NSString *yeWuZL = (NSString *) [nc objectForKey:@"yeWuZLMC_cn"];
        NSString *yeWuZLBH = (NSString *) [nc objectForKey:@"yeWuZLBH"];
        NSString *ftn_ID = (NSString *) [nc objectForKey:@"ftn_ID"];
        NSString *userID = (NSString *) [nc objectForKey:@"userID"];
        NSString *hangYeFLBH =(NSString *) [nc objectForKey:@"hangYeFLBH"];
        NSString *hangYeFLMC =(NSString *) [nc objectForKey:@"hangYeFLMC_cn"];
        NSString *heTongJEStr =(NSString *) [nc objectForKey:@"heTongJEStr"];
        
        NSString *genZongSFJEStr =(NSString *) [nc objectForKey:@"genZongSFJEStr"];
        NSString *zhuChengXS =(NSString *) [nc objectForKey:@"zhuChengXS"];
        NSString *userName =(NSString *) [nc objectForKey:@"userName_cn"];
        NSString *lianXiFS =(NSString *) [nc objectForKey:@"lianXiFS"];
        NSLog(@"%@",userID);
        NSLog(@"ftn_ID%@",ftn_ID);
        NSLog(@"yeWuZLBH%@",yeWuZLBH);
        NSLog(@"yeWuZLBH%@",lianXiFS);
        submitTaskEntity *udetail =[[submitTaskEntity alloc] init];
        [udetail setSubmitName:submitName];
        [udetail setSubmitID:submitID];
        [udetail setYeWuZL:yeWuZL];
        [udetail setYeWuZLBH:yeWuZLBH];
        [udetail setFtn_ID:ftn_ID];
        [udetail setHangYeFLBH:hangYeFLBH];
        [udetail setHangYeFLMC:hangYeFLMC];
        [udetail setHeTongJE:heTongJEStr];
        [udetail setGenZongSFJE:genZongSFJEStr];
        [udetail setZhuChengXS:zhuChengXS];
        [udetail setUserName:userName];
        [udetail setLianXiFS:lianXiFS];
        
        submitTaskDetailViewController *uc =[[submitTaskDetailViewController alloc] init];
        [uc setSubmitTaskEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
        
        
    }else
    {
        NSDictionary *nc =[self singleUserInfo:(NSString *)[_uSubmitId objectForKey:[self.searchResultsData objectAtIndex:indexPath.row]]];
        
        NSString *submitName  =(NSString *) [nc objectForKey:@"qiYeMC"];
        NSString *submitID  =(NSString *) [nc objectForKey:@"bianHao"];
        
        submitTaskEntity *udetail =[[submitTaskEntity alloc] init];
        [udetail setSubmitName:submitName];
        [udetail setSubmitID:submitID];
        submitTaskDetailViewController*uc =[[submitTaskDetailViewController alloc] init];
        [uc setSubmitTaskEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

@end
