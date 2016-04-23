//
//  MarketViewController.m
//  CRMMobile
//
//  Created by gwb on 16/4/15.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "MarketViewController.h"
#import "config.h"
#import "HMSegmentedControl.h"
#import "saleLeadsTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "saleLeads.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽

@interface MarketViewController (){
    UITableView *tab1;
    UITableView *tab2;
    NSArray *dataSource;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;
@property (strong, nonatomic) NSMutableArray *entities;
//@property (strong,nonatomic) UITableView *tab1;
//@property (strong,nonatomic) UITableView *tab2;
@end

@implementation MarketViewController
//- (NSMutableArray *)fakeData
//{
//    if (!_entities) {
//        self.entities = [[NSMutableArray alloc]init];
//        [self faker:@"1"];
////        [self faker:@""];
//    }
//    return _entities;
//}
- (void)viewDidLoad {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

    self.title = @"市场";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
//    self.entities =[self faker:@"1"];
    
    // Tying up the segmented control to a scroll view
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    self.segmentedControl4.sectionTitles = @[@"销售机会", @"销售线索", @"活动统计"];
    self.segmentedControl4.selectedSegmentIndex = 0;
    self.segmentedControl4.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];//按钮栏背景色
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]};
    self.segmentedControl4.selectionIndicatorColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    self.segmentedControl4.tag = 3;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl4 setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, SCREENHEIGHT) animated:YES];
    }];
    
    [self.view addSubview:self.segmentedControl4];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, SCREENHEIGHT)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 3, SCREENHEIGHT-50);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, SCREENHEIGHT-50) animated:NO];
    [self.view addSubview:self.scrollView];
    
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, SCREENHEIGHT-50)];
//    [self setApperanceForLabel:label1];
//    label1.text = @"销售机会";
//    [self.scrollView addSubview:label1];
//    tab1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-125)];
//    tab1.dataSource = self;
//    tab1.delegate = self;
//    [self.scrollView addSubview: tab1];
//    self.entities =[self fakeData];
    saleLeadsTableViewController *table1  = [[saleLeadsTableViewController alloc] init];
//    [self setAccessibilityLabel:table1];
//    saleLeadsTableViewController *vc = [[saleLeadsTableViewController alloc]init];
//    [self addChildViewController:vc];
    [self addChildViewController:table1];
//    [self.view addSubview:table1];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth, 0, viewWidth, SCREENHEIGHT-50)];
    [self setApperanceForLabel:label2];
    label2.text = @"Local";
    [self.scrollView addSubview:label2];
//    tab2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-125)];
//    tab2.dataSource = self;
//    tab2.delegate = self;
//    [self.scrollView addSubview: tab2];
//    self.entities =[self fakeData];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth * 2, 0, viewWidth, SCREENHEIGHT-50)];
    [self setApperanceForLabel:label3];
    label3.text = @"Headlines";
    [self.scrollView addSubview:label3];
}
//
//-(NSMutableArray *) faker: (NSString *) page{
////    return nil;
//    NSError *error;
//    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
//    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleClueAction!datagrid.action?"]];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval=10.0;
//    request.HTTPMethod=@"POST";
//    NSString *order = @"desc";
//    NSString *sort = @"creatingTime";
//    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@&sort=%@&order=%@",sid,page,sort,order];
//    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
//        [alert show];
//        NSLog(@"--------%@",error);
//    }else{
//        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        NSMutableArray *list = [json objectForKey:@"obj"];
//        NSLog(@"%@",list);
//     
//        for (int i = 0;i<[list count];i++) {
//            NSDictionary *listDic =[list objectAtIndex:i];
////            saleLeads *saleOpp =[[saleLeads alloc] init];
////            [EntityHelper dictionaryToEntity:listDic entity:saleOpp];
//            [self.entities addObject:[listDic objectForKey:@"customerNameStr"]];
////            NSLog(@"%@",saleOpp);
//        }
//    }
//    return self.entities;
//}
//
////- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////    return [self.entities count];
////}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.entities count];
////    return nil;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    tableView = tab1;
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    [cell.textLabel setText:[self.entities objectAtIndex:indexPath.row] ];
//    [cell.imageView setImage:[UIImage imageNamed:@"gongsi"]];
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    saleLeads *saleLeadsEntity =[self.entities objectAtIndex:indexPath.row];
////    detailSaleLeadsViewController *detailSaleLeads =[[detailSaleLeadsViewController alloc] init];
////    [detailSaleLeads setSaleLeads:saleLeadsEntity];
////    [self.navigationController pushViewController:detailSaleLeads animated:NO];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
////    if ([APPDELEGATE.deviceCode isEqualToString:@"5"]) {
//        return 50;
////    }else{
////        return 60;
////    }
//}


- (void)setApperanceForLabel:(UILabel *)label {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    label.backgroundColor = color;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:21.0f];
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld", (long)segmentedControl.selectedSegmentIndex);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl4 setSelectedSegmentIndex:page animated:YES];
}


@end
