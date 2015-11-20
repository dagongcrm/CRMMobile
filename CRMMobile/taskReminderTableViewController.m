//
//  taskReminderTableViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/12.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "taskReminderTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MJRefresh.h"
#import "submitTaskEntity.h"
#import "auditDetailViewController.h"
#import "auditEntity.h"
#import "auditTableViewController.h"
#import "VisitPlanNsObj.h"
#import "PlanDetalViewController.h"
#import "activityDetailViewController.h"
#import "marketActivity.h"

@interface taskReminderTableViewController ()
@property (strong, nonatomic) NSMutableArray *searchResultsData;
@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *customerID;
@property (strong,nonatomic) NSMutableArray *visitorStr;
@property (strong,nonatomic) NSMutableArray *activityDateStr;
@property (strong,nonatomic) NSMutableArray *yeWuZLMC;
@property (strong,nonatomic) NSMutableArray *detail;
@property (strong, nonatomic) NSMutableArray *uid;
@property  NSInteger index;
@property NSString *str;

@property (strong, nonatomic) NSMutableArray *visitDate;
@property (strong, nonatomic) NSMutableArray *renWuTJSJStr;
@property (strong, nonatomic) NSMutableDictionary *uCustomerId;

@end

@implementation taskReminderTableViewController

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.customerID = [NSMutableArray array];
        self.visitorStr = [NSMutableArray array];
        self.activityDateStr = [NSMutableArray array];
        self.yeWuZLMC = [NSMutableArray array];
        self.detail = [NSMutableArray array];
        self.uid = [NSMutableArray array];
        self.visitDate = [NSMutableArray array];
        [self faker:@"1"];
        //[self faker:@"2"];
    }
    
    return _fakeData;
}
-(NSMutableArray *) faker: (NSString *) page{
    NSLog(@"%@",page);
    NSError *error;
    NSLog(@"1111111111");
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mTaskReminderAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@",page,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    NSString *teamname = @"";
    NSString *customerID = @"";
    NSString *visitorStr = @"";
    NSString *yeWuZLMC = @"";
    NSString *visitDate = @"";
    NSDictionary *listdic = @"";
    for (int i=0; i<[list count]; i++) {
        NSArray *listi = [list objectAtIndex:i];
        NSLog(@"%@",listi);
        if (i==0) {
            if ([listi count]!= 0) {
                
                for (int i = 0; i<[listi count]; i++) {
                    listdic = [listi objectAtIndex:i];
                    [self.uid addObject:listdic];
                    NSArray *keys = [listdic allKeys];
                    NSLog(@"%@",keys);
                    
                    if ( [keys containsObject:@"customerNameStr"]){
                        teamname = (NSString *)[listdic objectForKey:@"customerNameStr"];
                        customerID=(NSString *)[listdic objectForKey:@"customerCallPlanID"];//获取客户id
                        visitorStr = (NSString *)[listdic objectForKey:@"visitorStr"];
                        visitDate = (NSString *)[listdic objectForKey:@"visitDate"];
                    }

//                    NSString *teamname = (NSString *)[listdic objectForKey:@"customerNameStr"];//获取客户名称
//                    NSString *customerID=(NSString *)[listdic objectForKey:@"customerCallPlanID"];//获取客户id
//                    NSString *visitorStr = (NSString *)[listdic objectForKey:@"visitorStr"];
//                    NSString *visitDate = (NSString *)[listdic objectForKey:@"visitDate"];
                    NSLog(@"%@",teamname);
                    self.str = @"拜访人";
                    [self.fakeData       addObject:teamname];
                    [self.customerID     addObject:customerID];
                    [self.detail     addObject:visitorStr];
                    [self.visitDate  addObject:visitDate];
                }
            }
        }else if(i==1){
            
        }else if (i==2){
            if ([listi count] != 0) {if ([listi count] != 0) {
                for (int i = 0; i<[listi count]; i++) {
                    listdic = [listi objectAtIndex:i];
                    [self.uid addObject:listdic];
                    teamname = (NSString *)[listdic objectForKey:@"activityName"];//获取客户名称
                    customerID=(NSString *)[listdic objectForKey:@"activityID"];//获取客户id
                    NSLog(@"%@",teamname);
                    NSString *activityDateStr = (NSString *)[listdic objectForKey:@"activityDateStr"];
                    [self.fakeData       addObject:teamname];
                    [self.customerID     addObject:customerID];
                    [self.detail addObject:activityDateStr];
                    
                }
            }
                for (int i = 0; i<[listi count]; i++) {
                    listdic = [listi objectAtIndex:i];
                    [self.uid addObject:listdic];
                    NSArray *keys = [listdic allKeys];
                    NSLog(@"%@",keys);
                   // NSString *teamname = @"";
                    if ( [keys containsObject:@"qiYeMC"]){
                        teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];
                        customerID=(NSString *)[listdic objectForKey:@"bianHao"];//获取客户id
                        yeWuZLMC = (NSString *)[listdic objectForKey:@"yeWuZLMC_cn"];
                    }

                   // NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];//获取客户名称
//                    NSString *customerID=(NSString *)[listdic objectForKey:@"bianHao"];//获取客户id
//                    
//                    NSString *yeWuZLMC = (NSString *)[listdic objectForKey:@"yeWuZLMC"];
//                    NSString *renWuTJSJStr = (NSString *)[listdic objectForKey:@"renWuTJSJStr"];
                    self.str = @"业务种类 ";
                    
                    [self.fakeData       addObject:teamname];
                    [self.customerID     addObject:customerID];
                    [self.detail         addObject:yeWuZLMC];
//                    [self.renWuTJSJStr   addObject:renWuTJSJStr];
                    
                    
                }
               
            }
        }
    }
    [self customerIDReturn:self.customerID];
    NSLog(@"%@",self.fakeData);
    return self.fakeData;
}
-(NSMutableArray *) customerIDReturn: (NSMutableArray *) uidArr
{
    return self.customerID;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
   // self.uid=[NSMutableArray array];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"%@",self.fakeData);
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [self.fakeData objectAtIndex:indexPath.row];
   
    [cell.textLabel setText:[self.fakeData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"" stringByAppendingString:self.detail[indexPath.row]];
    [cell.detailTextLabel setText:testDetail];
    [cell.imageView setImage:[UIImage imageNamed:@"0.png"]];
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
    NSLog(@"%@************",p);
    [self faker:p];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self customerIDuserName :self.fakeData :self.customerID];
    NSDictionary *nc =[self singleUserInfo:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
    NSArray *key = [nc allKeys];
    NSLog(@"%@",key);
    
    NSDictionary *nc1 =[self singleUserInfo1:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
    NSArray *key1 = [nc1 allKeys];
    NSLog(@"%@",key1);
    
    NSDictionary *nc2 =[self singleUserInfo2:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
    NSArray *key2 = [nc2 allKeys];
    NSLog(@"%@",key2);
    
    if (key != nil) {
        NSString *customerCallPlanID =[self.customerID objectAtIndex:indexPath.row];
        NSString *customerNameStr  =[self.fakeData objectAtIndex:indexPath.row];
       
        auditEntity *ae =[[auditEntity alloc] init];
        [ae setSubmitName:customerNameStr];
        [ae setSubmitID:customerCallPlanID];
       
        auditDetailViewController *adc =[[auditDetailViewController alloc] init];
        [adc setAuditEntity:ae];
        [self.navigationController pushViewController:adc animated:YES];
    }
    if (key1 != nil) {
        NSString *customerCallPlanID =[self.customerID objectAtIndex:indexPath.row];
        NSString *customerNameStr  =[self.fakeData objectAtIndex:indexPath.row];
        //NSString *visitDate =[self.visitDate objectAtIndex:indexPath.row];
        //NSString *theme =[self.theme objectAtIndex:indexPath.row];;
         marketActivity *ma =[[marketActivity alloc] init];
        [ma setActivityName:customerNameStr];
        activityDetailViewController *avc =[[activityDetailViewController alloc] init];
        [avc setMarketActivity:ma];
        NSLog(@"%@",ma);
        [self.navigationController pushViewController:avc animated:YES];
    }
    if(key2 != nil){
    NSString *customerCallPlanID =[self.customerID objectAtIndex:indexPath.row];
    NSString *customerNameStr  =[self.fakeData objectAtIndex:indexPath.row];
    NSString *visitDate =[self.visitDate objectAtIndex:indexPath.row];
    //NSString *theme =[self.theme objectAtIndex:indexPath.row];;
    VisitPlanNsObj *visitPlan =[[VisitPlanNsObj alloc] init];
    [visitPlan setCustomerNameStr:customerNameStr];
    [visitPlan setCustomerCallPlanID:customerCallPlanID];
    [visitPlan setVisitDate:visitDate];
    //[visitPlan setTheme:theme];
    PlanDetalViewController *uc =[[PlanDetalViewController alloc] init];
    [uc setDailyEntity:visitPlan];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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