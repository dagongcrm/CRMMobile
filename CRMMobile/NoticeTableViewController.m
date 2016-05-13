//
//  NoticeTableViewController.m
//  CRMMobile
//
//  Created by zhang on 15/10/27.
//  Copyright (c) 2015年 dagong. All rights reserved.
//
#import "AppDelegate.h"
#import "NoticeTableViewController.h"
#import "config.h"
#import "GLReusableViewController.h"
#import "PureLayout.h"
#import "noticeEntity.h"
#import "noticeDetailViewController.h"
#import "EntityHelper.h"
#import "UIScrollView+MJRefresh.h"
#import "trackCell.h"
@interface NoticeTableViewController ()

@property (strong, nonatomic) NSMutableArray *entities;
@property  NSInteger index;

@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *userIdData;
@property (strong, nonatomic) NSMutableArray *dataing;
@property (strong, nonatomic) NSMutableArray *uid;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *navScrollView;
@property (weak, nonatomic) IBOutlet UIView *navContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navContentWidthConstraint;

@property (strong, nonatomic) NSNumber *currentPage;
@property (strong, nonatomic) NSMutableArray *reusableViewControllers;
@property (strong, nonatomic) NSMutableArray *visibleViewControllers;


@end

@implementation NoticeTableViewController
@synthesize leftSwipe;
@synthesize rightSwipe;
- (NSMutableArray *)fakeData
{
    if (!_entities) {
        self.entities = [[NSMutableArray alloc]init];
        [self faker:@"1"];
        [self faker:@"2"];
    }
    return _entities;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    self.entities = [[NSMutableArray alloc]init];
    self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;

    NSLog(@"1112");
    [self faker:@"1"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setExtraCellLineHidden:self.tableView];
}
// hide the extraLine隐藏分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
   
//        NoticeTableViewController *view = [[NoticeTableViewController alloc] init];
//        [self.navigationController pushViewController:view animated:YES];
        
        
        //        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
        //        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
        //        self.swipeLabel.text = @"尼玛的, 你在往左边跑啊....";
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
         
//        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x + 100.0, self.swipeLabel.frame.origin.y);
//        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
//        self.swipeLabel.text = @"尼玛的, 你在往右边跑啊....";
    }
}



-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    self.fakeData=[[NSMutableArray alloc] init];
    self.dataing=[[NSMutableArray alloc] init];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mnoticeManageAction!threeDatagrid1.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@&publishType=tonggao",page,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    NSArray *images = [[NSArray alloc] initWithObjects:@"SouthAfrica.png",@"Mexico.png",
                       @"Argentina.png",@"Nigeria.png",@"England.png",@"USA.png",
                       @"Germany.png",@"Australia.png",@"Holland.png",@"Denmark.png",
                       @"Brazil.png",@"NorthKorea.png",@"Spain.png",@"Switzerland.png",nil];
    //    if([list count] ==0)
    //    {
    //        self.tableView.footerRefreshingText = @"没有更多数据";
    //
    //    }else
    //    {
    //        self.tableView.footerRefreshingText=@"加载中";
    //    }
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        noticeEntity *notice =[[noticeEntity alloc] init];
        [EntityHelper dictionaryToEntity:listDic entity:notice];
        [self.entities addObject:notice];
    }
    return self.entities;
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"trackCell";
    trackCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"trackCell" owner:self options:nil]lastObject];
    }
   
    cell.myImg.image = [UIImage imageNamed:@"app_item_notice.png"];
    cell.mylbl1.text= [[self.entities objectAtIndex:indexPath.row] documentTitle];
    cell.mylbl2.text= [[self.entities objectAtIndex:indexPath.row] publishContent];
    
    return cell;

    
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    [cell.textLabel setText:[[self.entities objectAtIndex:indexPath.row] publishContent]];
//    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
////    [cell.imageView setImage:[UIImage imageNamed:@"app_item_notice.png"]];
//    cell.imageView.image=[UIImage imageNamed:@"app_item_notice.png"];
//    CGSize itemsize=CGSizeMake(30, 30);
//    UIGraphicsBeginImageContextWithOptions(itemsize,NO,UIScreen.mainScreen.scale);
//    CGRect imageRect=CGRectMake(0.0, 0.0, itemsize.width, itemsize.width);
//    [cell.imageView.image drawInRect:imageRect];
//    cell.imageView.image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//   
//    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entities count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    noticeEntity *notice =[self.entities objectAtIndex:indexPath.row];
    noticeDetailViewController *detail =[[noticeDetailViewController alloc] init];
    [detail setNoticeEntity:notice];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end
