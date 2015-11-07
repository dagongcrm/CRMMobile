//
//  PlanDetalViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/6.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "PlanDetalViewController.h"
#import "VisitPlanTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
@interface PlanDetalViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextField *visitDate;
@property (weak, nonatomic) IBOutlet UILabel *theme;

- (IBAction)delete:(id)sender;
@property (strong,nonatomic)NSMutableArray *listData;

@end

@implementation PlanDetalViewController
@synthesize DailyEntity=_dailyEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"拜访计划";
    self.listData = [[NSMutableArray alloc]init];
    self.customerNameStr.text =_dailyEntity.customerNameStr;
    self.visitDate.text =_dailyEntity.visitDate;
    self.theme.text =_dailyEntity.theme;
    [self.customerNameStr setEnabled:NO];
    [self.visitDate setEnabled:NO];
    [self.theme setEnabled:NO];
    NSString *customerCallPlanIDs =_dailyEntity.customerCallPlanID;
    [self.listData addObject:customerCallPlanIDs];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //       NSLog(@"buttonIndex= %i",buttonIndex);
    if (buttonIndex==1) {
        NSError *error;
        NSString *customerCallPlanID = _dailyEntity.customerCallPlanID;
        NSLog(@"ididididiid>>>%@",customerCallPlanID);
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
        NSLog(@"sid为--》%@", sid);
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!delete.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"customerCallPlanID=%@&MOBILE_SID=%@",customerCallPlanID,sid];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"dailyDic字典里面的内容为--》%@", dailyDic);
        if ([[dailyDic objectForKey:@"success"] boolValue] == YES) {
            VisitPlanTableViewController *dailytv = [[VisitPlanTableViewController alloc]init];
            [self.navigationController pushViewController:dailytv animated:YES];
        }
    }
}
@end
