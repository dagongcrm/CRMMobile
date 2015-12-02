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
#import "CustomerCallPlanViewController.h"
#import "HttpHelper.h"

@interface GLReusableViewController ()
@property (nonatomic,strong) NSString *weatherDetail;
@property (nonatomic,strong) UILabel  *timeDetail;
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
    [super viewDidLoad];
    [self  weatherInfo];
    [self  reloadData];
}

-(void)viewWillAppear:(BOOL)animated{

      [self reloadData];
}

-(void)weatherInfo{
    NSString *url = WEATHER_URL;
    NSString *key = @"3b0cd636493d9c9fd3ab55087b7fd8f3";
    NSString *info = @"北京今天天气";
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:key forKey:@"key"];
    [params setValue:info forKey:@"info"];
    if([HttpHelper NetWorkIsOK]){
        [HttpHelper postAsyn:url RequestParams:params FinishBlock:^(NSURLResponse  *response, NSData *data, NSError *connectionError) {
            NSDictionary *weatherInfo  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&connectionError];
            NSString *weatherString =[weatherInfo objectForKey:@"text"];
            self.weatherDetail=weatherString;
        }];
    }
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
        UILabel  *weatherDetailText = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 30, 30)];
        weatherDetailText.text=weatherDetail;
        weatherDetailText.textColor=[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
        [self.view addSubview:weatherDetailText];
        [weatherDetailText sizeToFit];
        weatherDetailText.center = CGPointMake(self.view.bounds.size.width/2,130);
    
        UILabel  *todolabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 160, 20, 10)];
        todolabel.text=@"今日工作";
        todolabel.font  = [UIFont boldSystemFontOfSize:13.0];
        todolabel.textColor=[UIColor lightGrayColor];
        [self.view addSubview:todolabel];
        [todolabel sizeToFit];
    
        UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(0,179,self.view.bounds.size.width,1)];
        navDividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [navDividingLine sizeToFit];
        [self.view addSubview:navDividingLine];
    
        ReminderTableViewController *nav = [[ReminderTableViewController alloc] init];
        nav.view.autoresizingMask = UIViewAutoresizingNone;
        [self addChildViewController:nav];
        nav.view.frame =  CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height);
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
    NSString *weatherDic=self.weatherDetail;
    NSRange  range1= [weatherDic rangeOfString:@":"];
    NSRange  range2= [weatherDic rangeOfString:@";"];
    weatherDic = [weatherDic substringFromIndex:range1.location+1];
    weatherDic = [weatherDic substringToIndex:range2.location+1];
    NSRange range3=[weatherDic rangeOfString:@" "];
    weatherDic = [weatherDic substringFromIndex:range3.location+1];
    
    NSRange rangex=[weatherDic rangeOfString:@"°"];
    NSString *temp= [weatherDic substringToIndex:rangex.location+1];
    NSRange rangeother=[temp rangeOfString:@","];
    temp= [temp substringFromIndex:rangeother.location+1];
    
    NSRange range4=[weatherDic rangeOfString:@" "];
    weatherDic = [weatherDic substringFromIndex:range4.location+1];
    NSRange range5=[weatherDic rangeOfString:@" "];
    weatherDic = [weatherDic substringFromIndex:range5.location+1];
    NSRange range6=[weatherDic rangeOfString:@" "];
    weatherDic = [weatherDic substringToIndex:range6.location+1];
    return [[weatherDic stringByAppendingString:@" "] stringByAppendingString:temp];
}
@end
