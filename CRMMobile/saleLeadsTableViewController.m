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

@interface saleLeadsTableViewController ()

@property (strong, nonatomic) NSMutableArray *entities;
@property  NSInteger index;

@end

@implementation saleLeadsTableViewController
- (NSMutableArray *)fakeData
{
    if (!_entities) {
        self.entities = [[NSMutableArray alloc]init];
        [self faker:@"1"];
        [self faker:@"2"];
    }
    return _entities;
}

-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleClueAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    //    NSString *order = @"desc";
    //    NSString *sort = @"time";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@",sid,page];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
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
    return self.entities;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self fakeData];
    [self setupRefresh];    //上拉刷新下拉加在方法
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addSaleOpp:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    //[self setExtraCellLineHidden:self.tableView];

    }
- (IBAction)addSaleOpp:(id)sender
{
    addSaleLeadsViewController *addSaleLeads = [[addSaleLeadsViewController alloc] init];
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
    self.index =3;
    [self faker:@"1"];
    [self faker:@"2"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if(self.index==0){
        self.index=3;
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
    return cell;
}



@end