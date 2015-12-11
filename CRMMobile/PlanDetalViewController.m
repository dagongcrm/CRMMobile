//
//  PlanDetalViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/6.
//  Copyright (c) 2015年 dagong. All rights reserved.
//


#import "EditPlanViewController.h"
#import "PlanDetalViewController.h"
#import "VisitPlanTableViewController.h"
#import "config.h"
#import "AppDelegate.h"

@interface PlanDetalViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextView *theme;
@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;
@property (weak, nonatomic) IBOutlet UITextField *respondent;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UITextField *visitProfile;
@property (weak, nonatomic) IBOutlet UITextField *visitDate;
@property (weak, nonatomic) IBOutlet UITextField *result;
@property (weak, nonatomic) IBOutlet UITextField *customerRequirements;
@property (weak, nonatomic) IBOutlet UITextField *customerChange;
@property (weak, nonatomic) IBOutlet UITextField *visitorAttributionStr;
@property (weak, nonatomic) IBOutlet UITextField *accessmethod;

@property (weak, nonatomic) IBOutlet UITextView *mainContent;

@property (weak, nonatomic) IBOutlet UITextField *visitorStr;

- (IBAction)edit:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)visitQR:(id)sender;

@property (strong,nonatomic)NSMutableArray *listData;

@end

@implementation PlanDetalViewController
@synthesize customerCallPlanEntity=_customerCallPlanEntity;
@synthesize DailyEntity=_dailyEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"拜访计划";
    //调节scroll宽度和高度
    self.scroll.contentSize=CGSizeMake(375, 1060);
    
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
    self.customerNameStr.text  =_customerCallPlanEntity.customerNameStr;
    _visitDate.text=_customerCallPlanEntity.visitDate;
    _theme.text=_customerCallPlanEntity.theme;
    _accessmethod.text=_customerCallPlanEntity.accessMethodStr;
    _respondentPhone.text=_customerCallPlanEntity.respondentPhone;
    _respondent.text=_customerCallPlanEntity.respondent;
    _address.text=_customerCallPlanEntity.address;
    _visitProfile.text=_customerCallPlanEntity.visitProfile;
    _result.text=_customerCallPlanEntity.result;
    _customerRequirements.text=_customerCallPlanEntity.customerRequirements;
    _customerChange.text=_customerCallPlanEntity.customerChange;
    _visitorAttributionStr.text=_customerCallPlanEntity.visitorAttributionStr;
    _visitorStr.text=_customerCallPlanEntity.baiFangRenStr;
    _mainContent.text=_customerCallPlanEntity.mainContent;
    
    [self.customerNameStr setEnabled:NO];
    [self.visitDate setEnabled:NO];
  
    [self.customerChange setEnabled:NO];
    [self.visitorStr setEnabled:NO];
    [self.accessmethod setEnabled:NO];

    [self.respondentPhone setEnabled:NO];
    [self.respondent setEnabled:NO];

    [self.visitProfile setEnabled:NO];
    [self.result setEnabled:NO];
    [self.customerRequirements setEnabled:NO];
    [self.visitorAttributionStr setEnabled:NO];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)edit:(id)sender {
    EditPlanViewController *uc1 =[[EditPlanViewController alloc] init];
    [uc1 setCustomerCallPlanEntity:_customerCallPlanEntity];
    [self.navigationController pushViewController:uc1 animated:YES];
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
            VisitPlanTableViewController *contant = [[VisitPlanTableViewController alloc]init];
            [self.navigationController pushViewController:contant animated:YES];
        }
    }
}

- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
//    NSString *ci= _customerCallPlanEntity.customerCallPlanID;
//    
//    NSError *error;
//    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
//    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!delete.action?"]];
//    
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval=10.0;
//    request.HTTPMethod=@"POST";
//    NSString *param=[NSString stringWithFormat:@"ids=%@&MOBILE_SID=%@",ci,sid];
//    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    
//    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        VisitPlanTableViewController *mj = [[VisitPlanTableViewController alloc] init];
//        [self.navigationController pushViewController:mj animated:YES];
//        [alert show];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        
//    }
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
            VisitPlanTableViewController *mj = [[VisitPlanTableViewController alloc] init];
            [self.navigationController pushViewController:mj animated:YES];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
    }
}

- (IBAction)visitQR:(id)sender {
    UIAlertView *alertView1= [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView1 show];
}



@end
