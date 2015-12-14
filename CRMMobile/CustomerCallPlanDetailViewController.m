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
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#define APIKey @"cdf41cce83fb64756ba13022997e5e74"


@interface CustomerCallPlanDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextView *mainContent;


@property (weak, nonatomic) IBOutlet UITextField *customerName;


@property (weak, nonatomic) IBOutlet UITextView *theme;

@property (weak, nonatomic) IBOutlet UITextField *accessMethodStr;   //访问方式

@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;   //受访人电话

@property (weak, nonatomic) IBOutlet UITextField *respondent;   //受访人员

@property (weak, nonatomic) IBOutlet UITextView *address;

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
//@synthesize locationManager=_locationManager;

- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
    [self alertView:nil clickedButtonAtIndex:1];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!delete.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&ids=%@",sid,_customerCallPlanEntity.customerCallPlanID];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *deleteInfo  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        //NSLog(@"deleteInfo字典里面的内容为--》%@", deleteInfo);
        if ([[deleteInfo objectForKey:@"success"] boolValue] == YES) {
            CustomerCallPlanViewController *contant = [[CustomerCallPlanViewController alloc]init];
            [self.navigationController pushViewController:contant animated:YES];
        }
    }
}
//跳转至修改页面
- (IBAction)edit:(id)sender {
    CustomerCallPlanEditViewController *uc =[[CustomerCallPlanEditViewController alloc] init];
    [uc setCustomerCallPlanEntity:_customerCallPlanEntity];
    [self.navigationController pushViewController:uc animated:YES];
}

//定位功能
-(Boolean)Location{
//    [AMapLocationServices sharedServices].apiKey =@"您的key";
//    self.locationManager = [[AMapLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    NSError *error;
//    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
//    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!addCallRecords.action?"]];
//    
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval=10.0;
//    request.HTTPMethod=@"POST";
//    NSString *param=[NSString stringWithFormat:@"customerCallPlanID=%@&MOBILE_SID=%@",ci,sid];
//    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    
//    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        CustomerCallPlanViewController *mj = [[CustomerCallPlanViewController alloc] init];
//        [self.navigationController pushViewController:mj animated:YES];
//        [alert show];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        
//    }

    return false;
}


-(void)alertView1:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
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
}
//确认拜访
- (IBAction)addCallRecords:(id)sender {
    UIAlertView *alertView1 = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否 确认拜访？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView1 show];
    [self alertView1:nil clickedButtonAtIndex:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //调节scroll宽度和高度
    self.title=@"拜访计划";
    self.scroll.contentSize=CGSizeMake(375, 1100);
    

    //赋值
    [self valuation];
    
   
}

//赋值
- (void) valuation {
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    
    
    [self.theme.layer setBorderColor:color];
    self.theme.layer.borderWidth = 1;
    self.theme.layer.cornerRadius = 6;
    self.theme.layer.masksToBounds = YES;
    self.theme.editable = NO;
    
    [self.mainContent.layer setBorderColor:color];
    self.mainContent.layer.borderWidth = 1;
    self.mainContent.layer.cornerRadius = 6;
    self.mainContent.layer.masksToBounds = YES;
    self.mainContent.editable = NO;
    
    [self.address.layer setBorderColor:color];
    self.address.layer.borderWidth = 1;
    self.address.layer.cornerRadius = 6;
    self.address.layer.masksToBounds = YES;
    self.address.editable = NO;
    
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
    
    [self.customerName setEnabled:NO];
    [self.visitDate setEnabled:NO];
//    [self.theme setEnabled:NO];
    [self.customerChange setEnabled:NO];
    [self.baiFangRen setEnabled:NO];
    [self.accessMethodStr setEnabled:NO];
//    [self.mainContent setEnabled:NO];
    [self.respondentPhone setEnabled:NO];
    [self.respondent setEnabled:NO];
//    [self.address setEnabled:NO];
    [self.visitProfile setEnabled:NO];
    [self.result setEnabled:NO];
    [self.customerRequirements setEnabled:NO];
    [self.visitorAttributionStr setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
