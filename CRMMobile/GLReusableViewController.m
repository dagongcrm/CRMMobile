//
//  GLResuableViewController.m
//  Reuse
//
//  Created by Allen Hsu on 12/14/14.
//  Copyright (c) 2014 Glow, Inc. All rights reserved.
//
#import "ReminderTableViewController.h"
#import "VisitPlanTableViewController.h"
#import "CustomerInformationTableViewController.h"
#import "TaskRecordsTableViewController.h"
#import "GLReusableViewController.h"
#import "config.h"
#import "AppDelegate.h"

@interface GLReusableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *instanceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *NotificationListData;
@property (retain, nonatomic) UITableView *tableView;
@end
@implementation GLReusableViewController

+ (instancetype)viewControllerFromStoryboard
{
    return
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReusableViewController"];
}

- (void)setPage:(NSNumber *)page
{
    if (_page != page) {
        _page = page;
        [self reloadData];
    }
}

- (void)viewDidLoad
{
//    self.NotificationListData = [NSMutableArray array];
//    [self.NotificationListData addObject:@"gamma"];
//    [self.NotificationListData addObject:@"alpha"];
//    [self.NotificationListData addObject:@"beta"];
//    self.tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, self.view.bounds.size.height)  style:UITableViewStylePlain];
//    [self.tableView setDataSource:self];
//    [self.tableView setDelegate:self];
//    [self.view addSubview:self.tableView];
    [super viewDidLoad];
    [self  reloadData];
}

- (void)reloadData
{
    if([self.page integerValue]==0)
    {
        UILabel *timeForShow = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width, 100)];
        timeForShow.text=[self getTimeNow];
        timeForShow.textColor=[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
        [self.view addSubview:timeForShow];
        [timeForShow sizeToFit];
        timeForShow.center = CGPointMake(self.view.bounds.size.width/2,100);
        NSString *weatherDetail=[self getWeather];
        //NSString *imagekey=[self getWeatherImg];
        //UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 30, 30)];
        //imageView.center=CGPointMake(self.view.bounds.size.width/2-50,130);
        //UIImage  *weatherimg=[UIImage imageNamed:[imagekey stringByAppendingString:@".png"]];
        UILabel  *weatherDetailText = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 30, 30)];
        weatherDetailText.text=weatherDetail;
        weatherDetailText.textColor=[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
        [self.view addSubview:weatherDetailText];
        [weatherDetailText sizeToFit];
        weatherDetailText.center = CGPointMake(self.view.bounds.size.width/2,130);
        //imageView.image=weatherimg;
        //[self.view addSubview:imageView];
        
        ReminderTableViewController *nav = [[ReminderTableViewController alloc] init];
        nav.view.autoresizingMask = UIViewAutoresizingNone;
        [self addChildViewController:nav];
        nav.view.frame =  CGRectMake(0, 150, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.view addSubview:nav.view];
        [nav didMoveToParentViewController:self];
    }
    if([self.page integerValue]==1)
    {
        VisitPlanTableViewController *nav = [[VisitPlanTableViewController alloc] init];
        nav.view.autoresizingMask = UIViewAutoresizingNone;
        [self addChildViewController:nav];
        nav.view.frame = CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.view addSubview:nav.view];
        [nav didMoveToParentViewController:self];
       
    }
    if([self.page integerValue]==2)
    {
        TaskRecordsTableViewController *nav = [[TaskRecordsTableViewController alloc] init];
        nav.view.autoresizingMask = UIViewAutoresizingNone;
        [self addChildViewController:nav];
        nav.view.frame =  CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.view addSubview:nav.view];
        [nav didMoveToParentViewController:self];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.NotificationListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    [cell.textLabel setText:[self.NotificationListData objectAtIndex:indexPath.row]];
    return cell;
}


-(NSString *) getTimeNow{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    int week  = [comps weekday]-1;
    int year  = [comps year];
    int month = [comps month];
    int day   = [comps day];
    NSString *timeForShowFormatter=[[NSString stringWithFormat:@"%d年%d月%d日 ",year,month,day] stringByAppendingString:[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week]]];
    return timeForShowFormatter;
}

-(NSString *)getWeather{
    NSString *tulingUrl = @"http://www.tuling123.com/openapi/api?key=3b0cd636493d9c9fd3ab55087b7fd8f3&info=北京今天天气";
    tulingUrl = [tulingUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:tulingUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"GET";
    NSError *error;
    NSLog(@"%@",request);
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *Dic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSString *weatherDic =[Dic objectForKey:@"text"];
    //format weatherdetail
    NSRange  range1= [weatherDic rangeOfString:@":"];
    NSRange  range2= [weatherDic rangeOfString:@";"];
    weatherDic = [weatherDic substringFromIndex:range1.location+1];
    weatherDic = [weatherDic substringToIndex:range2.location+1];
    NSRange range3=[weatherDic rangeOfString:@" "];
    weatherDic = [weatherDic substringFromIndex:range3.location+1];
    NSString *temp= [weatherDic substringToIndex:range3.location+1];
    NSRange rangeother=[weatherDic rangeOfString:@","];
    temp= [temp substringFromIndex:rangeother.location+1];
    temp=[temp stringByAppendingString:@"°"];
    NSRange range4=[weatherDic rangeOfString:@" "];
    weatherDic = [weatherDic substringFromIndex:range4.location+1];
    NSRange range5=[weatherDic rangeOfString:@" "];
    weatherDic = [weatherDic substringFromIndex:range5.location+1];
    NSRange range6=[weatherDic rangeOfString:@" "];
    weatherDic = [weatherDic substringToIndex:range6.location+1];
    
    return [[weatherDic stringByAppendingString:@" "] stringByAppendingString:temp];
//    return false;
}

//-(NSString *)getWeatherImg{
//    NSURL *URL=[NSURL URLWithString:@"http://www.weather.com.cn/adat/cityinfo/101010100.html"];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval=10.0;
//    request.HTTPMethod=@"GET";
//    NSError *error;
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *Dic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    NSDictionary *weatherDic = [Dic objectForKey:@"weatherinfo"];
//    NSString *weatherImageKey =(NSString*)[weatherDic objectForKey:@"img1"];
//    return [[weatherImageKey stringByReplacingOccurrencesOfString:@".gif" withString:@""] stringByReplacingOccurrencesOfString:@"d" withString:@""];
//}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
@end
