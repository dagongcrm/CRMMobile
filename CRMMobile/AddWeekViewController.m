//
//  AddWeekViewController.m
//  CRMMobile
//
//  Created by why on 15/11/5.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddWeekViewController.h"
#import "HZQDatePickerView.h"
#import "WeekTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
@interface AddWeekViewController ()
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *zongjie;
@property (weak, nonatomic) IBOutlet UITextField *jihua;
@property (weak, nonatomic) IBOutlet UITextField *leixing;
@property (weak, nonatomic) IBOutlet UITextField *bumen;
@property (strong, nonatomic) HZQDatePickerView *pikerView;
- (IBAction)choiceTime:(id)sender;
- (IBAction)cancle:(id)sender;
- (IBAction)Submit:(id)sender;

@end

@implementation AddWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加工作周报";
    self.bumen.text =@"销售部";
    self.leixing.text=@"周报";
    [self.bumen setEnabled:NO];
    [self.leixing setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)choiceTime:(id)sender {
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    //    _pikerView.frame = CGRectMake(0, 0, ScreenRectWidth, ScreenRectHeight + 20);
    DateType type ;
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    //    self.time.text = date;
    [self.view addSubview:_pikerView];
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    self.date.text = [NSString stringWithFormat:@"%@", date];
}

- (IBAction)cancle:(id)sender {
    WeekTableViewController *weektv = [[WeekTableViewController alloc]init];
    [self.navigationController pushViewController:weektv animated:YES];
}

- (IBAction)Submit:(id)sender {
    NSString *date = self.date.text;
    NSString *zjie = self.zongjie.text;
    NSString *jhua = self.jihua.text;
    NSString *lxing = self.leixing.text;
    NSString *bmen = self.bumen.text;
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSLog(@"sid为--》%@", sid);
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"taskReportWAction!add.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&time=%@&report=%@&type=%@&orgID=%@&daily=%@",sid,date,zjie,jhua,bmen,lxing];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *AddDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"AddDic字典里面的内容为--》%@", AddDic);
    if ([[AddDic objectForKey:@"success"] boolValue] == YES) {
        WeekTableViewController *weektv = [[WeekTableViewController alloc]init];
        [self.navigationController pushViewController:weektv animated:YES];
    }
 
}
@end
