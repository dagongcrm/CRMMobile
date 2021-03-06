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
#import "NullString.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface EditCustomerContactController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *khmc;//客户名称
@property (weak, nonatomic) IBOutlet UITextField *lxrenxm;//联系人姓名
@property (weak, nonatomic) IBOutlet UITextField *lxrendh;//联系人电话
@property (weak, nonatomic) IBOutlet UITextField *bmen;//部门
@property (weak, nonatomic) IBOutlet UITextField *zhiwu;//职务
@property (strong ,nonatomic) NSString *stateSave;//联系人状态
@property (strong ,nonatomic) NSString *evaluationSave;//销售员评价
@property (strong ,nonatomic) NSString *customerIDSave;//客户ID
@property (strong, nonatomic) IBOutlet UITextView *xsypj;

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
    self.scroll.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    self.khmc.text = _contactEntity.customerNameStr;
    self.lxrenxm.text = _contactEntity.contactName;
    self.lxrendh.text = _contactEntity.telePhone;
    self.bmen.text = _contactEntity.department;
    self.zhiwu.text = _contactEntity.position;
    self.xsypj.text = _contactEntity.evaluationOfTheSalesman;
    _customerIDSave = _contactEntity.customerID;
    _evaluationSave = _contactEntity.evaluationOfTheSalesman;
    _stateSave = _contactEntity.contactState1;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    [self.xsypj.layer setBorderColor:color];
    self.xsypj.layer.borderWidth = 1;
    self.xsypj.layer.cornerRadius = 6;
    self.xsypj.layer.masksToBounds = YES;
    
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
-(BOOL) validateTelphone:(NSString *)mobile
{
    NSString *phoneRegex = @"\\d{3}-\\d{8}|\\d{4}-\\d{7,8}";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
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
    NSString *guishu = _contactEntity.guishuR;
    NSString *contactID = _contactEntity.contactID;
    NSString *customerID = _customerIDSave;
    NSString *tianjiaSJ = _contactEntity.tianjiaSJ;
    NSString *evalation2 = _contactEntity.evaluationOfTheSalesman;
    NSString *state2 = _stateSave;
    NSString *informationAttribution = _contactEntity.informationAttribution;
    NSString *evaluationOfTheSalesman=self.xsypj.text;
    
    if ([NullString isBlankString:customerName]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"客户名称不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else if ([NullString isBlankString:contactName]){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"联系人名称不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else if ([NullString isBlankString:telePhone]){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"联系人电话不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else if ([NullString isBlankString:department]){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"联系人部门不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else if ([NullString isBlankString:position]){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"联系人职务不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else if (!([self validateMobile:self.lxrendh.text]||[self validatePhone:self.lxrendh.text]||[self validateTelphone:self.lxrendh.text])){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"电话号码格式不正确！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
        
    }else{

        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!edit.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&contactID=%@&customerID=%@&customerNameStr=%@&contactName=%@&telePhone=%@&department=%@&position=%@&tianjiaSJ=%@ &evaluationOfTheSalesman=%@&contactState=%@&guishuR=%@&informationAttribution=%@",sid,contactID,customerID,customerName,contactName,telePhone,department,position,tianjiaSJ,evaluationOfTheSalesman,state2,guishu,informationAttribution];
        //
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
            NSLog(@"--------%@",error);
        }else{

        NSDictionary *saveDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
               if([[saveDic objectForKey:@"success"] boolValue] == YES){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[saveDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[saveDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        }
    }
}
- (IBAction)Test:(id)sender {
    NSString *customerName1 = self.khmc.text;
    NSString *contactName1 =self.lxrenxm.text;
    NSString *telePhone1 =self.lxrendh.text;
    NSString *department1=self.bmen.text;
    NSString *position1=self.zhiwu.text;
    NSString *evaluation = _evaluationSave;
    NSString *state1 = _stateSave;
    NSLog(@"联系人状态%@",state1);
    NSLog(@"销售员评jia%@",evaluation);
    [_contactEntity setCustomerName:customerName1];
    [_contactEntity setContactName:contactName1];
    [_contactEntity setTelePhone:telePhone1];
    [_contactEntity setDepartment:department1];
    [_contactEntity setPosition:position1];
    [_contactEntity setEvaluationOfTheSalesman:evaluation];
    [_contactEntity setContactState:state1];
    CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [_contactEntity setIndex:@"1"];
    [list setCustomerEntity:_contactEntity];
    [self.navigationController pushViewController:list animated:YES];
}
@end
