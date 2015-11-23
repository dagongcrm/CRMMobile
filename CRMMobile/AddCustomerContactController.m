//
//  AddCustomerContactController.m
//  CRMMobile
//
//  Created by why on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddCustomerContactController.h"
#import "AppDelegate.h"
#import "config.h"
#import "CustomerContactListViewController.h"
#import "CustomercontactTableViewController.h"

@interface AddCustomerContactController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextField *khmc;//客户名称
@property (weak, nonatomic) IBOutlet UITextField *lxrenxm;//联系人姓名
@property (weak, nonatomic) IBOutlet UITextField *lxrendh;//联系人电话
@property (weak, nonatomic) IBOutlet UITextField *bumen;//部门
@property (weak, nonatomic) IBOutlet UITextField *zhiwu;//职务
@property (weak, nonatomic) IBOutlet UITextField *xsypj;//销售员评价
@property (weak, nonatomic) IBOutlet UIButton *AddCustomer;//

- (IBAction)cancleForAdd:(id)sender;//取消
- (IBAction)saveForAdd:(id)sender;//保存
@end

@implementation AddCustomerContactController
@synthesize customerEntity=_customerEntity;
@synthesize context = _context;
@synthesize addCustomerEntity = _addCustomerEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=@"添加联系人信息";
    self.scroll.contentSize = CGSizeMake(375, 1000);
//    //设置导航栏返回
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = item;
//    //设置返回键的颜色
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    NSLog(@"mmmmmmmmmmmmm%@",_addCustomerEntity.customerID);
    NSString *customerName= _context;
    if (customerName.length==0) {
        self.khmc.text=@"";
        NSLog(@"1111111111");
    }else{
        self.khmc.text=_context;
        NSLog(@",,,,,,,,,,,,,,,%@",customerName);
    }
    NSString *a=_addCustomerEntity.contactName;
    NSString *b=_addCustomerEntity.telePhone;
    NSString *c=_addCustomerEntity.department;
    NSString *d=_addCustomerEntity.position;
    NSString *e=_addCustomerEntity.evaluationOfTheSalesman;
    if(a.length!=0){
    self.lxrenxm.text=_addCustomerEntity.contactName;
    }
    if(b.length!=0){
    self.lxrendh.text=_addCustomerEntity.telePhone;
    }
    if (c.length!=0){
    self.bumen.text=_addCustomerEntity.department;
    }
    if(d.length!=0){
    self.zhiwu.text=_addCustomerEntity.position;
    }
    if (e.length!=0) {
        self.xsypj.text =_addCustomerEntity.evaluationOfTheSalesman;
    }
    
}

- (IBAction)cancleForAdd:(id)sender {
    
}

- (IBAction)saveForAdd:(id)sender {
    NSString *customerName = _context;
    NSString *contactName =self.lxrenxm.text;
    NSString *telePhone =self.lxrendh.text;
    NSString *department=self.bumen.text;
    NSString *position=self.zhiwu.text;
    NSString *evaluationOfTheSalesman=self.xsypj.text;
    if (customerName.length==0||contactName.length==0||telePhone.length==0||department.length==0||position.length==0||evaluationOfTheSalesman.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"文本框输入框不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else{
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!add.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *customerID = _addCustomerEntity.customerID;
        NSLog(@"customerIDcustomerIDcustomerIDcustomerIDcustomerIDcustomerID%@",customerID);
        NSLog(@"NNNNNNNNNNNN%@",customerName);
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerID=%@&customerNameStr=%@&contactName=%@&telePhone=%@&department=%@&position=%@&evaluationOfTheSalesman=%@",sid,customerID,_context,contactName,telePhone,department,position,evaluationOfTheSalesman];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *saveForAddDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"saveForAddDic字典里面的内容为--》%@", saveForAddDic);
        if ([[saveForAddDic objectForKey:@"success"] boolValue] == YES) {
            CustomercontactTableViewController *contant = [[CustomercontactTableViewController alloc]init];
            [self.navigationController pushViewController:contant animated:YES];
        }
    }
}
- (IBAction)AddCustomer:(id)sender {
    NSString *customerName = self.khmc.text;
    NSString *contactName =self.lxrenxm.text;
    NSString *telePhone =self.lxrendh.text;
    NSString *department=self.bumen.text;
    NSString *position=self.zhiwu.text;
    NSString *evaluationOfTheSalesman=self.xsypj.text;
    _addCustomerEntity =[[AddCustomerEntity alloc]init];
        [_addCustomerEntity setCustomerName:customerName];

        [_addCustomerEntity setContactName:contactName];
    NSLog(@"222222222sssss%@",contactName);
        [_addCustomerEntity setTelePhone:telePhone];
    
        [_addCustomerEntity setDepartment:department];
    
        [_addCustomerEntity setPosition:position];
   
        [_addCustomerEntity setEvaluationOfTheSalesman:evaluationOfTheSalesman];
    NSLog(@"10101010101010%@",_addCustomerEntity.customerName);
CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [_customerEntity setIndex:@"2"];
    [list setCustomerEntity:_customerEntity];
    [list setAddCustomerEntity:_addCustomerEntity];
    
    [self.navigationController pushViewController:list animated:YES];
}

@end
