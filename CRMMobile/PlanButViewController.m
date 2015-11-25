//
//  PlanButViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/20.
//  Copyright (c) 2015年 dagong. All rights reserved.
//
#import "CustomerContactListViewController.h"
#import "CustomercontactTableViewController.h"
#import "PlanButViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "VisitPlanTableViewController.h"

@interface PlanButViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextField *visitDate;
@property (weak, nonatomic) IBOutlet UITextField *theme;

@property (weak, nonatomic) IBOutlet UITextField *accessMethod;

@property (weak, nonatomic) IBOutlet UITextField *mainContent;
@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;
@property (weak, nonatomic) IBOutlet UITextField *respondent;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *visitProfile;
@property (weak, nonatomic) IBOutlet UITextField *result;
@property (weak, nonatomic) IBOutlet UITextField *customerRequirements;
@property (weak, nonatomic) IBOutlet UITextField *customerChange;
@property (weak, nonatomic) IBOutlet UITextField *visitorStr;
//- (IBAction)but:(id)sender;
- (IBAction)save:(id)sender;
//- (IBAction)goback:(id)sender;

@end

@implementation PlanButViewController
//@synthesize customerEntity=_customerEntity;
@synthesize context = _context;
@synthesize addCustomerEntity = _addCustomerEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改信息";
    //设置导航栏返回
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.scroll.contentSize = CGSizeMake(375, 1300);
    //    self.listData = [[NSMutableArray alloc]init];
    NSString *customerName1 = self.customerNameStr.text;
    NSString *visitDate =self.visitDate.text;
    NSString *telePhone1 =self.theme.text;
    NSString *department1=self.accessMethod.text;
    NSString *position1=self.mainContent.text;
    NSString *respondentPhone = self.respondentPhone.text;
    NSString *respondent =self.respondent.text;
    NSString *address =self.address.text;
    NSString *visitProfile=self.visitProfile.text;
    NSString *result=self.result.text;
    NSString *customerRequirements = self.customerRequirements.text;
    NSString *customerChange =self.customerChange.text;
    NSString *visitorStr =self.visitorStr.text;
    
   NSString *customerName= _context;
    if(customerName1.length!=0){
        self.customerNameStr.text=_addCustomerEntity.customerNameStr;
    }
    if(visitDate.length!=0){
        self.visitDate.text =_addCustomerEntity.visitDate;
    }
    if (telePhone1.length!=0){
        self.theme.text=_addCustomerEntity.theme;
    }
    if(department1.length!=0){
        self.accessMethod.text=_addCustomerEntity.accessMethod;
    }
    if (position1.length!=0) {
        self.mainContent.text =_addCustomerEntity.mainContent;
    }
    if(respondentPhone.length!=0){
        self.respondentPhone.text=_addCustomerEntity.respondentPhone;
    }
    if(respondent .length!=0){
        self.respondent .text =_addCustomerEntity.respondent ;
    }
    if (address.length!=0){
        self.address.text=_addCustomerEntity.address;
    }
    if(visitProfile.length!=0){
        self.visitProfile.text=_addCustomerEntity.visitProfile;
    }
    if (customerRequirements.length!=0) {
        self.customerRequirements.text =_addCustomerEntity.customerRequirements;
    }
    if (address.length!=0){
        self.address.text=_addCustomerEntity.address;
    }
    if(customerChange.length!=0){
        self.customerChange.text=_addCustomerEntity.customerChange;
    }
    if (visitorStr.length!=0) {
        self.visitorStr.text =_addCustomerEntity.visitorStr;
    }

//    self.respondentPhone.text =_addCustomerEntity.respondentPhone;
//    self.respondent.text =_addCustomerEntity.respondent;
//    self.address.text =_addCustomerEntity.address;
//    self.visitProfile.text =_addCustomerEntity.visitProfile;
//    self.result.text =_addCustomerEntity.result;
//    self.customerRequirements.text =_addCustomerEntity.customerRequirements;
//    self.customerChange.text =_addCustomerEntity.customerChange;
//    self.visitorStr.text =_addCustomerEntity.visitorStr;
    

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)but:(id)sender {
}

- (IBAction)save:(id)sender {
    NSString *c1=self.customerNameStr.text;
    NSString *c2=self.visitDate.text;
    NSString *c3=self.theme.text;
    NSString *c4=self.accessMethod.text;
    NSString *c5=self.mainContent.text;
    NSString *c6=self.respondentPhone.text;
    NSString *c7=self.respondent.text;
    NSString *c8=self.address.text;
    NSString *c9=self.visitProfile.text;
    NSString *c10=self.result.text;
    NSString *c11=self.customerRequirements.text;
    NSString *c12=self.customerChange.text;
    NSString *c13=self.visitorStr.text;
    NSString *customerCallPlanID =_addCustomerEntity.customerCallPlanID;
    if (c1.length==0||c2.length==0||c3.length==0||c4.length==0||c5.length==0||c6.length==0||c7.length==0||c8.length==0||c9.length==0||c10.length==0||c11.length==0||c12.length==0||c13.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"文本框输入框不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else{
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!edit.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerCallPlanID=%@&customerNameStr=%@&visitDate=%@&theme=%@&accessMethod=%@&mainContent=%@&respondentPhone=%@&respondent=%@&address=%@&visitProfile=%@&result=%@&customerRequirements=%@&customerChange=%@&visitorStr=%@",sid,customerCallPlanID,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *saveDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"saveDic字典里面的内容为--》%@", saveDic);
        if ([[saveDic objectForKey:@"success"] boolValue] == YES) {
            VisitPlanTableViewController *contant = [[VisitPlanTableViewController alloc]init];
            [self.navigationController pushViewController:contant animated:YES];
        }
    }


}

- (IBAction)goback:(id)sender {
}
@end
