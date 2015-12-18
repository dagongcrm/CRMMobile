//
//  SaleOppTableViewController.m
//  CRMMobile
//
//  Created by jam on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "SaleOppTableViewController.h"
#import "AddSaleOppViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "config.h"
#import "SaleOppEntity.h"
#import "DetailSaleOppViewController.h"
#import "EntityHelper.h"

@interface SaleOppTableViewController ()

@property (strong, nonatomic) NSMutableArray *entities;
@property  NSInteger index;

@end

@implementation SaleOppTableViewController
- (NSMutableArray *)entities
{
    if (!_entities) {
        self.entities = [[NSMutableArray alloc]init];
        [self faker:@"1"];
    }
    return _entities;
}

-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleOpportunityAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *order = @"desc";
    NSString *sort = @"createTime";
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
        SaleOppEntity *saleOpp =[[SaleOppEntity alloc] init];
        [EntityHelper dictionaryToEntity:listDic entity:saleOpp];
        [self.entities addObject:saleOpp];
    }
    }
    return self.entities;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"销售机会";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

   // [self fakeData];
    [self setupRefresh];    //上拉刷新下拉加在方法
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addSaleOpp:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
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
    AddSaleOppViewController *addSaleOpp= [[AddSaleOppViewController alloc] init];
    [self.navigationController pushViewController:addSaleOpp animated:NO];
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
    [self.entities removeAllObjects];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaleOppEntity *saleOppEntity =[self.entities objectAtIndex:indexPath.row];
    DetailSaleOppViewController *detailSallOpp =[[DetailSaleOppViewController alloc] init];
    [detailSallOpp setSaleOppEntity:saleOppEntity];
    [self.navigationController pushViewController:detailSallOpp animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entities count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    [cell.textLabel setText:[[self.entities objectAtIndex:indexPath.row] customerNameStr]];
    
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *detail =[[self.entities objectAtIndex:indexPath.row] oppStateStr];
    if (detail ==nil) {
        detail=@"暂无";
    }
     NSString *detailText=[@"机会状态："  stringByAppendingString:detail];
    [cell.detailTextLabel setText:detailText];
    
    [cell.imageView setImage:[UIImage imageNamed:@"gongsi.png"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
        return 50;
    }else{
        return 60;
    }
}


@end
