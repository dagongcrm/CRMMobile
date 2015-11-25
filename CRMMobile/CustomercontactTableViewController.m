//
//  CustomercontactTableViewController.m
//  CRMMobile
//
//  Created by why on 15/11/16.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CustomercontactTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "UIImage+Tint.h"
#import "CRMTableViewController.h"
#import "CustomercontactInfoController.h"
#import "MJRefresh.h"
#import "CostomerContactEntity.h"
#import "AddCustomerContactController.h"
@interface CustomercontactTableViewController ()
@property (strong, nonatomic) NSMutableArray *fakeData;//用户联系人名称
@property (nonatomic, strong) NSMutableArray *contactData;//联系方式
@property (nonatomic, strong) NSMutableArray *customerNameStrData;//联系人公司名称
@property (nonatomic, strong) NSMutableArray *phoneData;//电话数据
@property  NSInteger index;
@property  UIViewController *uiview;
@property (strong, nonatomic) NSMutableDictionary *uNameId;//
@property (strong, nonatomic) NSMutableArray *CustomerArr; // keep all message
@property (strong,nonatomic) NSMutableArray *contactIDData;//联系人id
@end

@implementation CustomercontactTableViewController
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [NSMutableArray array];
        self.contactData = [[NSMutableArray alloc]init];
        self.customerNameStrData = [[NSMutableArray alloc]init];
        self.phoneData = [[NSMutableArray alloc]init];
        self.contactIDData =[[NSMutableArray alloc]init];
        [self faker:@"1"];
        [self faker:@"2"];
    }
    return _fakeData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"联系人管理";
    [self setupRefresh];
     self.CustomerArr = [[NSMutableArray alloc]init];
    //设置导航栏返回
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addUser:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    [self setExtraCellLineHidden:self.tableView];
    
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
        if ([controller isKindOfClass:[CRMTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


- (IBAction)addUser:(id)sender
{
    AddCustomerContactController *addCustomer = [[AddCustomerContactController alloc] init];
    [self.navigationController pushViewController: addCustomer animated:true];
}
// hide the extraLine
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
}

-(NSMutableArray *) faker: (NSString *) page{
   
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"tianjiaSJ";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@&order=%@&sort=%@",sid,page,order,sort];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *contactDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"contactDic字典里面的内容为--》%@", contactDic);
    NSArray *list = [contactDic objectForKey:@"obj"];
    if(![list count] ==0)
    {
        self.tableView.footerRefreshingText=@"加载中";
    }else
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
    }

    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        [self.CustomerArr addObject:listDic];
        NSString *contactName = (NSString *)[listDic objectForKey:@"contactName"];
        NSString *telePhone = (NSString *)[listDic objectForKey:@"telePhone"];
        NSString *customerNameStr = (NSString *)[listDic objectForKey:@"customerNameStr"];
//        NSString *phoneTime = (NSString *)[listDic objectForKey:@"phoneTime"];
        NSString *contactID =(NSString *)[listDic objectForKey:@"contactID"];
        if (contactName.length==0) {
            contactName=@"暂无数据";
        }
        [self.fakeData addObject:contactName];
        [self.contactData addObject:telePhone];
        [self.customerNameStrData addObject:customerNameStr];
        [self.contactIDData addObject:contactID];
    }
    return self.fakeData;
}

//用户id
//-(NSMutableArray *) userIdReturn: (NSMutableArray *) uidArr
//{
//    return self.userIdData;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"arrow-left"]];
    cell.textLabel.text = self.fakeData[indexPath.row];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"客户名称:" stringByAppendingString:(NSString *)[self.customerNameStrData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText:testDetail];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self userIduserName:self.fakeData :self.contactIDData];
    
    NSDictionary *nc =[self singleUserInfo:(NSString *)[_uNameId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
    NSLog(@"ncncncncncncncncncnc//////%@",nc);
    NSString *customerNameStr  =(NSString *) [nc objectForKey:@"customerNameStr"];
    NSString *contactName =(NSString *) [nc objectForKey:@"contactName"];
    NSString *telePhone =(NSString *) [nc objectForKey:@"telePhone"];
    NSString *department =(NSString *) [nc objectForKey:@"department"];
    NSString *position   =(NSString *) [nc objectForKey:@"position"];
    NSString *evaluationOfTheSalesman    =(NSString *) [nc objectForKey:@"evaluationOfTheSalesman"];
    NSString *informationAttributionStr    =(NSString *) [nc objectForKey:@"informationAttributionStr"];
    NSString *guishuRStr   =(NSString *) [nc objectForKey:@"guishuRStr"];
    NSString *contactState    =(NSString *) [nc objectForKey:@"contactStateStr"];
    NSString *tianjiaSJ    =(NSString *) [nc objectForKey:@"tianjiaSJ"];
    NSString *contactID =(NSString *) [nc objectForKey:@"contactID"];
    NSLog(@"tianjiaSJtianjiaSJ%@",tianjiaSJ);
    CostomerContactEntity *contact =[[CostomerContactEntity alloc] init];
    [contact setCustomerNameStr:customerNameStr];
    [contact setContactName:contactName];
    [contact setTelePhone:telePhone];
    [contact setDepartment:department];
    [contact setPosition:position];
    [contact setEvaluationOfTheSalesman:evaluationOfTheSalesman];
    [contact setInformationAttributionStr:informationAttributionStr];
    [contact setGuishuRStr:guishuRStr];
    [contact setContactState:contactState];
    [contact setTianjiaSJ:tianjiaSJ];
    [contact setContactID:contactID];
    CustomercontactInfoController *customerInfo = [[CustomercontactInfoController alloc]init];
    [customerInfo setContactEntity:contact];
    [self.navigationController pushViewController:customerInfo animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}
// get a single user all message
-(NSDictionary *) singleUserInfo :(NSString *) customerIdIn{
    NSLog(@"wkwkwkwkkwkwkwwkk");
    for (int j = 0; j<[self.CustomerArr count]; j++) {
        NSDictionary *listdic = [self.CustomerArr objectAtIndex:j];
        NSString     *cid  = (NSString *)[listdic objectForKey:@"contactID"];
        if([cid isEqualToString: customerIdIn])
        {
            return listdic;
        }
        NSLog(@"///////////////%@",listdic);
    }
    return  nil;
}

// delcare id and index
-(void) userIduserName:(NSMutableArray *)utestname :(NSMutableArray *)userId{
    NSLog(@"utestname======%@",utestname);
    NSLog(@"userId======%@",userId);
    _uNameId = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[utestname count];i++)
    {
        [_uNameId setObject:[userId objectAtIndex:i] forKey:[utestname objectAtIndex:i]];
    }
}
@end
