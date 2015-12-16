//
//  EditCustomerContactController.m
//  CRMMobile
//
//  Created by why on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "EditCustomerContactController.h"
#import "CustomercontactInfoController.h"
#import "AppDelegate.h"
#import "config.h"
#import "CustomercontactTableViewController.h"
#import "CustomerContactListViewController.h"
#import "UIImage+Tint.h"
@interface EditCustomerContactController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *khmc;//客户名称
@property (weak, nonatomic) IBOutlet UITextField *lxrenxm;//联系人姓名
@property (weak, nonatomic) IBOutlet UITextField *lxrendh;//联系人电话
@property (weak, nonatomic) IBOutlet UITextField *bmen;//部门
@property (weak, nonatomic) IBOutlet UITextField *zhiwu;//职务
@property (weak, nonatomic) IBOutlet UITextField *xsypj;//销售员评价

- (IBAction)cancle:(id)sender;//取消

- (IBAction)saveForEdit:(id)sender;//保存修改

- (IBAction)Test:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtField;

@end

@implementation EditCustomerContactController
@synthesize contactEntity = _contactEntity;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改信息";
    //设置导航栏返回
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage imageNamed:@"back002"] imageWithTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0, 0, 20, 20);
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ResView) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -5;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,rightItem];
    self.scroll.contentSize = CGSizeMake(375, 900);
    self.khmc.text = _contactEntity.customerNameStr;
    self.lxrenxm.text = _contactEntity.contactName;
    self.lxrendh.text = _contactEntity.telePhone;
    self.bmen.text = _contactEntity.department;
    self.zhiwu.text = _contactEntity.position;
    self.xsypj.text = _contactEntity.evaluationOfTheSalesman;
    if (_contactEntity.customerName.length==0) {
    self.khmc.text=_contactEntity.customerNameStr;
    }else{
        self.khmc.text=_contactEntity.customerName;
    }
}
- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CustomercontactInfoController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//取消
- (IBAction)cancle:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CustomercontactInfoController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
-(BOOL) validatePhone:(NSString *)phone
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    return [phoneNumber evaluateWithObject:phone];
}

//保存修改
- (IBAction)saveForEdit:(id)sender {
    NSString *customerName = self.khmc.text;
    NSString *contactName =self.lxrenxm.text;
    NSString *telePhone =self.lxrendh.text;
    NSString *department=self.bmen.text;
    NSString *position=self.zhiwu.text;
    NSString *contactID = _contactEntity.contactID;
    NSString *customerID = _contactEntity.customerID;
    NSString *tianjiaSJ = _contactEntity.tianjiaSJ;
    NSLog(@"tianjiaSJtianjiaSJ%@",tianjiaSJ);
    NSLog(@"whywhywhwyhwyu%@",customerID);
    NSString *evaluationOfTheSalesman=self.xsypj.text;
    if (customerName.length==0||contactName.length==0||telePhone.length==0||department.length==0||position.length==0||evaluationOfTheSalesman.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"文本框输入框不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else if (!([self validateMobile:self.lxrendh.text]||[self validatePhone:self.lxrendh.text])){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"电话号码格式不正确！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
        
    }else{
        NSLog(@"mmmmmmmm//////%@",customerName);
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!edit.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&contactID=%@&customerID=%@&customerName=%@&contactName=%@&telePhone=%@&department=%@&position=%@&tianjiaSJ=%@",sid,contactID,customerID,customerName,contactName,telePhone,department,position,evaluationOfTheSalesman,tianjiaSJ];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *saveDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"saveDic字典里面的内容为--》%@", saveDic);
//        if ([[saveDic objectForKey:@"success"] boolValue] == YES) {
//            CustomercontactTableViewController *contant = [[CustomercontactTableViewController alloc]init];
//            [self.navigationController pushViewController:contant animated:YES];
//        }
        if([[saveDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[saveDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            CustomercontactTableViewController *contant = [[CustomercontactTableViewController alloc]init];
            [self.navigationController pushViewController:contant animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[saveDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }

    }
}
- (IBAction)Test:(id)sender {
    NSString *customerName1 = self.khmc.text;
    NSString *contactName1 =self.lxrenxm.text;
    NSString *telePhone1 =self.lxrendh.text;
    NSString *department1=self.bmen.text;
    NSString *position1=self.zhiwu.text;
//    NSString *contactID = _contactEntity.contactID;
    [_contactEntity setCustomerName:customerName1];
    [_contactEntity setContactName:contactName1];
    [_contactEntity setTelePhone:telePhone1];
    [_contactEntity setDepartment:department1];
    [_contactEntity setPosition:position1];
    CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [_contactEntity setIndex:@"1"];
    [list setCustomerEntity:_contactEntity];
    [self.navigationController pushViewController:list animated:YES];
}
@end
