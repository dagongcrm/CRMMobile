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
#import "ContactTableViewCell.h"
@interface CustomercontactTableViewController ()
@property (strong, nonatomic) NSMutableArray *fakeData;//用户联系人名称
@property (nonatomic, strong) NSMutableArray *contactData;//联系方式
@property (nonatomic, strong) NSMutableArray *customerNameStrData;//联系人公司名称
@property (nonatomic, strong) NSMutableArray *phoneData;//电话数据
@property (nonatomic, strong) NSMutableArray *positionData;//职务
@property (nonatomic, strong) NSDictionary *nc;
@property  NSInteger index;
@property  UIViewController *uiview;
@property (strong, nonatomic) NSMutableDictionary *uNameId;//
@property (strong, nonatomic) NSMutableArray *CustomerArr; // keep all message
@property (strong,nonatomic) NSMutableArray *contactIDData;//联系人id
@property (strong,nonatomic) CostomerContactEntity *contact;
@end

@implementation CustomercontactTableViewController
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        _contact =[[CostomerContactEntity alloc] init];
        _nc = [[NSDictionary alloc] init];
        self.fakeData   = [NSMutableArray array];
        self.contactData = [[NSMutableArray alloc]init];
        self.customerNameStrData = [[NSMutableArray alloc]init];
        self.phoneData = [[NSMutableArray array]init];
        self.contactIDData =[[NSMutableArray array]init];
        self.positionData =[[NSMutableArray array]init];
        [self faker:@"1"];
    }
    return _fakeData;
}

-(void) viewWillAppear:(BOOL)animated{
    _contact =[[CostomerContactEntity alloc] init];
    [self.CustomerArr removeAllObjects];
    [self.fakeData removeAllObjects];
    [self.contactData removeAllObjects];
    [self.customerNameStrData removeAllObjects];
    [self.phoneData removeAllObjects];
    [self.contactIDData removeAllObjects];
    [self.positionData removeAllObjects];
    self.index =1;
    [self faker:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"联系人管理";
    [self setupRefresh];
     self.CustomerArr = [[NSMutableArray alloc]init];
    //去掉返回的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self  action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addUser:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    self.tableView.tableFooterView=[[UIView alloc] init];
   
    self.tableView.delegate=self;
    self.tableView.dataSource=self;    
}

- (IBAction)addUser:(id)sender
{
    AddCustomerContactController *addCustomer = [[AddCustomerContactController alloc] init];
    [self.navigationController pushViewController: addCustomer animated:true];
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
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
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
    if ([list count]!=0) {
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        [self.CustomerArr addObject:listDic];
        NSString *contactName = (NSString *)[listDic objectForKey:@"contactName"];
        NSString *telePhone = (NSString *)[listDic objectForKey:@"telePhone"];
        NSString *customerNameStr = (NSString *)[listDic objectForKey:@"customerNameStr"];
         NSString *informationAttributionStr = (NSString *)[listDic objectForKey:@"informationAttributionStr"];
//        NSString *phoneTime = (NSString *)[listDic objectForKey:@"phoneTime"];
        NSString *contactID =(NSString *)[listDic objectForKey:@"contactID"];
        NSString *position = (NSString *)[listDic objectForKey:@"position"];
        
        if (contactName==nil||contactName==NULL) {
            contactName=@"null";
        }
        if (telePhone==nil||telePhone==NULL) {
            telePhone=@"null";
        }
        if (customerNameStr==nil||customerNameStr==NULL) {
            customerNameStr=@"null";
        }
        if (contactID==nil||contactID==NULL) {
            contactID=@"null";
        }
        if (informationAttributionStr==nil||informationAttributionStr==NULL) {
            informationAttributionStr=@"null";
        }
        [self.fakeData addObject:contactName];
        [self.contactData addObject:telePhone];
        [self.customerNameStrData addObject:customerNameStr];
        [self.contactIDData addObject:contactID];
        [self.positionData addObject:position];
    }
        
    }
    }
    return self.fakeData;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"contact";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil]lastObject];
    }
    cell.photo.image = [UIImage imageNamed:@"contact.png"];
    cell.lianxiR.text = self.fakeData[indexPath.row];
    cell.phone.text = (NSString *)[self.contactData objectAtIndex:indexPath.row];
    cell.company.text = [self.customerNameStrData objectAtIndex:indexPath.row];
    cell.position.text = [self.positionData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self userIduserName:self.fakeData :self.contactIDData];
    
    _nc =[self singleUserInfo:(NSString *)[_uNameId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
    NSLog(@"ncncncncncncncncncnc//////%@",_nc);
    NSString *customerNameStr  =(NSString *) [_nc objectForKey:@"customerNameStr"];//客户名称
    NSString *contactName =(NSString *) [_nc objectForKey:@"contactName"];//客户联系人
    NSString *telePhone =(NSString *) [_nc objectForKey:@"telePhone"];//电话
    NSString *department =(NSString *) [_nc objectForKey:@"department"];//部门
    NSString *position   =(NSString *) [_nc objectForKey:@"position"];
    NSString *evaluationOfTheSalesman    =(NSString *) [_nc objectForKey:@"evaluationOfTheSalesman"];
    NSString *informationAttributionStr    =(NSString *) [_nc objectForKey:@"informationAttributionStr"];
    NSString *informationAttribution    =(NSString *) [_nc objectForKey:@"informationAttribution"];
    NSString *guishuRStr   =(NSString *) [_nc objectForKey:@"guishuRStr"];
    NSString *guishuR   =(NSString *) [_nc objectForKey:@"guishuR"];
    NSString *contactState    =(NSString *) [_nc objectForKey:@"contactStateStr"];
     NSString *contactState1    =(NSString *) [_nc objectForKey:@"contactState"];
    NSString *tianjiaSJ    =(NSString *) [_nc objectForKey:@"tianjiaSJ"];
    NSString *contactID =(NSString *) [_nc objectForKey:@"contactID"];
    NSString *customerID = (NSString *) [_nc objectForKey:@"customerID"];
    NSLog(@"tianjiaSJtianjiaSJ%@",tianjiaSJ);
   
    [_contact setCustomerNameStr:customerNameStr];
    [_contact setContactName:contactName];
    [_contact setTelePhone:telePhone];
    [_contact setDepartment:department];
    [_contact setPosition:position];
    [_contact setEvaluationOfTheSalesman:evaluationOfTheSalesman];
    [_contact setInformationAttributionStr:informationAttributionStr];
    [_contact setInformationAttribution:informationAttribution];
    [_contact setGuishuRStr:guishuRStr];
    [_contact setGuishuR:guishuR];
    [_contact setContactState:contactState];
    [_contact setContactState1:contactState1];
    [_contact setTianjiaSJ:tianjiaSJ];
    [_contact setContactID:contactID];
    [_contact setCustomerID:customerID];
    CustomercontactInfoController *customerInfo = [[CustomercontactInfoController alloc]init];
    [customerInfo setContactEntity:_contact];
    [self.navigationController pushViewController:customerInfo animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

// get a single user all message
-(NSDictionary *) singleUserInfo :(NSString *) customerIdIn{
    for (int j = 0; j<[self.CustomerArr count]; j++) {
        NSDictionary *listdic = [self.CustomerArr objectAtIndex:j];
        NSString     *cid  = (NSString *)[listdic objectForKey:@"contactID"];
        if([cid isEqualToString: customerIdIn])
        {
            return listdic;
        }
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
