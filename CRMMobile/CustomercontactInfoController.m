//
//  CustomercontactInfoController.m
//  CRMMobile
//
//  Created by why on 15/11/16.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CustomercontactInfoController.h"
#import "CustomercontactTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "EditCustomerContactController.h"
@interface CustomercontactInfoController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *khmj;//客户名称
@property (weak, nonatomic) IBOutlet UITextField *lxxm;//联系人姓名
@property (weak, nonatomic) IBOutlet UITextField *lxdh;//联系人电话
@property (weak, nonatomic) IBOutlet UITextField *bum;//部门
@property (weak, nonatomic) IBOutlet UITextField *zhiwu;//职务
@property (weak, nonatomic) IBOutlet UITextField *xspj;//销售员评价
@property (weak, nonatomic) IBOutlet UITextField *xxgs;//信息归属
@property (weak, nonatomic) IBOutlet UITextField *whren;//维护人
@property (weak, nonatomic) IBOutlet UITextField *lxrzt;//联系人状态
@property (weak, nonatomic) IBOutlet UITextField *tjsj;//添加时间
@property (weak, nonatomic) IBOutlet UIButton *stopState;//停止状态

- (IBAction)deleteCustomer:(id)sender;//删除联系人
- (IBAction)stopCustomer:(id)sender;//停用
- (IBAction)editCustomer:(id)sender;//修改

@end

@implementation CustomercontactInfoController
@synthesize contactEntity=_contactEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"用户信息";
    //设置导航栏返回
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.scroll.contentSize = CGSizeMake(375, 1000);
    self.khmj.text = _contactEntity.customerNameStr;
    self.lxxm.text = _contactEntity.contactName;
    self.lxdh.text = _contactEntity.telePhone;
    self.bum.text = _contactEntity.department;
    self.zhiwu.text =_contactEntity.position;
    self.xspj.text = _contactEntity.evaluationOfTheSalesman;
    self.xxgs.text =_contactEntity.informationAttributionStr;
    self.whren.text = _contactEntity.guishuRStr;
    if ([_contactEntity.guishuRStr isEqualToString:@"超级管理员"]) {
       self.xxgs.text = @"运营部";
    }
    self.lxrzt.text = _contactEntity.contactState;
    self.tjsj.text = _contactEntity.tianjiaSJ;
    if([self.lxrzt.text isEqualToString:@"停用"]){
        self.stopState.hidden = YES;
    }
    [self.khmj setEnabled:NO];
    [self.lxxm setEnabled:NO];
    [self.lxdh setEnabled:NO];
    [self.bum setEnabled:NO];
    [self.zhiwu setEnabled:NO];
    [self.xspj setEnabled:NO];
    [self.xxgs setEnabled:NO];
    [self.whren setEnabled:NO];
    [self.lxrzt setEnabled:NO];
    [self.tjsj setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//删除联系人
- (IBAction)deleteCustomer:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
   alertView.tag=1;
    [alertView show];
}
//停用
- (IBAction)stopCustomer:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                               initWithTitle:@"提示信息" message:@"是否停用该联系人？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag=2;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
     if (buttonIndex==1) {
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!delete.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&ids=%@",sid,_contactEntity.contactID];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *deleteInfo  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"deleteInfo字典里面的内容为--》%@", deleteInfo);
         if ([[deleteInfo objectForKey:@"success"] boolValue] == YES) {
             CustomercontactTableViewController *contant = [[CustomercontactTableViewController alloc]init];
             [self.navigationController pushViewController:contant animated:YES];
         }
     }
    }else if(alertView.tag==2){
        if (buttonIndex==1) {
            NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
            NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!stop.action?"]];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
            request.timeoutInterval=10.0;
            request.HTTPMethod=@"POST";
            NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&ids=%@",sid,_contactEntity.contactID];
            request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSDictionary *deleteInfo  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"deleteInfo字典里面的内容为--》%@", deleteInfo);
            if ([[deleteInfo objectForKey:@"success"] boolValue] == YES) {
                CustomercontactTableViewController *contant = [[CustomercontactTableViewController alloc]init];
                [self.navigationController pushViewController:contant animated:YES];
            }
        }
    }
}
//修改
- (IBAction)editCustomer:(id)sender {
    EditCustomerContactController *editCustomer = [[EditCustomerContactController alloc]init];
    [editCustomer setContactEntity:self.contactEntity];
    [self.navigationController pushViewController:editCustomer animated:YES];
}
@end
