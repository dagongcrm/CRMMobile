//
//  AddDailyViewController.m
//  CRMMobile
//
//  Created by why on 15/11/4.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddDailyViewController.h"
#import "DailyTableViewController.h"
#import "HZQDatePickerView.h"
#import "config.h"
#import "AppDelegate.h"

@interface AddDailyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *jihua;
@property (weak, nonatomic) IBOutlet UITextField *zongjie;
@property (weak, nonatomic) IBOutlet UITextField *bumen;
@property (weak, nonatomic) IBOutlet UITextField *leixing;
@property (strong, nonatomic) HZQDatePickerView *pikerView;
- (IBAction)datepicker:(id)sender;

- (IBAction)cancle:(id)sender;
- (IBAction)Add:(id)sender;

@end

@implementation AddDailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加工作日报";
    self.bumen.text =@"销售部";
    self.leixing.text=@"日报";
    [self.bumen setEnabled:NO];
    [self.leixing setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datepicker:(id)sender {
    NSLog(@"为什么躲在里面");
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
            self.time.text = [NSString stringWithFormat:@"%@", date];
}
//返回
- (IBAction)cancle:(id)sender {
    DailyTableViewController *dailytv = [[DailyTableViewController alloc]init];
    [self.navigationController pushViewController:dailytv animated:YES];
}
//保存
- (IBAction)Add:(id)sender {
    NSString *date = self.time.text;
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
//    NSLog(@"sid为--》%@", sid);
  
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"taskReportAction!add.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&time=%@&report=%@&type=%@&orgID=%@&daily=%@",sid,date,zjie,jhua,bmen,lxing];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *AddDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"AddDic字典里面的内容为--》%@", AddDic);
    if ([[AddDic objectForKey:@"success"] boolValue] == YES) {
        DailyTableViewController *dailytv = [[DailyTableViewController alloc]init];
        [self.navigationController pushViewController:dailytv animated:YES];    }
    }
}
@end
