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
@property (weak, nonatomic) IBOutlet UITextField *CustomerAddress;
@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *ReceptionPersonnel;




@end

@implementation CustomerInformationDetailViewController
@synthesize customerInformationEntity=_customerInformationEntity;

//删除
- (IBAction)delete:(id)sender {
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

//跳转至修改页面
- (IBAction)edit:(id)sender {
    CustomerInformationEditViewController *uc =[[CustomerInformationEditViewController alloc] init];
    [uc setCustomerInformationEntity:_customerInformationEntity];
    [self.navigationController pushViewController:uc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //赋值
    [self valuation];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
