//
//  CustomerInformationDetailViewController.m
//  CRMMobile
//
//  Created by yd on 15/10/30.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CustomerInformationDetailViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "CustomerInformationTableViewController.h"
#import "CustomerInformationEditViewController.h"


@interface CustomerInformationDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *CustomerNAME;
@property (weak, nonatomic) IBOutlet UITextField *IndustryIDStr;
@property (weak, nonatomic) IBOutlet UITextField *CompanyTypeStr;
@property (weak, nonatomic) IBOutlet UITextField *CustomerClassStr;
@property (weak, nonatomic) IBOutlet UITextField *ProvinceStr;
@property (weak, nonatomic) IBOutlet UITextField *ShiChangXQFL;
//@property (weak, nonatomic) IBOutlet UITextView *ShiChangXQFL;

//@property (weak, nonatomic) IBOutlet UITextField *CustomerAddress;
@property (weak, nonatomic) IBOutlet UITextView *CustomerAddress;


@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *ReceptionPersonnel;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation CustomerInformationDetailViewController
@synthesize customerInformationEntity=_customerInformationEntity;

//删除
- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否确定删除这条档案信息？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
    
    NSString *ci= _customerInformationEntity.customerID;
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerInformationAction!delete.action?"]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"ids=%@&MOBILE_SID=%@",ci,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        CustomerInformationTableViewController *mj = [[CustomerInformationTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        //        for (UIViewController *controller in self.navigationController.viewControllers)
        //        {
        //            if ([controller isKindOfClass:[CustomerInformationTableViewController class]])
        //            {
        //                [self.navigationController popToViewController:controller animated:YES];
        //            }
        //        }
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    }
}

//跳转至修改页面
- (IBAction)edit:(id)sender {
    CustomerInformationEditViewController *uc =[[CustomerInformationEditViewController alloc] init];
    [uc setCustomerInformationEntity:_customerInformationEntity];
    [self.navigationController pushViewController:uc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"查看客户档案管理表";
    self.scroll.contentSize=CGSizeMake(375,800);
    //赋值
    [self valuation];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    [self.CustomerAddress.layer setBorderColor:color];
    self.CustomerAddress.layer.borderWidth = 1;
    self.CustomerAddress.layer.cornerRadius = 6;
    self.CustomerAddress.layer.masksToBounds = YES;
        self.CustomerAddress.editable = NO;
    
}

- (void) valuation {
    self.CustomerNAME.text  =_customerInformationEntity.customerName;
    self.IndustryIDStr.text  =_customerInformationEntity.industryIDStr;
    self.CompanyTypeStr.text  =_customerInformationEntity.companyTypeStr;
    self.CustomerClassStr.text  =_customerInformationEntity.customerClassStr;
    self.ProvinceStr.text  =_customerInformationEntity.provinceStr;
    self.ShiChangXQFL.text  =_customerInformationEntity.shiChangXQFL;
    self.CustomerAddress.text  =_customerInformationEntity.customerAddress;
    self.Phone.text  =_customerInformationEntity.phone;
    self.ReceptionPersonnel.text  =_customerInformationEntity.receptionPersonnel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
