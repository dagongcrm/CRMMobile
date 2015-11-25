//
//  CustomerCallPlanDetailViewController.m
//  CRMMobile
//
//  Created by yd on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CustomerCallPlanDetailViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "CustomerCallPlanViewController.h"
#import "CustomerCallPlanEditViewController.h"


@interface CustomerCallPlanDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;



@property (weak, nonatomic) IBOutlet UITextField *customerName;

@property (weak, nonatomic) IBOutlet UITextField *theme;

@property (weak, nonatomic) IBOutlet UITextField *accessMethodStr;   //访问方式

@property (weak, nonatomic) IBOutlet UITextField *mainContent;   //重要内容

@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;   //受访人电话

@property (weak, nonatomic) IBOutlet UITextField *respondent;   //受访人员

@property (weak, nonatomic) IBOutlet UITextField *address;   //受访人地址

@property (weak, nonatomic) IBOutlet UITextField *visitProfile;   //拜访概要


@property (weak, nonatomic) IBOutlet UITextField *visitDate;   //拜访时间

@property (weak, nonatomic) IBOutlet UITextField *result;   //达成结果

@property (weak, nonatomic) IBOutlet UITextField *customerRequirements;   //客户需求

@property (weak, nonatomic) IBOutlet UITextField *customerChange;   //客户变故

@property (weak, nonatomic) IBOutlet UITextField *visitorAttributionStr; //拜访人归属

@property (weak, nonatomic) IBOutlet UITextField *baiFangRen;  //拜访人








@end

@implementation CustomerCallPlanDetailViewController
@synthesize customerCallPlanEntity=_customerCallPlanEntity;

- (IBAction)delete:(id)sender {
    NSString *ci= _customerCallPlanEntity.customerCallPlanID;
    
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!delete.action?"]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"ids=%@&MOBILE_SID=%@",ci,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        CustomerCallPlanViewController *mj = [[CustomerCallPlanViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}

//跳转至修改页面
- (IBAction)edit:(id)sender {
    CustomerCallPlanEditViewController *uc =[[CustomerCallPlanEditViewController alloc] init];
    [uc setCustomerCallPlanEntity:_customerCallPlanEntity];
    [self.navigationController pushViewController:uc animated:YES];
}


//确认拜访
- (IBAction)addCallRecords:(id)sender {
    NSString *ci= _customerCallPlanEntity.customerCallPlanID;
    
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!addCallRecords.action?"]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"customerCallPlanID=%@&MOBILE_SID=%@",ci,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        CustomerCallPlanViewController *mj = [[CustomerCallPlanViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    //调节scroll宽度和高度
    self.scroll.contentSize=CGSizeMake(375, 800);
    
    //赋值
    [self valuation];
    
   
}

//赋值
- (void) valuation {
    self.customerName.text  =_customerCallPlanEntity.customerNameStr;
    _visitDate.text=_customerCallPlanEntity.visitDate;
    _theme.text=_customerCallPlanEntity.theme;
    _accessMethodStr.text=_customerCallPlanEntity.accessMethodStr;
    _respondentPhone.text=_customerCallPlanEntity.respondentPhone;
    _respondent.text=_customerCallPlanEntity.respondent;
    _address.text=_customerCallPlanEntity.address;
    _visitProfile.text=_customerCallPlanEntity.visitProfile;
    _result.text=_customerCallPlanEntity.result;
    _customerRequirements.text=_customerCallPlanEntity.customerRequirements;
    _customerChange.text=_customerCallPlanEntity.customerChange;
    _visitorAttributionStr.text=_customerCallPlanEntity.visitorAttributionStr;
    _baiFangRen.text=_customerCallPlanEntity.baiFangRenStr;
    _mainContent.text=_customerCallPlanEntity.mainContent;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end