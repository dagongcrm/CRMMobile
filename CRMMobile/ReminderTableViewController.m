//
//  ReminderTableViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "ActivityViewController.h"
#import "activityEntity.h"
#import "auditDetailViewController.h"
#import "activityEntity.h"
#import "auditTableViewController.h"
#import "marketActivity.h"
#import "activityDetailViewController.h"
#import "ReminderDetailViewController.h"
#import "submitTaskEntity.h"
#import "ReminderEntity.h"
#import "ReminderTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MJRefresh.h"
#import "UIImage+Tint.h"
#import "GLReusableViewController.h"
@interface ReminderTableViewController ()
{
    UISearchDisplayController *mySearchDisplayController;
}
@property (strong, nonatomic) NSMutableArray *searchResultsData;
@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *customerID;
@property (strong,nonatomic) NSMutableArray *visitorStr;

@property (strong,nonatomic) NSMutableArray *detail;
@property (strong, nonatomic) NSMutableArray *uid;
@property  NSInteger index;
@property NSString *str;

//任务审核
@property (strong,nonatomic) NSMutableArray *yeWuZLMC;
@property (strong,nonatomic) NSMutableArray *hangYeFLMC;
@property (strong,nonatomic) NSMutableArray *heTongJE;
@property (strong,nonatomic) NSMutableArray *genZongSFJEStr;
@property (strong,nonatomic) NSMutableArray *zhuChengXS;
@property (strong,nonatomic) NSMutableArray *userName;
@property (strong,nonatomic) NSMutableArray *lianXiFS;

//活动
@property (strong,nonatomic) NSMutableArray *activityDateStr;
@property (strong,nonatomic) NSMutableArray *activityAddress;
@property (strong,nonatomic) NSMutableArray *activityContent;
@property (strong,nonatomic) NSMutableArray *responsibleDepartmentStr;
@property (strong,nonatomic) NSMutableArray *responsibleDepartmentPersonStr;
@property (strong,nonatomic) NSMutableArray *activitySketch;
@property (strong,nonatomic) NSMutableArray *activityCost;

@property (strong, nonatomic) NSMutableArray *renWuTJSJStr;
@property (strong, nonatomic) NSMutableDictionary *uCustomerId;

@end
@implementation ReminderTableViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.customerID = [NSMutableArray array];
        
        self.yeWuZLMC = [NSMutableArray array];
        self.detail = [NSMutableArray array];
        self.uid = [NSMutableArray array];
        self.renWuTJSJStr = [NSMutableArray array];
        self.hangYeFLMC= [NSMutableArray array];
        self.heTongJE = [NSMutableArray array];
        self.genZongSFJEStr = [NSMutableArray array];
        self.zhuChengXS = [NSMutableArray array];
        self.userName = [NSMutableArray array];
        self.lianXiFS = [NSMutableArray array];
        
        self.activityDateStr = [NSMutableArray array];
        self.activityAddress= [NSMutableArray array];
        self.activityContent = [NSMutableArray array];
        self.responsibleDepartmentStr = [NSMutableArray array];
        self.responsibleDepartmentPersonStr = [NSMutableArray array];
        self.activitySketch = [NSMutableArray array];
        self.activityCost = [NSMutableArray array];
        [self faker:@"1"];
    }
    return _fakeData;
}


-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mTaskReminderAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@",page,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *list = [weatherDic objectForKey:@"obj"];
    NSString *teamname = @"";
    NSString *customerID = @"";
    NSDictionary *listdic = [[NSDictionary alloc] init];
    
    for (int i=0; i<[list count]; i++) {
        NSArray *listi = [list objectAtIndex:i];
        if(i==1){
            if ([listi count] != 0) {
                for (int i = 0; i<[listi count]; i++) {
                    listdic = [listi objectAtIndex:i];
                    [self.uid addObject:listdic];
                    teamname = (NSString *)[listdic objectForKey:@"activityName"];//获取客户名称
                    customerID=(NSString *)[listdic objectForKey:@"activityID"];//获取客户id
                    NSString *activityDateStr = (NSString *)[listdic objectForKey:@"activityDateStr"];
                    NSString *activityAddress = (NSString *)[listdic objectForKey:@"activityAddress"];
                    
                    float Cost = (float)[listdic [@"activityCost"]floatValue];
                    NSString *activityCost = [NSString stringWithFormat:@"%0.2f",Cost];
                    NSString *activityContent = (NSString *)[listdic objectForKey:@"activityContent"];
                    NSString *responsibleDepartmentStr = (NSString *)[listdic objectForKey:@"responsibleDepartmentStr"];
                    NSString *responsibleDepartmentPersonStr = (NSString *)[listdic objectForKey:@"responsibleDepartmentPersonStr"];
                    NSString *activitySketch = (NSString *)[listdic objectForKey:@"activitySketch"];
                
                    self.str = @"活动时间： ";
                    [self.fakeData       addObject:teamname];
                    [self.customerID     addObject:customerID];
                    [self.detail         addObject:activityDateStr];
                    [self.activityAddress       addObject:activityAddress];
                    [self.activityCost          addObject:activityCost];
                    [self.activityContent       addObject:activityContent];
                    [self.responsibleDepartmentStr           addObject:responsibleDepartmentStr];
                    [self.responsibleDepartmentPersonStr     addObject:responsibleDepartmentPersonStr];
                    [self.activitySketch                     addObject:activitySketch];
                }
            }
        }
        else if (i==2){
            if(![listi isKindOfClass:[NSNull class]]){
            if([listi count]!=0){
                for (int i = 0; i<[listi count]; i++) {
                    NSDictionary *listdic = [listi objectAtIndex:i];
                    [self.uid addObject:listdic];
                    NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];//获取客户名称
                    NSString *customerID=(NSString *)[listdic objectForKey:@"bianHao"];//获取客户id
                    NSString *yeWuZLMC = (NSString *)[listdic objectForKey:@"yeWuZLMC_cn"];
                    NSString *hangYeFLMC = (NSString *)[listdic objectForKey:@"hangYeFLMC"];
                    NSString *heTongJE = (NSString *)[listdic objectForKey:@"heTongJEStr"];
                    NSString *genZongSFJEStr = (NSString *)[listdic objectForKey:@"genZongSFJEStr"];
                    NSString *zhuChengXS = (NSString *)[listdic objectForKey:@"zhuChengXS"];
                    NSString *userName = (NSString *)[listdic objectForKey:@"userName"];
                    NSString *lianXiFS = (NSString *)[listdic objectForKey:@"lianXiFS"];
                    NSString *renWuTJSJStr = (NSString *)[listdic objectForKey:@"renWuTJSJStr"];
                    
                    self.str = @"业务种类： ";
                    if (teamname==nil||teamname==NULL) {
                        teamname = @"";
                    }
                    if (genZongSFJEStr==nil||genZongSFJEStr==NULL) {
                        genZongSFJEStr = @"";
                    }
                    if (customerID==nil||customerID==NULL) {
                        customerID = @"";
                    }
                    if (hangYeFLMC==nil||hangYeFLMC==NULL) {
                        hangYeFLMC = @"";
                    }
                    if (yeWuZLMC==nil||yeWuZLMC==NULL) {
                        yeWuZLMC= @"";
                    }
                    if (zhuChengXS==nil||zhuChengXS==NULL) {
                        zhuChengXS = @"";
                    }
                    if (heTongJE==nil||heTongJE==NULL) {
                        heTongJE = @"";
                    }
                    if (lianXiFS==nil||lianXiFS==NULL) {
                        lianXiFS= @"";
                    }

                    [self.fakeData       addObject:teamname];
                    [self.customerID     addObject:customerID];
                    [self.detail         addObject:yeWuZLMC];
                    [self.renWuTJSJStr   addObject:renWuTJSJStr];
                    [self.hangYeFLMC       addObject:hangYeFLMC];
                    [self.heTongJE     addObject:heTongJE];
                    if (genZongSFJEStr==nil||genZongSFJEStr==NULL) {
                        genZongSFJEStr = @"";
                    }
                    [self.genZongSFJEStr         addObject:genZongSFJEStr];
                    if (zhuChengXS==nil||zhuChengXS==NULL) {
                        zhuChengXS = @"";
                    }
                    [self.zhuChengXS   addObject:zhuChengXS];
                    [self.userName         addObject:userName];
                    [self.lianXiFS   addObject:lianXiFS];
                }
             }else{
                [self.fakeData  addObject: @"nullobject"];
            }

            }
        }
    }

    [self customerIDReturn:self.customerID];
    }
    return self.fakeData;
}
-(NSMutableArray *) customerIDReturn: (NSMutableArray *) uidArr
{
    return self.customerID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.separatorStyle = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if([[self.fakeData objectAtIndex:0] isEqualToString:@"nullobject"])
        {
        return 0 ;
        }
    
    return  [self.fakeData count];
    
    
}

//刷新
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
    myDelegate.index =2;
    [self faker:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if(myDelegate.index==0){
        myDelegate.index=2;
    }
    self.index=myDelegate.index++;
    NSString *p= [NSString stringWithFormat: @"%ld", (long)self.index];
    [self faker:p];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    [cell.textLabel setText:[self.fakeData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSLog(@"%@",self.detail[indexPath.row]);
    NSString *testDetail =[self.detail[indexPath.row] length]==0?@" ":self.detail[indexPath.row];
    [cell.detailTextLabel setText:testDetail];
    [cell.imageView setImage:[UIImage imageNamed:@"business.png"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self customerIDuserName :self.fakeData :self.customerID];
    NSDictionary *nc =[self singleUserInfo:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
    NSArray *key = [nc allKeys];
  
    
    NSDictionary *nc1 =[self singleUserInfo1:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
    NSArray *key1 = [nc1 allKeys];
    
//    NSDictionary *nc2 =[self singleUserInfo2:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
//    NSArray *key2 = [nc2 allKeys];
    
    if (key != nil) {
        NSDictionary *nc =[self singleUserInfo:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
        NSString *submitName  =(NSString *) [nc objectForKey:@"qiYeMC"];
        NSString *submitID  =(NSString *) [nc objectForKey:@"bianHao"];
        NSString *yeWuZL = (NSString *) [nc objectForKey:@"yeWuZLMC_cn"];
        NSString *yeWuZLBH = (NSString *) [nc objectForKey:@"yeWuZLBH"];
        NSString *ftn_ID = (NSString *) [nc objectForKey:@"ftn_ID"];
        NSString *userID = (NSString *) [nc objectForKey:@"userID"];
        NSString *hangYeFLMC =  (NSString *)[nc objectForKey:@"hangYeFLMC_cn"];
        NSString *heTongJE = (NSString *)[nc objectForKey:@"heTongJEStr"];
        NSString *genZongSF = (NSString *)[nc objectForKey:@"genZongSF"];
        NSString *genZongSFJE = (NSString *)[nc objectForKey:@"genZongSFJEStr"];
        NSString *zhuChengXS = (NSString *)[nc objectForKey:@"zhuChengXS"];
        NSString *userName = (NSString *)[nc objectForKey:@"userName_cn"];
        NSString *lianXiFS = (NSString *)[nc objectForKey:@"lianXiFS"];
 
        if (submitName==nil||submitName==NULL) {
            submitName = @"";
        }
        if (genZongSFJE==nil||genZongSFJE==NULL) {
            genZongSFJE = @"";
        }
        if (submitID ==nil||submitID ==NULL) {
            submitID  = @"";
        }
        if (hangYeFLMC==nil||hangYeFLMC==NULL) {
            hangYeFLMC = @"";
        }
        if (yeWuZL==nil||yeWuZL==NULL) {
            yeWuZL = @"";
        }
        if (zhuChengXS==nil||zhuChengXS==NULL) {
            zhuChengXS = @"";
        }
        if (heTongJE==nil||heTongJE==NULL) {
            heTongJE = @"";
        }
        if (lianXiFS==nil||lianXiFS==NULL) {
            lianXiFS= @"";
        }
        
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
        if (genZongSFJE != nil) {
            [udetail setGenZongSFJE: genZongSFJE];
        }else{
            [udetail setGenZongSFJE: @" "];
        }
        if (zhuChengXS != nil) {
            [udetail setZhuChengXS:zhuChengXS];
        }else{
            [udetail setZhuChengXS:@" "];
        }
        if (userName != nil) {
            [udetail setUserName:userName];
        }else{
            [udetail setUserName:@" "];
        }
        if (lianXiFS != nil) {
            [udetail setLianXiFS:lianXiFS];
        }else{
            [udetail setLianXiFS:@" "];
        }
        
         ReminderDetailViewController *uc =[[ReminderDetailViewController alloc] init];
        [uc setAuditEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
        
        
    }
    if (key1 != nil) {
        
        NSDictionary *nc =[self singleUserInfo1:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
        NSString *activityID  =(NSString *) [nc objectForKey:@"activityID"];
        NSString *activityName =(NSString *) [nc objectForKey:@"activityName"];
        NSString *activityDateStr = (NSString *) [nc objectForKey:@"activityDateStr"];
        NSString *activityAddress  =(NSString *) [nc objectForKey:@"activityAddress"];
        float Cost = (float)[nc [@"activityCost"]floatValue];
        
        NSString *activityCost = [NSString stringWithFormat:@"%0.2f",Cost];
        NSString *activityContent = (NSString *) [nc objectForKey:@"activityContent"];
        
        NSString *responsibleDepartmentStr= (NSString *) [nc objectForKey:@"responsibleDepartmentStr"];
        NSString *responsibleDepartmentPersonStr = (NSString *) [nc objectForKey:@"responsibleDepartmentPersonStr"];
        NSString *activitySketch = (NSString *) [nc objectForKey:@"activitySketch"];
        if (activityName==nil||activityName==NULL) {
            activityName = @"";
        }
        if (activityDateStr==nil||activityDateStr==NULL) {
            activityDateStr = @"";
        }
        if (activityAddress==nil||activityAddress==NULL) {
            activityAddress = @"";
        }
        if (activityCost==nil||activityCost==NULL) {
            activityCost = @"";
        }
        if (activityContent==nil||activityContent==NULL) {
            activityContent = @"";
        }
        if (responsibleDepartmentStr==nil||responsibleDepartmentStr==NULL) {
            responsibleDepartmentStr = @"";
        }
        if (responsibleDepartmentPersonStr==nil||responsibleDepartmentPersonStr==NULL) {
            responsibleDepartmentPersonStr = @"";
        }
        if (activitySketch==nil||activitySketch==NULL) {
            activitySketch = @"";
        }
        
        activityEntity *udetail =[[activityEntity alloc] init];
        [udetail setActivityID:activityID];
        [udetail setActivityName:activityName];
        [udetail setActivityDateStr:activityDateStr];
        [udetail setActivityAddress:activityAddress];
        [udetail setActivityCost:activityCost];
        [udetail setActivityContent:activityContent];
        [udetail setResponsibleDepartmentPersonStr:responsibleDepartmentPersonStr];
        [udetail setResponsibleDepartmentStr:responsibleDepartmentStr];
        [udetail setActivitySketch:activitySketch];
        
        ActivityViewController *uc =[[ActivityViewController alloc] init];
        [uc setActivityEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
    }
    
    
}

-(void) customerIDuserName:(NSMutableArray *)utestname :(NSMutableArray *)customerID{
    _uCustomerId = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[utestname count];i++)
        {
        [_uCustomerId setObject:[customerID objectAtIndex:i] forKey:[utestname objectAtIndex:i]];
        }
}

-(NSDictionary *) singleUserInfo :(NSString *) submitIDIn{
    
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

-(NSDictionary *) singleUserInfo1 :(NSString *) submitIDIn{
    
    for (int z = 0; z<[self.uid count]; z++) {
        NSDictionary *listdic = [self.uid objectAtIndex:z];
        
        NSString *submitID1 = (NSString *)[listdic objectForKey:@"activityID"];
        if([submitID1 isEqualToString: submitIDIn])
            {
            return listdic;
            }
    }
    return  nil;
}

-(NSDictionary *) singleUserInfo2 :(NSString *) submitIDIn{
    
    for (int z = 0; z<[self.uid count]; z++) {
        NSDictionary *listdic = [self.uid objectAtIndex:z];
        NSString *submitID2 = (NSString *)[listdic objectForKey:@"customerCallPlanID"];
        if([submitID2 isEqualToString: submitIDIn])
            {
            return listdic;
            }
    }
    return  nil;
}

@end