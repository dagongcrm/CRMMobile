//
//  auditTableViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/3.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "auditTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "auditEntity.h"
#import "auditDetailViewController.h"
#import "UIImage+Tint.h"
#import "MJRefresh.h"
#import "WorkTableViewController.h"
#import "taskCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD+NJ.h"
@interface auditTableViewController ()<MBProgressHUDDelegate>
@property (strong, nonatomic) NSMutableArray *bianHao;
@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *userIdData;
@property (strong, nonatomic) NSMutableArray *dataing;
@property (strong, nonatomic) NSMutableArray *time;
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong, nonatomic) NSMutableArray *searchResultsData;
@property (strong, nonatomic) NSMutableDictionary *uAuditId;
@property (strong, nonatomic) MBProgressHUD  *progress;

@property (assign) NSInteger index;
@end

@implementation auditTableViewController
//
//-(void) getTableData: (NSString *) page{
//    NSError *error;
//    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
//    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!renWuJBXXSHDatagrid.action?"]];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval=10.0;
//    request.HTTPMethod=@"POST";
//    NSLog(@"!!!!!%@",page);
//    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@",page,sid];
//    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
//        [alert show];
//    }else{
//        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        NSLog(@"%@",weatherDic);
//        NSArray *list = [weatherDic objectForKey:@"obj"];
//        for (int i = 0; i<[list count]; i++) {
//            NSDictionary *listdic = [list objectAtIndex:i];
//            [self.uid addObject:listdic];
//            NSString *bianHao  = (NSString *)[listdic objectForKey:@"bianHao"];
//            NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];
//            NSString *userId   = (NSString *)[listdic objectForKey:@"yeWuZLMC_cn"];
//            NSString *time     = (NSString *)[listdic objectForKey:@"renWuTJSJStr"];
//            [self.fakeData  addObject:teamname];
//            [self.time      addObject:time];
//            [self.dataing   addObject:userId];
//            [self.bianHao   addObject:bianHao];
//        }
//    }
//}

-(void) getDataAsy:(NSString *)page {
    self.progress.dimBackground=NO;
    self.progress.labelText=@"加载中，请稍后";
    [self.progress show:YES];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSDictionary *parameters = @{@"MOBILE_SID":sid,
                                 @"page":page};
    [manager POST:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!renWuJBXXSHDatagrid.action?"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSArray *list = [responseObject objectForKey:@"obj"];
            for (int i = 0;i<[list count];i++) {
                NSDictionary *listdic = [list objectAtIndex:i];
                [self.uid addObject:listdic];
                NSString *bianHao  = (NSString *)[listdic objectForKey:@"bianHao"];
                NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];
                NSString *userId   = (NSString *)[listdic objectForKey:@"yeWuZLMC_cn"];
                NSString *time     = (NSString *)[listdic objectForKey:@"renWuTJSJStr"];
                [self.fakeData  addObject:teamname];
                [self.time      addObject:time];
                [self.dataing   addObject:userId];
                [self.bianHao   addObject:bianHao];
            }
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
}

-(void) viewWillAppear:(BOOL)animated{
    self.progress=[[MBProgressHUD alloc] initWithView:self.view];
    self.progress.progress=0.4;
    [self.view addSubview:self.progress];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bianHao=[[NSMutableArray alloc] init];
        self.fakeData=[[NSMutableArray alloc] init];
        self.dataing=[[NSMutableArray alloc] init];
        self.time=[[NSMutableArray alloc] init];
        self.uid=[[NSMutableArray alloc] init];
        [self.fakeData removeAllObjects];
        [self.bianHao  removeAllObjects];
        [self.dataing  removeAllObjects];
        [self.time     removeAllObjects];
        [self.uid      removeAllObjects];
        [self getDataAsy:@"1"];
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

-(void) setUpUI{
    self.title=@"任务审核";
    [self setupRefresh];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
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


- (void)headerRereshing{
    [self.fakeData removeAllObjects];
    self.index =1;
    [self getDataAsy:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    [self getDataAsy:p];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
    
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
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    APPDELEGATE.page = @"";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];}
//    NSDictionary *item = [self.fakeData objectAtIndex:indexPath.row];
//    [cell.textLabel setText:[self.fakeData objectAtIndex:indexPath.row]];
//    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    NSString *testDetail =[@"业务种类:" stringByAppendingString:self.dataing[indexPath.row]];
//    NSString *testDetail1 =[@"  提交时间:" stringByAppendingString:self.time [indexPath.row]];
//    NSString *str =[testDetail stringByAppendingString:testDetail1];
//    [cell.detailTextLabel setText:str];
//    [cell.imageView setImage:[UIImage imageNamed:@"gongsi.png"]];
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    static NSString * cellId = @"taskCell";
    taskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"taskCell" owner:self options:nil]lastObject];
    }
    NSDictionary *cbr = [self.uid objectAtIndex:indexPath.row];
    NSString *cbrName = (NSString *)[cbr objectForKey:@"userName_cn"];
    cell.myImg.image = [UIImage imageNamed:@"任务审核1.png"];
    cell.mylbl1.text = [self.fakeData objectAtIndex:indexPath.row];
    cell.mylbl2.text = cbrName;
    cell.mylbl3.text = self.time [indexPath.row];
    return cell;

}
-(void) auditIDuserName:(NSMutableArray *)utestname :(NSMutableArray *)auditID{
    _uAuditId = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[utestname count];i++)
    {
        [_uAuditId setObject:[auditID objectAtIndex:i] forKey:[utestname objectAtIndex:i]];
    }
}
-(NSDictionary *) singleUserInfo :(NSString *) auditIDIn{
    NSLog(@"%@",self.uid);
    for (int z = 0; z<[self.uid count]; z++) {
        NSDictionary *listdic = [self.uid objectAtIndex:z];
        NSString     *auditID  = (NSString *)[listdic objectForKey:@"bianHao"];
        if([auditID isEqualToString: auditIDIn])
        {
            return listdic;
        }
    }
    return  nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self auditIDuserName:self.fakeData :self.bianHao];
    NSLog(@"%@",self.fakeData);
    NSLog(@"%@",self.bianHao);
    
    if (tableView == self.tableView)
    {
        
        NSDictionary *nc =[self singleUserInfo:(NSString *)[_uAuditId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
        NSLog(@"%@",nc);
        NSString *submitName  =(NSString *) [nc objectForKey:@"qiYeMC"];
        NSString *submitID  =(NSString *) [nc objectForKey:@"bianHao"];
        NSString *yeWuZL = (NSString *) [nc objectForKey:@"yeWuZLMC_cn"];
        NSString *yeWuZLBH = (NSString *) [nc objectForKey:@"yeWuZLBH"];
        NSString *ftn_ID = (NSString *) [nc objectForKey:@"ftn_ID"];
        NSString *loginName = (NSString *) [nc objectForKey:@"loginName"];
        NSString *userID = (NSString *) [nc objectForKey:@"userID"];
        NSString *hangYeFLMC =  (NSString *)[nc objectForKey:@"hangYeFLMC_cn"];
        NSString *heTongJE = (NSString *)[nc objectForKey:@"heTongJEStr"];
        NSString *genZongSF = (NSString *)[nc objectForKey:@"genZongSF"];
        NSString *genZongSFJE = (NSString *)[nc objectForKey:@"genZongSFJEStr"];
        NSString *zhuChengXS = (NSString *)[nc objectForKey:@"zhuChengXS"];
        NSString *userName = (NSString *)[nc objectForKey:@"userName_cn"];
        NSString *lianXiFS = (NSString *)[nc objectForKey:@"lianXiFS"];
        auditEntity *udetail =[[auditEntity alloc] init];
        if (submitName != nil) {
            [udetail setSubmitName:submitName];
        }else{
        [udetail setSubmitName:@" "];
        }
        
        [udetail setSubmitID:submitID];
        [udetail setYeWuZL:yeWuZL];
        [udetail setYeWuZLBH:yeWuZLBH];
        [udetail setFtn_ID:ftn_ID];
        [udetail setUserID:userID];
        [udetail setGenZongSF:genZongSF];
        [udetail setGenZongSFJE:genZongSFJE];
        if (hangYeFLMC != nil) {
            [udetail setHangYeFLMC:hangYeFLMC];
        }else{
            [udetail setHangYeFLMC:@" "];
        }
        if (heTongJE != nil) {
            [udetail setHeTongJE:heTongJE];
        }else{
            [udetail setHeTongJE:@" "];
        }
//        if (genZongSFJE != nil) {
//            [udetail setGenZongSFJE: genZongSFJE];
//        }else{
//            [udetail setGenZongSFJE: @"genZongSFJE"];
//        }
        if (zhuChengXS != nil) {
            [udetail setZhuChengXS:zhuChengXS];
        }else{
            [udetail setZhuChengXS:@"zhuChengXS"];
        }
        if (userName != nil) {
            [udetail setUserName:userName];
        }else{
            [udetail setUserName:@"userName"];
        }
        if (lianXiFS != nil) {
            [udetail setLianXiFS:lianXiFS];
        }else{
            [udetail setLianXiFS:@" "];
        }
        auditDetailViewController *uc =[[auditDetailViewController alloc] init];
        [uc setAuditEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
        
        
    }else
    {
        NSDictionary *nc =[self singleUserInfo:(NSString *)[_uAuditId objectForKey:[self.searchResultsData objectAtIndex:indexPath.row]]];
        NSString *submitName  =(NSString *) [nc objectForKey:@"qiYeMC"];
        NSString *submitID  =(NSString *) [nc objectForKey:@"bianHao"];
        auditEntity *udetail =[[auditEntity alloc] init];
        [udetail setSubmitName:submitName];
        [udetail setSubmitID:submitID];
        auditDetailViewController*uc =[[auditDetailViewController alloc] init];
        [uc setAuditEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
@end
