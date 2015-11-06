//
//  TXLTableViewController.m
//  CRMMobile
//
//  Created by why on 15/10/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "TXLTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
@interface TXLTableViewController (){
    UISearchDisplayController *mySearchDisplayController;
}
@property (nonatomic, strong) NSMutableArray *fakeData;//
@property (nonatomic, strong) NSMutableArray *contactData;//联系方式
@property (nonatomic, strong) NSMutableArray *customerNameStrData;//联系人
@property (nonatomic, strong) NSMutableArray *phoneData;//电话数据
@property (nonatomic, strong) NSMutableArray *userName;
@property (nonatomic, strong) NSMutableArray *orgName;

@end

@implementation TXLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"通讯录";
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    self.tableView.tableHeaderView = searchBar;
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
     [self setExtraCellLineHidden:self.tableView];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////    UIImage *image = [[UIImage imageNamed:@"back001.png"] imageWithTintColor:[UIColor whiteColor]];
//    button.frame = CGRectMake(0, 0, 20, 20);
//    //[button setImageEdgeInsets:UIEdgeInsetsMake(-10, -30, -6, -30)];
////    [button setImage:image forState:UIControlStateNormal];
////    [button addTarget:self action:@selector(ResView) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.font = [UIFont systemFontOfSize:16];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                   target:nil action:nil];
//    negativeSpacer.width = -5;//这个数值可以根据情况自由变化
//    self.navigationItem.leftBarButtonItems = @[negativeSpacer,rightItem];
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
    [self faker:@"1"];
    [self faker:@"2"];
    [self faker:@"3"];
    }
// hide the extraLine隐藏分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//获取数据
-(NSMutableArray *)faker:()page{
    self.fakeData = [[NSMutableArray alloc]init];
    self.contactData = [[NSMutableArray alloc]init];
    self.customerNameStrData = [[NSMutableArray alloc]init];
    self.phoneData = [[NSMutableArray alloc]init];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = APPDELEGATE.sessionInfo;
    NSString *sid = [[dic objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@",sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *contactDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"contactDic字典里面的内容为--》%@", contactDic);
    NSArray *list = [contactDic objectForKey:@"obj"];
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        [self.userName addObject:listDic];
        NSString *teamname = (NSString *)[listDic objectForKey:@"contactName"];
        NSString *telePhone = (NSString *)[listDic objectForKey:@"telePhone"];
        NSString *customerNameStr = (NSString *)[listDic objectForKey:@"customerNameStr"];
        NSString *phoneTime = (NSString *)[listDic objectForKey:@"phoneTime"];
        NSLog(@"%@",teamname);
        if (phoneTime  == nil || phoneTime == NULL) {
            [self.phoneData addObject:@"暂无通话记录"];
        }else{
            [self.phoneData addObject:phoneTime];
        }
        NSLog(@"柯南回来了%@",phoneTime);
        
        [self.fakeData addObject:teamname];
        
        [self.contactData addObject:telePhone];
        [self.customerNameStrData addObject:customerNameStr];
//        [self.phoneData addObject:telePhone];
        NSLog(@"33333333333%@",customerNameStr);
    }
    return self.fakeData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NSLog(@"8888888%@",self.phoneData);

    [cell.imageView setImage:[UIImage imageNamed:@"dianhua"]];
        cell.textLabel.text = self.fakeData[indexPath.row];
        [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
//        [cell.detailTextLabel setNumberOfLines:2];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSString *testDetail =[@"联系电话:" stringByAppendingString:(NSString *)[self.contactData objectAtIndex:indexPath.row]];
    NSString *phoneT= [@"通话记录:" stringByAppendingString:(NSString *)[self.phoneData objectAtIndex:indexPath.row]];
    NSString *Tdetail1 = [testDetail stringByAppendingString:@"   "];
    NSString *Tdetail= [Tdetail1 stringByAppendingString:phoneT];
        [cell.detailTextLabel setText:Tdetail];
//    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap; //如何换行
//        [cell.detailTextLabel setText:customerName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ggggggggggggg%@",self.phoneData);
    [self bodadianhua];
//    SettingViewController *fl= [[SettingViewController alloc] init];
//    [self.navigationController pushViewController:fl animated:NO];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.phoneData]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://self.phoneData"]];
//    UIWebView *callWebview =[[UIWebView alloc] init];
//    NSURL *telURL =[NSURL URLWithString:@"tel://10086"];
//    // 貌似tel:// 或者 tel: 都行
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    //记得添加到view上
//    [self.view addSubview:callWebview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
}
-(void)bodadianhua{
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}
@end
