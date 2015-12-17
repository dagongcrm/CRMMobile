//
//  AddMonthViewController.m
//  CRMMobile
//
//  Created by why on 15/11/5.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddMonthViewController.h"
#import "HZQDatePickerView.h"
#import "MonthTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
@interface AddMonthViewController ()
@property (weak, nonatomic) IBOutlet UITextField *date;
//@property (weak, nonatomic) IBOutlet UITextField *zongjie;
//@property (weak, nonatomic) IBOutlet UITextField *jihua;
@property (weak, nonatomic) IBOutlet UITextView *zongjie;
@property (weak, nonatomic) IBOutlet UITextView *jihua;

@property (weak, nonatomic) IBOutlet UITextField *leixing;
@property (weak, nonatomic) IBOutlet UITextField *bumen;
@property (strong, nonatomic) HZQDatePickerView *pikerView;
- (IBAction)choiceTime:(id)sender;
- (IBAction)cancle:(id)sender;
- (IBAction)Submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll1;

@end

@implementation AddMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加工作月报";
    self.scroll1.contentSize = CGSizeMake(375, 700);
    self.bumen.text =@"销售部";
    self.leixing.text=@"月报";
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    [self.jihua.layer setBorderColor:color];
    self.jihua.layer.borderWidth = 1;
    self.jihua.layer.cornerRadius = 6;
    self.jihua.layer.masksToBounds = YES;
    [self.zongjie.layer setBorderColor:color];
    self.zongjie.layer.borderWidth = 1;
    self.zongjie.layer.cornerRadius = 6;
    self.zongjie.layer.masksToBounds = YES;

    [self.date setEnabled:NO];
    [self.bumen setEnabled:NO];
    [self.leixing setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)choiceTime:(id)sender {
    _pikerView = [HZQDatePickerView instanceDatePickerView];
//        _pikerView.frame = CGRectMake(0, 0, ScreenRectWidth, ScreenRectHeight + 20);
    DateType type ;
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    //设置日历的最小时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:-1];
    
    //      [adcomps setMonth:month];
    //
    //        [adcomps setDay:day];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    [_pikerView.datePickerView setMinimumDate:newdate];
    //    self.time.text = date;
    [self.view addSubview:_pikerView];
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    self.date.text = [NSString stringWithFormat:@"%@", date];
}

- (IBAction)cancle:(id)sender {
    MonthTableViewController *monthtv = [[MonthTableViewController alloc]init];
    [self.navigationController pushViewController:monthtv animated:YES];
}

- (IBAction)Submit:(id)sender {
    NSString *date = self.date.text;
    NSString *zjie = self.zongjie.text;
    NSString *jhua = self.jihua.text;
    NSString *lxing = self.leixing.text;
    NSString *bmen = self.bumen.text;
    if(date.length==0||zjie.length==0||jhua.length==0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"添加信息的文本不能为空？" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
    }else{
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSLog(@"sid为--》%@", sid);
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"taskReportMAction!add.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&time=%@&report=%@&type=%@&orgID=%@&daily=%@",sid,date,zjie,jhua,bmen,lxing];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *AddDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"AddDic字典里面的内容为--》%@", AddDic);
    if ([[AddDic objectForKey:@"success"] boolValue] == YES) {
        MonthTableViewController *monthtv = [[MonthTableViewController alloc]init];
        [self.navigationController pushViewController:monthtv animated:YES];
    }
    }
}
@end
