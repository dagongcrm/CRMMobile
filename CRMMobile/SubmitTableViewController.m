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

@interface SubmitTableViewController ()

@property (strong, nonatomic) NSMutableArray *bianHao;
@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *userIdData;
@property (strong, nonatomic) NSMutableArray *dataing;
@property (strong, nonatomic) NSMutableArray *time;
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong, nonatomic) NSMutableArray *searchResultsData;

@property (strong, nonatomic) NSMutableDictionary *uSubmitId;
@property  NSInteger index;

//@property (strong, nonatomic) NSMutableArray *yeWuZLBH;

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
        [self faker:@"2"];
        
    }
    return _fakeData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"任务提交";
    [self setupRefresh];
    [self leftButtonInit];
}
-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
   
    //self.yeWuZLBH=[[NSMutableArray alloc] init];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!renWuJBXXTJDatagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@&zhuangTai=0",page,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
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
        [self.fakeData     addObject:teamname];
        [self.time   addObject:time];
        [self.dataing   addObject:userId];
        [self.bianHao addObject:submitID];
        //[self.yeWuZLBH addObject:yeWuZLBH];
    }
    [self submitIDReturn:self.bianHao];
    return self.fakeData;
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
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
        return [self.fakeData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
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
    NSLog(@"%@",str);
    [cell.detailTextLabel setText:str];
    [cell.imageView setImage:[UIImage imageNamed:@"gongsi.png"]];
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage imageNamed:@"back002.png"] imageWithTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ResView) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,rightItem];
    
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
        NSLog(@"yeWuZLBH%@",hangYeFLMC);
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
