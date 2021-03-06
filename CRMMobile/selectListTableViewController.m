//
//  selectListTableViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "selectListTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MJRefresh.h"
#import "CustomerInfermationDetailMessageEntity.h"
#import "CustomerInformationDetailViewController.h"
#import "AddCustomerInformationViewController.h"
#import "selectEntity.h"
#import "addTaskViewController.h"
#import "editTaskViewController.h"

@interface selectListTableViewController ()
@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *customerID;
@property (strong, nonatomic) NSMutableArray *uid;
@property  NSInteger index;
@property (strong, nonatomic) NSMutableDictionary *uCustomerId;
@property (strong, nonatomic) NSMutableArray *searchResultsData;

@end

@implementation selectListTableViewController
@synthesize roleEntity=_roleEntity;
@synthesize CRMListData;

- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.customerID = [NSMutableArray array];
        [self faker:@"1"];
//        [self faker:@"2"];
    }
    return _fakeData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];    //上拉刷新下拉加在方法
    self.uid=[NSMutableArray array];
    //添加
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"确定"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(roleChoose)];
    [self.navigationItem setRightBarButtonItem:rightButton];
}
-(void)roleChoose
{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSLog(@"%@",indexPaths);
    selectEntity *rp=[[selectEntity alloc]init];
    NSMutableArray *rolePick = [NSMutableArray array];
    NSMutableArray *roleIdPick = [NSMutableArray array];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *string   = @"";
    NSString *IdString = @"";
    
    for (NSIndexPath *path in indexPaths)
    {
        [rolePick addObject:_fakeData[path.row]];
        [roleIdPick addObject:_customerID[path.row]];
    }
    
    for (NSString *str in rolePick)
    {
        string = [string stringByAppendingFormat:@"%@,",str];
    }
    
    for (NSString *str in roleIdPick)
    {
        IdString = [IdString stringByAppendingFormat:@"%@,",str];
    }
    
    [rp setStrChoose:string];
    [rp setRoleIdChoose:IdString];
    NSLog(@"%@",string);
    NSLog(@"%@",IdString);
    
//    addTaskViewController *addRole = [[addTaskViewController alloc] init];
//    [addRole setRoleEntity:rp];
//    [self.navigationController pushViewController: addRole animated:YES];
    
    if([appDelegate.controllerJudge isEqualToString:@"editUser"])
    {
        editTaskViewController *editUser = [[editTaskViewController alloc] init];
        [editUser setRoleEntity:rp];
        [self.navigationController pushViewController: editUser animated:YES];
    }else if([appDelegate.controllerJudge isEqualToString:@"addUser"])
    {
        addTaskViewController *addRole = [[addTaskViewController alloc] init];
        [addRole setRoleEntity:rp];
        [self.navigationController pushViewController: addRole animated:YES];
    }

}

-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mqiYeJBXXAction!datagrid.action?"]];
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
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    if(![list count] ==0)
    {
        
        self.tableView.footerRefreshingText=@"加载中";
    }else
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
    }
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        [self.uid addObject:listdic];
        NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];//获取客户名称
        NSString *customerID=(NSString *)[listdic objectForKey:@"bianHao"];//获取客户id        NSLog(@"%@",teamname);
        [self.fakeData     addObject:teamname];
        [self.customerID     addObject:customerID];
    }
    [self customerIDReturn:self.customerID];
    }
    return self.fakeData;
}

-(NSMutableArray *) customerIDReturn: (NSMutableArray *) uidArr
{
    return self.customerID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.fakeData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [self.fakeData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[self.fakeData objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
        return 50;
    }else{
        return 60;
    }
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
    NSLog(@"%@************",p);
    [self faker:p];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self customerIDuserName:self.fakeData :self.customerID];
//    
//    if (tableView == self.tableView)
//    {
//        
//        NSDictionary *nc =[self singleUserInfo:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
//        NSString *customerName  =(NSString *) [nc objectForKey:@"customerName"];
//        NSString *customerID  =(NSString *) [nc objectForKey:@"customerID"];
//        
//        CustomerInfermationDetailMessageEntity *udetail =[[CustomerInfermationDetailMessageEntity alloc] init];
//        [udetail setCustomerName:customerName];
//        [udetail setCustomerID:customerID];
//        CustomerInformationDetailViewController *uc =[[CustomerInformationDetailViewController alloc] init];
//        [uc setCustomerInformationEntity:udetail];
//        [self.navigationController pushViewController:uc animated:YES];
//        
//        
//    }else
//    {
//        NSDictionary *nc =[self singleUserInfo:(NSString *)[_uCustomerId objectForKey:[self.searchResultsData objectAtIndex:indexPath.row]]];
//        
//        NSString *customerName  =(NSString *) [nc objectForKey:@"customerName"];
//        NSString *customerID  =(NSString *) [nc objectForKey:@"customerID"];
//        
//        CustomerInfermationDetailMessageEntity *udetail =[[CustomerInfermationDetailMessageEntity alloc] init];
//        [udetail setCustomerName:customerName];
//        [udetail setCustomerID:customerID];
//        CustomerInformationDetailViewController *uc =[[CustomerInformationDetailViewController alloc] init];
//        [uc setCustomerInformationEntity:udetail];
//        [self.navigationController pushViewController:uc animated:YES];
//        
//    }
//}

// delcare id and index
-(void) customerIDuserName:(NSMutableArray *)utestname :(NSMutableArray *)customerID{
    _uCustomerId = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[utestname count];i++)
    {
        [_uCustomerId setObject:[customerID objectAtIndex:i] forKey:[utestname objectAtIndex:i]];
    }
}

// get a single user all message
-(NSDictionary *) singleUserInfo :(NSString *) customerIDIn{
    
    for (int z = 0; z<[self.uid count]; z++) {
        NSDictionary *listdic = [self.uid objectAtIndex:z];
        NSString     *customerID  = (NSString *)[listdic objectForKey:@"customerID"];
        if([customerID isEqualToString: customerIDIn])
        {
            return listdic;
        }
    }
    return  nil;
}

//tianjia
- (IBAction)addCustomerInfomation:(id)sender
{
    AddCustomerInformationViewController *jumpController = [[AddCustomerInformationViewController alloc] init];
    [self.navigationController pushViewController: jumpController animated:true];
    
}
@end
