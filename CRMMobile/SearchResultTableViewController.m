//
//  CustomerInformationTableViewController.m
//  CRMMobile
//
//  Created by yd on 15/10/27.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MJRefresh.h"
#import "CustomerInfermationDetailMessageEntity.h"
#import "CustomerInformationDetailViewController.h"
#import "AddCustomerInformationViewController.h"
#import "UIImage+Tint.h"
#import "CRMTableViewController.h"
#import "InformationTableViewCell.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface SearchResultTableViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *fakeData;  //客户名称数组
@property (strong, nonatomic) NSMutableArray *customerID;   //客户id数组
@property (strong, nonatomic) NSMutableArray *industryIDStr;  //所属行业数组
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong, nonatomic) NSMutableArray *searchResultsData;
@property (strong, nonatomic) NSMutableDictionary *uCustomerId;
@property (strong, nonatomic) NSMutableArray *phoneData;//客户电话
@property (strong, nonatomic) NSMutableArray *addressData;//客户地址
@property (nonatomic, strong) UISearchBar    *searchBar;
@property (strong,nonatomic) UITableView     *tableView;
@property  NSInteger index;
@end

@implementation SearchResultTableViewController
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData   = [[NSMutableArray array] init];
        self.customerID = [[NSMutableArray array] init];
        self.industryIDStr = [[NSMutableArray array] init];
        self.phoneData = [[NSMutableArray array] init];
        self.addressData = [[NSMutableArray array] init];
        //[self faker:@"1"];
    }
    return _fakeData;
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setUpUI];
    self.title=@"客户档案";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setupRefresh];
    self.uid=[NSMutableArray array];
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addCustomerInfomation:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    [self setExtraCellLineHidden:self.tableView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage imageNamed:@"back002"] imageWithTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:image forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
}


-(void) setUpUI{
    CGRect rectStatus =[[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGFloat seachBarHeight=rectStatus.size.height+rectNav.size.height;
    self.searchBar= [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 110-seachBarHeight)];
    [self.searchBar setTranslucent:YES];
    [self.searchBar setBackgroundColor:[UIColor whiteColor]];
    self.searchBar.searchBarStyle=UISearchBarStyleDefault;
    [self.searchBar setPlaceholder:@"客户"];
    self.searchBar.delegate=self;
    [self.tableView setTableHeaderView:self.searchBar];
    }


-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerInformationAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@&CustomerName=%@",page,sid,self.searchBar.text];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
    }else{
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSArray *list = [weatherDic objectForKey:@"obj"];
        if(![list count] ==0){
            self.tableView.footerRefreshingText=@"加载中";
        }else{
            self.tableView.footerRefreshingText = @"没有更多数据";
//            UILabel *noDateView =[[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-50, SCREENHEIGHT/2-150, 100, 100)];
//            noDateView.text=@"暂无数据";
//            [self.view addSubview:noDateView];
        }
        for (int i = 0; i<[list count]; i++) {
            NSDictionary *listdic = [list objectAtIndex:i];
            [self.uid addObject:listdic];
            NSString *teamname = (NSString *)[listdic objectForKey:@"customerName"];//获取客户名称
            NSString *customerID=(NSString *)[listdic objectForKey:@"customerID"];//获取客户id
            NSString *industryIDStr=(NSString *)[listdic objectForKey:@"industryIDStr"];  //所属行业
            NSString *address =(NSString *) [listdic objectForKey:@"customerAddress"];  //客户地址
            NSString *phone =(NSString *) [listdic objectForKey:@"phone"];  //联系电话
            if (address==nil||address==NULL) {
                address=@"null";
            }
            if (phone==nil||phone==NULL) {
                phone=@"null";
            }
            [self.customerID     addObject:customerID];
            [self.fakeData     addObject:teamname];
            [self.industryIDStr addObject:industryIDStr];
            [self.addressData addObject:address];
            [self.phoneData addObject:phone];
        }
        [self customerIDReturn:self.customerID];
    }
    return self.fakeData;
}

-(NSMutableArray *) customerIDReturn: (NSMutableArray *) uidArr
{
    return self.customerID;
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark -Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"information";
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationTableViewCell" owner:self options:nil]lastObject];
    }
    cell.photo.image = [UIImage imageNamed:@"kehuDA.png"];
    cell.company.text = self.fakeData[indexPath.row];
    cell.industry.text = [self.industryIDStr objectAtIndex:indexPath.row];
    cell.address.text = [self.addressData objectAtIndex:indexPath.row];
    cell.phone.text = (NSString *)[self.phoneData objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self customerIDuserName:self.fakeData :self.customerID];
    
    if (tableView == self.tableView)
    {
        
        NSDictionary *nc =[self singleCustomerInfo:(NSString *)[_uCustomerId objectForKey:[self.fakeData objectAtIndex:indexPath.row]]];
        NSString *customerName  =(NSString *) [nc objectForKey:@"customerName"];  //客户名称
        NSString *customerID  =(NSString *) [nc objectForKey:@"customerID"];  // 客户id
        NSString *industryIDStr  =(NSString *) [nc objectForKey:@"industryIDStr"];  //所属行业
        NSString *industryID  =(NSString *) [nc objectForKey:@"industryID"];  //所属行业ID
        NSString *companyTypeStr =(NSString *) [nc objectForKey:@"companyTypeStr"]; // 企业类型
        NSString *companyType =(NSString *) [nc objectForKey:@"companyType"]; // 企业类型ID
        NSString *customerClassStr =(NSString *) [nc objectForKey:@"customerClassStr"]; //客户类别
        NSString *customerClass =(NSString *) [nc objectForKey:@"customerClass"]; //客户类别ID
        NSString *provinceStr =(NSString *) [nc objectForKey:@"provinceStr"];  //省份
        NSString *province =(NSString *) [nc objectForKey:@"province"];  //省份ID
        NSString *shiChangXQFL =(NSString *) [nc objectForKey:@"shiChangXQFL"];  //市场需求分累
        NSString *customerAddress =(NSString *) [nc objectForKey:@"customerAddress"];  //客户地址
        NSString *phone =(NSString *) [nc objectForKey:@"phone"];  //联系电话
        NSString *receptionPersonnel =(NSString *) [nc objectForKey:@"receptionPersonnel"];  //客户主维护人
        NSString *createTime =(NSString *) [nc objectForKey:@"creationDate"];  //创建时间
        NSString *customerMasterPrincipal =(NSString *) [nc objectForKey:@"customerMasterPrincipal"];
        NSLog(@"createTime---------%@",createTime);
        CustomerInfermationDetailMessageEntity *udetail =[[CustomerInfermationDetailMessageEntity alloc] init];
        [udetail setCustomerID:customerID];
        [udetail setCustomerName:customerName];
        [udetail setIndustryIDStr:industryIDStr];
        [udetail setCompanyTypeStr:companyTypeStr];
        [udetail setCustomerClassStr:customerClassStr];
        [udetail setProvinceStr:provinceStr];
        [udetail setShiChangXQFL:shiChangXQFL];
        [udetail setCustomerAddress:customerAddress];
        [udetail setPhone:phone];
        [udetail setReceptionPersonnel:receptionPersonnel];
        [udetail setCreateTime:createTime];
        [udetail setCustomerMasterPrincipal:customerMasterPrincipal];
        [udetail setIndustryID:industryID];//1
        [udetail setCustomerClass:customerClass];//2
        [udetail setCompanyType:companyType];//3
        [udetail setProvince:province];//4
        
        CustomerInformationDetailViewController *uc =[[CustomerInformationDetailViewController alloc] init];
        [uc setCustomerInformationEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
    }else
    {
        NSDictionary *nc =[self singleCustomerInfo:(NSString *)[_uCustomerId objectForKey:[self.searchResultsData objectAtIndex:indexPath.row]]];
        NSString *customerName  =(NSString *) [nc objectForKey:@"customerName"];
        NSString *customerID  =(NSString *) [nc objectForKey:@"customerID"];
        CustomerInfermationDetailMessageEntity *udetail =[[CustomerInfermationDetailMessageEntity alloc] init];
        [udetail setCustomerName:customerName];
        [udetail setCustomerID:customerID];
        CustomerInformationDetailViewController *uc =[[CustomerInformationDetailViewController alloc] init];
        [uc setCustomerInformationEntity:udetail];
        [self.navigationController pushViewController:uc animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
            return 70;
}

-(void) customerIDuserName:(NSMutableArray *)utestname :(NSMutableArray *)customerID{
    _uCustomerId = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[utestname count];i++)
    {
        [_uCustomerId setObject:[customerID objectAtIndex:i] forKey:[utestname objectAtIndex:i]];
    }
}

-(NSDictionary *) singleCustomerInfo :(NSString *) customerIDIn{
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

//跳转至添加页面
- (IBAction)addCustomerInfomation:(id)sender
{
    AddCustomerInformationViewController *jumpController = [[AddCustomerInformationViewController alloc] init];
    [self.navigationController pushViewController: jumpController animated:true];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.fakeData removeAllObjects];
    self.index =1;
    [self faker:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [searchBar resignFirstResponder];
//    [self.tableView setFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENHEIGHT)];
}

@end
