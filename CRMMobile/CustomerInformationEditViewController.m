//
//  CustomerInformationEditViewController.m
//  CRMMobile
//
//  Created by yd on 15/11/4.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CustomerInformationEditViewController.h"
#import "AppDelegate.h"
#import "CustomerInformationTableViewController.h"
#import "config.h"


@interface CustomerInformationEditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customerNAME;

@end

@implementation CustomerInformationEditViewController
@synthesize customerInformationEntity=_customerInformationEntity;

//修改保存
- (IBAction)edit:(id)sender {
    NSString *ci=_customerInformationEntity.customerID;
    NSString *cn=[_customerNAME text];
    
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerInformationAction!edit.action?"]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"customerID=%@&customerName=%@&MOBILE_SID=%@",ci,cn,sid];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    _customerNAME.text=_customerInformationEntity.customerName;

    
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
