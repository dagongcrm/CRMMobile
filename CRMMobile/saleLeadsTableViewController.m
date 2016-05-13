//
//  saleLeadsTableViewController.m
//  CRMMobile
//
//  Created by zhang on 15/12/3.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "saleLeadsTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MJRefresh.h"
#import "SaleOppEntity.h"
#import "EntityHelper.h"
#import "addSaleLeadsViewController.h"
#import "detailSaleLeadsViewController.h"
#import "UIImage+Tint.h"
#import "CRMTableViewController.h"
@interface saleLeadsTableViewController ()
@property (strong, nonatomic) NSMutableArray *entities;
@property  NSInteger index;

@end

@implementation saleLeadsTableViewController
@synthesize saleLead = _saleLead;
- (NSMutableArray *)fakeData
{
    if (!_entities) {
        self.entities = [[NSMutableArray alloc]init];
        [self faker:@"1"];
    }
    return _entities;
}
-(void) viewWillAppear:(BOOL)animated{
    
    [self.entities removeAllObjects];
    self.index =1;    
    [self faker:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
    });
    
}
-(NSMutableArray *) faker: (NSString *) page{
    
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleClueAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"creatingTime";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@&sort=%@&order=%@",sid,page,sort,order];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
    NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *list = [json objectForKey:@"obj"];
    NSLog(@"%@",list);
    if([list count] ==0)
    {
        self.tableView.footerRefreshingText = @"没有更多数据";
        self.index--;
    }else
    {
        self.tableView.footerRefreshingText=@"加载中";
    }
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        saleLeads *saleOpp =[[saleLeads alloc] init];
        [EntityHelper dictionaryToEntity:listDic entity:saleOpp];
        [self.entities addObject:saleOpp];
        NSLog(@"%@",saleOpp);
    }
    }
    return self.entities;
}


- (void)viewDidLoad {
    
    self.tableView1=self.tableView;
    [super viewDidLoad];
    self.title=@"销售线索";
    NAVCOLOR;
    [self fakeData];
    [self setupRefresh]; 
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addSaleOpp:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    //去除返回按钮的文本
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setExtraCellLineHidden:self.tableView];
    }

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (IBAction)addSaleOpp:(id)sender
{
    addSaleLeadsViewController *addSaleLeads = [[addSaleLeadsViewController alloc] init];
    _saleLead = [saleLeads new];
    [_saleLead setIndex:@"addSaleLeads"];
    [addSaleLeads setSaleLeads:_saleLead];
    [self.navigationController pushViewController:addSaleLeads animated:YES];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entities count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell.textLabel setText:[[self.entities objectAtIndex:indexPath.row] customerNameStr]];
    [cell.imageView setImage:[UIImage imageNamed:@"xiaosxs.png"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    saleLeads *saleLeadsEntity =[self.entities objectAtIndex:indexPath.row];
    detailSaleLeadsViewController *detailSaleLeads =[[detailSaleLeadsViewController alloc] init];
    [detailSaleLeads setSaleLeads:saleLeadsEntity];
    [self.navigationController pushViewController:detailSaleLeads animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end
