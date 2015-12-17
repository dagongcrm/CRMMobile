//
//  MarketManagementViewController.m
//  CRMMobile
//
//  Created by why on 15/12/3.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "MarketManagementViewController.h"
#import "PNChart.h"
#import "config.h"
#import "AppDelegate.h"
@interface MarketManagementViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *DateData;//日期
@property (strong,nonatomic) NSString *date1;
@property (strong,nonatomic) NSString *date2;
@property (strong,nonatomic) NSString *date3;
@property (strong,nonatomic) NSString *date4;
@property (strong,nonatomic) NSString *date5;
@property (strong,nonatomic) NSString *date6;
@property (strong,nonatomic) NSString *date7;
@property int index1;
@property int index2;
@property int index3;
@property int index4;
@property int index5;
@property int index11;
@property int index12;
@property int index13;
@property int index14;
@property int index15;
@end

@implementation MarketManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"活动统计";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
    _index1 = 0;
     _index2 = 0;
     _index3 = 0;
     _index4 = 0;
     _index5 = 0;
    _index11 = 0;
    _index12 = 0;
    _index13 = 0;
    _index14 = 0;
    _index15 = 0;
    [self DateForIn];
    //Add LineChart
    UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 30)];
    lineChartLabel.text = @"活动次数";
    lineChartLabel.textColor = PNFreshGreen;
    lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    lineChartLabel.textAlignment = NSTextAlignmentCenter;
    
    PNChart * lineChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 75.0, SCREEN_WIDTH, 200.0)];
    lineChart.backgroundColor = [UIColor clearColor];
     NSString *d1 = [NSString stringWithFormat:@"%d",_index1];
     NSString *d2 = [NSString stringWithFormat:@"%d",_index2];
     NSString *d3 = [NSString stringWithFormat:@"%d",_index3];
     NSString *d4 = [NSString stringWithFormat:@"%d",_index4];
     NSString *d5 = [NSString stringWithFormat:@"%d",_index5];
    NSLog(@"d1d1d1d1d1-----.%@",d1);
    [lineChart setXLabels:@[[_date1 substringFromIndex:5],[_date2 substringFromIndex:5],[_date3 substringFromIndex:5],[_date4 substringFromIndex:5],[_date5 substringFromIndex:5]]];
    [lineChart setYValues:@[d1,d2,d3,d4,d5]];
    [lineChart strokeChart];
    [self.scrollView addSubview:lineChartLabel];
    [self.scrollView addSubview:lineChart];
    
    //Add BarChart    
    
    UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 30)];
    barChartLabel.text = @"电话次数";
    barChartLabel.textColor = PNFreshGreen;
    barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    barChartLabel.textAlignment = NSTextAlignmentCenter;
    
    PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 335.0, SCREEN_WIDTH, 200.0)];
    barChart.backgroundColor = [UIColor clearColor];
    barChart.type = PNBarType;
    NSString *d11 = [NSString stringWithFormat:@"%d",_index11];
    NSString *d12 = [NSString stringWithFormat:@"%d",_index12];
    NSString *d13 = [NSString stringWithFormat:@"%d",_index13];
    NSString *d14 = [NSString stringWithFormat:@"%d",_index14];
    NSString *d15 = [NSString stringWithFormat:@"%d",_index5];
    [barChart setXLabels:@[_date1,_date2,_date3,_date4,_date5]];
    [barChart setYValues:@[d11,d12,d13,d14,d15]];
    [barChart strokeChart];
    [self.scrollView addSubview:barChartLabel];
    [self.scrollView addSubview:barChart];
    
}
//date
-(void)DateForIn{
       NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    NSLog(@"weekDay:%ld   day:%ld",weekDay,day);//5 3
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;//当前时间和周一相差几天
        lastDiff = 9 - weekDay;
    }
    //    firstDiff ＝ firstDiff ＋1;
    NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    //周一
    [firstDayComp setDay:day + firstDiff+1];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    //周二
    [firstDayComp setDay:day + firstDiff+2];
    NSDate *twoDayOfWeek= [calendar dateFromComponents:firstDayComp];
    //周三
    [firstDayComp setDay:day + firstDiff+3];
    NSDate *threeDayOfWeek= [calendar dateFromComponents:firstDayComp];
    //周四
    [firstDayComp setDay:day + firstDiff+4];
    NSDate *fourDayOfWeek= [calendar dateFromComponents:firstDayComp];
    //周五
    [firstDayComp setDay:day + firstDiff+5];
    NSDate *fiveDayOfWeek= [calendar dateFromComponents:firstDayComp];
    //周六
    [firstDayComp setDay:day + firstDiff+6];
    NSDate *sixDayOfWeek= [calendar dateFromComponents:firstDayComp];
    //周日
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff-1];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd"];
    _date1 = [formater stringFromDate:firstDayOfWeek];
    _date2 = [formater stringFromDate:twoDayOfWeek];
    _date3 = [formater stringFromDate:threeDayOfWeek];
    _date4 = [formater stringFromDate:fourDayOfWeek];
    _date5 = [formater stringFromDate:fiveDayOfWeek];
    _date6 = [formater stringFromDate:sixDayOfWeek];
    _date7 = [formater stringFromDate:lastDayOfWeek];
    
    NSLog(@"星期一%@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"星期二%@",[formater stringFromDate:twoDayOfWeek]);
    NSLog(@"星期三%@",[formater stringFromDate:threeDayOfWeek]);
    NSLog(@"星期四%@",[formater stringFromDate:fourDayOfWeek]);
    NSLog(@"星期五%@",[formater stringFromDate:fiveDayOfWeek]);
    NSLog(@"星期六%@",[formater stringFromDate:sixDayOfWeek]);
    NSLog(@"星期天%@",[formater stringFromDate:lastDayOfWeek]);
    
    
    [self faker];
    [self faker11];
}
//获取数据1
-(NSMutableArray *)faker{
    
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallRecordsAction!mDatagrid1.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@",sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *maketDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"maketDic字典里面的内容为--》%@", maketDic);
    NSArray *list = [maketDic objectForKey:@"obj"];
    NSLog(@"maketDicmaketDicmaketDicmaketDicmaketDicmaketDicmaketDicmaketDicmaketDic==>>%lu",[list count]);
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
//        [self.CustomerArr addObject:listDic];
        NSString *time = (NSString *)[listDic objectForKey:@"timeStr"];
        if([time isEqualToString:_date1]){
            _index1++;
        }else{
            _index1=0;
        }
        if([time isEqualToString:_date2]){
            _index2++;
        }else{
            _index2=0;
        }
        if([time isEqualToString:_date3]){
            _index3++;
        }else{
            _index3=0;
        }
        if([time isEqualToString:_date4]){
            _index4++;
        }else{
            _index4=0;
        }
        if([time isEqualToString:_date5]){
            _index5++;
        }else{
            _index5=0;
        }
//        NSString *telePhone = (NSString *)[listDic objectForKey:@"telePhone"];
//        NSString *customerNameStr = (NSString *)[listDic objectForKey:@"customerNameStr"];
//        //        NSString *phoneTime = (NSString *)[listDic objectForKey:@"phoneTime"];
//        NSString *contactID =(NSString *)[listDic objectForKey:@"contactID"];
//        if (contactName.length==0) {
//            contactName=@"暂无数据";
//        }
////    
//        [self.fakeData addObject:contactName];
//        [self.contactData addObject:telePhone];
//        [self.customerNameStrData addObject:customerNameStr];
//        [self.contactIDData addObject:contactID];
        NSLog(@"index1==>>%d",_index1);
        NSLog(@"index2==>>%d",_index2);
        NSLog(@"index3==>>%d",_index3);
        NSLog(@"index4==>>%d",_index4);
        NSLog(@"index5==>>%d",_index5);
    }
//    return self.fakeData;
    
    return 0;
}
//获取数据2
-(NSMutableArray *)faker11{
    
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"callLogAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@",sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *callLogAction  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"callLogAction字典里面的内容为--》%@", callLogAction);
    NSArray *list = [callLogAction objectForKey:@"obj"];    NSLog(@"callLogActioncallLogAction==>>%lu",[list count]);
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        //        [self.CustomerArr addObject:listDic];
        NSString *time = (NSString *)[listDic objectForKey:@"timeStr"];
       NSString *timeStr = [time substringToIndex:9];//截取下标7之后的字符串
        NSLog(@"time%@",timeStr);
        if([timeStr isEqualToString:_date1]){
            _index11++;
        }else{
            _index11=0;
        }
        if([timeStr isEqualToString:_date2]){
            _index12++;
        }else{
            _index12=0;
        }
        if([timeStr isEqualToString:_date3]){
            _index13++;
        }else{
            _index13=0;
        }
        if([timeStr isEqualToString:_date4]){
            _index14++;
        }else{
            _index14=0;
        }
        if([timeStr isEqualToString:_date5]){
            _index15++;
        }else{
            _index15=0;
        }
        NSLog(@"index11==>>%d",_index11);
        NSLog(@"index12==>>%d",_index12);
        NSLog(@"index13==>>%d",_index13);
        NSLog(@"index14==>>%d",_index14);
        NSLog(@"index15==>>%d",_index15);
    }
    //    return self.fakeData;
    
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
