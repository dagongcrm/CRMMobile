//
//  AddPlanViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/7.
//  Copyright (c) 2015年 dagong. All rights reserved.
//
#import "VisitPlanTableViewController.h"
#import "AddPlanViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "HZQDatePickerView.h"
@interface AddPlanViewController ()
@property (weak, nonatomic) IBOutlet UITextField *visitDate;
@property (weak, nonatomic) IBOutlet UITextField *theme;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (strong, nonatomic) HZQDatePickerView *pikerView;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)Date:(id)sender;



@end

@implementation AddPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加拜访计划";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (IBAction)cancel:(id)sender {
    VisitPlanTableViewController*monthtv = [[VisitPlanTableViewController alloc]init];
    [self.navigationController pushViewController:monthtv animated:YES];
}

- (IBAction)save:(id)sender {
    NSString *date = self.customerNameStr.text;
    NSString *zjie = self.visitDate.text;
    NSString *jhua = self.theme.text;
   
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSLog(@"sid为--》%@", sid);
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!add.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerNameStr=%@&visitDate=%@&theme=%@",sid,date,zjie,jhua];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *AddDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"AddDic字典里面的内容为--》%@", AddDic);
    if ([[AddDic objectForKey:@"success"] boolValue] == YES) {
        VisitPlanTableViewController *monthtv = [[VisitPlanTableViewController alloc]init];
        [self.navigationController pushViewController:monthtv animated:YES];
    }
}


- (IBAction)Date:(id)sender {
    self.pikerView = [HZQDatePickerView instanceDatePickerView];
    
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
    self.visitDate.text = [NSString stringWithFormat:@"%@", date];
}
@end
