//
//  MabViewController.m
//  CRMMobile
//
//  Created by 伍德友 on 16/4/19.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "MabViewController.h"
#import "XGViewController.h"
#import "saleLeadsTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
@interface MabViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *entities;
@property (strong,nonatomic)     UITableView *tab1;
@property (strong,nonatomic)     UITableView *tab2;
@end

@implementation MabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array=@[@"销售机会", @"销售线索", @"活动统计"];
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.segmentedControlStyle=UISegmentedControlStyleBordered;
    //设置位置 大小
    segmentControl.frame=CGRectMake(0, 60, SCREENWIDTH, 65);
    //默认选择
    segmentControl.selectedSegmentIndex=1;
    //设置背景色
    segmentControl.tintColor=[UIColor grayColor];
    //设置监听事件
    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentControl];
    
}


-(void)change:(UISegmentedControl *)segmentControl{
    NSLog(@"segmentControl %d",segmentControl.selectedSegmentIndex);
    NSInteger Index = segmentControl.selectedSegmentIndex;
    if (Index ==0) {
        self.tab1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 125, SCREENWIDTH, SCREENHEIGHT-125)];
//        [self setApperanceForLabel:label2];
//        label2.text = @"Localfsdfsdfds";
//        saleLeadsTableViewController *tab11 = [[saleLeadsTableViewController alloc] init];
//        [tab1 addSubview:tab11]
        self.tab1.dataSource = self;
        self.tab1.delegate = self;
        [self.view addSubview: self.tab1];
         self.entities = @[@"我的分享",@"密码管理",@"用户协议",@"关于"];
        
    }
    if (Index==1) {
        self.tab1.hidden;
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, SCREENWIDTH, SCREENHEIGHT-125)];
            //        [self setApperanceForLabel:label2];
    label3.text = @"Localgdfgdfgdf";
    [self.view addSubview:label3];

    }
    
//    if (Index ==1) {
//        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, SCREENWIDTH, SCREENHEIGHT-125)];
//        //        [self setApperanceForLabel:label2];
//        label3.text = @"Localgdfgdfgdf";
//        [self.view addSubview:label3];
//    }
//    
//    if (Index ==2) {
//        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, SCREENWIDTH, SCREENHEIGHT-125)];
//        //        [self setApperanceForLabel:label2];
//        label4.text = @"Localhgjghjhjkjh";
//        [self.view addSubview:label4];
//    }
    
    
    
    
//    switch (Index) {
//        case 0:
//            [self sales];
//            NSLog(@"Index %i", Index);
////            UIView * uv = [[UIView alloc] initWithFrame:CGRectMake(0,125,SCREENWIDTH,SCREENHEIGHT-60-65)];
//            break;
//            //        case 1:
//            //            [self selectmyView2];
//            //            break;
//            //        case 2:
//            //            [self selectmyView3];
//            //            break;
//        default:
//            break;
//    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell.textLabel setText:[self.entities objectAtIndex:indexPath.row]];
//    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    NSString *str = @"fsfdsfd";
//    [cell.detailTextLabel setText:str];
    [cell.imageView setImage:[UIImage imageNamed:@"work-5.png"]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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
            for (int i = 0;i<[list count];i++) {
            NSDictionary *listDic =[list objectAtIndex:i];
            saleLeads *saleOpp =[[saleLeads alloc] init];
            [self.entities addObject:saleOpp];
            NSLog(@"%@",saleOpp);
        }
    }
    return self.entities;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entities count];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    noticeEntity *notice =[self.entities objectAtIndex:indexPath.row];
//    noticeDetailViewController *detail =[[noticeDetailViewController alloc] init];
//    [detail setNoticeEntity:notice];
//    [self.navigationController pushViewController:detail animated:YES];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
        return 50;
//    }else{
//        return 60;
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
