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

@interface auditTableViewController ()

@property (strong, nonatomic) NSMutableArray *bianHao;
@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *userIdData;
@property (strong, nonatomic) NSMutableArray *dataing;
@property (strong, nonatomic) NSMutableArray *time;
@property (strong, nonatomic) NSMutableArray *uid;

@property (strong, nonatomic) NSMutableArray *searchResultsData;

@property (strong, nonatomic) NSMutableDictionary *uAuditId;
@property  NSInteger index;

@end

@implementation auditTableViewController
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.bianHao=[[NSMutableArray alloc] init];
        self.fakeData=[[NSMutableArray alloc] init];
        self.dataing=[[NSMutableArray alloc] init];
        self.time=[[NSMutableArray alloc] init];
        self.uid=[[NSMutableArray alloc] init];

        [self faker:@"1"];
//        [self faker:@"2"];
        
    }
    return _fakeData;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"任务审核";
    [self setupRefresh];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage imageNamed:@"back002"] imageWithTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0, 0, 20, 20);
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ResView) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -5;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,rightItem];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
}

- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[WorkTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void) faker: (NSString *) page{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!renWuJBXXSHDatagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@",page,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        [self.uid addObject:listdic];
        NSString *bianHao = (NSString *)[listdic objectForKey:@"bianHao"];
        NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];
        NSLog(@"%@",teamname);
        NSString *userId   = (NSString *)[listdic objectForKey:@"yeWuZLMC_cn"];
        NSLog(@"%@",userId);
        NSString *time   = (NSString *)[listdic objectForKey:@"renWuTJSJStr"];
        [self.fakeData     addObject:teamname];
        [self.time   addObject:time];
        [self.dataing   addObject:userId];
        [self.bianHao addObject:bianHao];
    }
    //[self userIdReturn:self.userIdDahttp://172.16.21.42:8080/dagongcrm/ta];
    //return self.fakeData;
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
-(NSMutableArray *) submitIDReturn: (NSMutableArray *) uidArr
{
    return self.bianHao;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    APPDELEGATE.page = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [self.fakeData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[self.fakeData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"业务种类:" stringByAppendingString:self.dataing[indexPath.row]];
    NSString *testDetail1 =[@"  提交时间:" stringByAppendingString:self.time [indexPath.row]];
    NSString *str =[testDetail stringByAppendingString:testDetail1];
    [cell.detailTextLabel setText:str];
    [cell.imageView setImage:[UIImage imageNamed:@"gongsi.png"]];
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
        NSLog(@"%@",userID);

        NSLog(@"heTongJE%@",heTongJE);
        NSLog(@"lianXiFS%@",lianXiFS);
        NSLog(@"userName%@",userName);
        NSLog(@"heTongJE%@",zhuChengXS);
        //NSLog(@"lianXiFS%@",genZongSFJE);
        NSLog(@"userName%@",hangYeFLMC);
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
    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
        return 50;
    }else{
        return 60;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
