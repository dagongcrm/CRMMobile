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
#import "AFHTTPRequestOperationManager.h"
@interface MarketManagementViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *DateData;
@end

@implementation MarketManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  DateForIn];
    [self  getDataForActivity];
    [self  getDataForTel];
}

- (void)setUpActivityUI{
    self.title=@"活动统计";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 800);
    UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 30)];
    lineChartLabel.text = @"拜访签到:活动次数";
    lineChartLabel.textColor = PNFreshGreen;
    lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    lineChartLabel.textAlignment = NSTextAlignmentCenter;
    PNChart * lineChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 75.0, SCREEN_WIDTH, 200.0)];
    lineChart.backgroundColor = [UIColor clearColor];
    NSString *d1 = [NSString stringWithFormat:@"%d",self.acitvityIndex1];
    NSString *d2 = [NSString stringWithFormat:@"%d",self.acitvityIndex2];
    NSString *d3 = [NSString stringWithFormat:@"%d",self.acitvityIndex3];
    NSString *d4 = [NSString stringWithFormat:@"%d",self.acitvityIndex4];
    NSString *d5 = [NSString stringWithFormat:@"%d",self.acitvityIndex5];
    [lineChart setXLabels:@[[self.date1 substringFromIndex:5],[self.date2 substringFromIndex:5],[self.date3 substringFromIndex:5],[self.date4 substringFromIndex:5],[self.date5 substringFromIndex:5]]];
    [lineChart setYValues:@[d1,d2,d3,d4,d5]];
    [lineChart strokeChart];
    [self.scrollView addSubview:lineChartLabel];
    [self.scrollView addSubview:lineChart];
}

-(void) setUpTelUI{
    UILabel * lineChartLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 30)];
    lineChartLabel1.text = @"电话:电话次数";
    lineChartLabel1.textColor = PNFreshGreen;
    lineChartLabel1.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    lineChartLabel1.textAlignment = NSTextAlignmentCenter;
    PNChart * lineChart1 = [[PNChart alloc] initWithFrame:CGRectMake(0, 335.0, SCREEN_WIDTH, 200.0)];
    lineChart1.backgroundColor = [UIColor clearColor];
    NSString *d11 = [NSString stringWithFormat:@"%d",self.telIndex1];
    NSString *d12 = [NSString stringWithFormat:@"%d",self.telIndex2];
    NSString *d13 = [NSString stringWithFormat:@"%d",self.telIndex3];
    NSString *d14 = [NSString stringWithFormat:@"%d",self.telIndex4];
    NSString *d15 = [NSString stringWithFormat:@"%d",self.telIndex5];
    [lineChart1 setXLabels:@[[self.date1 substringFromIndex:5],[self.date2 substringFromIndex:5],[self.date3 substringFromIndex:5],[self.date4 substringFromIndex:5],[self.date5 substringFromIndex:5]]];
    [lineChart1 setYValues:@[d11,d12,d13,d14,d15]];
    [lineChart1 strokeChart];
    [self.scrollView addSubview:lineChartLabel1];
    [self.scrollView addSubview:lineChart1];
}

-(void)DateForIn{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSInteger weekDay = [comp weekday];
    NSInteger day = [comp day];
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff+1];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    [firstDayComp setDay:day + firstDiff+2];
    NSDate *twoDayOfWeek= [calendar dateFromComponents:firstDayComp];
    [firstDayComp setDay:day + firstDiff+3];
    NSDate *threeDayOfWeek= [calendar dateFromComponents:firstDayComp];
    [firstDayComp setDay:day + firstDiff+4];
    NSDate *fourDayOfWeek= [calendar dateFromComponents:firstDayComp];
    [firstDayComp setDay:day + firstDiff+5];
    NSDate *fiveDayOfWeek= [calendar dateFromComponents:firstDayComp];
    [firstDayComp setDay:day + firstDiff+6];
    NSDate *sixDayOfWeek= [calendar dateFromComponents:firstDayComp];
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff-1];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.date1 = [dateFormatter stringFromDate:firstDayOfWeek];
    self.date2 = [dateFormatter stringFromDate:twoDayOfWeek]  ;
    self.date3 = [dateFormatter stringFromDate:threeDayOfWeek];
    self.date4 = [dateFormatter stringFromDate:fourDayOfWeek];
    self.date5 = [dateFormatter stringFromDate:fiveDayOfWeek];
    self.date6 = [dateFormatter stringFromDate:sixDayOfWeek];
    self.date7 = [dateFormatter stringFromDate:lastDayOfWeek];
}


-(void)getDataForActivity{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSDictionary *parameters = @{@"MOBILE_SID":sid,
                                 @"order":@"desc",
                                 @"sort" :@"time"};
    [manager POST:[SERVER_URL stringByAppendingString:@"mcustomerCallRecordsAction!mDatagrid1.action?"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSArray *list = [responseObject objectForKey:@"obj"];
            for (int i = 0;i<[list count];i++) {
                NSDictionary *listDic =[list objectAtIndex:i];
                NSString *time = (NSString *)[listDic objectForKey:@"visitDate"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                NSDate *date=[formatter dateFromString:time];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *timeString= [formatter stringFromDate:date];
                time=timeString;
                if([time isEqualToString:self.date1]){
                    self.acitvityIndex1++;
                }else if([time isEqualToString:self.date2]){
                    self.acitvityIndex2++;
                }else if([time isEqualToString:self.date3]){
                    self.acitvityIndex3++;
                }else if([time isEqualToString:self.date4]){
                    self.acitvityIndex4++;
                }else if([time isEqualToString:self.date5]){
                    self.acitvityIndex5++;
                }
            }
            NSString *data= [NSString stringWithFormat:@"%d",self.acitvityIndex1];
            [self performSelectorOnMainThread:@selector(setUpActivityUI) withObject:data waitUntilDone:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
    }];
}

-(void)getDataForTel{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSDictionary *parameters = @{@"MOBILE_SID":sid};
    [manager POST:[SERVER_URL stringByAppendingString:@"callLogAction!datagrid.action?"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSArray *list = [responseObject objectForKey:@"obj"];
            for (int i = 0;i<[list count];i++) {
                NSDictionary *listDic =[list objectAtIndex:i];
                NSString *time = (NSString *)[listDic objectForKey:@"time"];
                NSString *timeStr = [time substringToIndex:10];
                if([timeStr isEqualToString:self.date1]){
                    self.telIndex1++;
                }else if([timeStr isEqualToString:self.date2]){
                    self.telIndex2++;
                }else if([timeStr isEqualToString:self.date3]){
                    self.telIndex3++;
                }else if([timeStr isEqualToString:self.date4]){
                    self.telIndex4++;
                }else if([timeStr isEqualToString:self.date5]){
                    self.telIndex5++;
                }
            }
            NSString *data= [NSString stringWithFormat:@"%d",self.telIndex1];
            [self performSelectorOnMainThread:@selector(setUpTelUI) withObject:data waitUntilDone:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
    }];
}
@end
