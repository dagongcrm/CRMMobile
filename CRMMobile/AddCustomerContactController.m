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
#import "UIImage+Tint.h"
#import "NullString.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface AddCustomerContactController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextField *khmc;//客户名称
@property (weak, nonatomic) IBOutlet UITextField *lxrenxm;//联系人姓名
@property (weak, nonatomic) IBOutlet UITextField *lxrendh;//联系人电话
@property (weak, nonatomic) IBOutlet UITextField *bumen;//部门
@property (weak, nonatomic) IBOutlet UITextField *zhiwu;//职务

@property (weak, nonatomic) IBOutlet UIButton *AddCustomer;//
@property (strong, nonatomic) IBOutlet UITextView *xsypj;

- (IBAction)cancleForAdd:(id)sender;//取消
- (IBAction)saveForAdd:(id)sender;//保存
@end

@implementation AddCustomerContactController
@synthesize customerEntity=_customerEntity;
@synthesize context = _context;
@synthesize addCustomerEntity = _addCustomerEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加联系人信息";
    self.scroll.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self  action:nil];
    
    NSString *customerName= _context;
    
    if (customerName.length==0) {
        self.khmc.text=@"";
        NSLog(@"1111111111");
    }else{
        self.khmc.text=_context;
        NSLog(@",,,,,,,,,,,,,,,%@",customerName);
    }
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    
    [self.xsypj.layer setBorderColor:color];
    self.xsypj.layer.borderWidth = 1;
    self.xsypj.layer.cornerRadius = 6;
    self.xsypj.layer.masksToBounds = YES;
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
- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CustomercontactTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)cancleForAdd:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CustomercontactTableViewController class]])
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
- (IBAction)saveForAdd:(id)sender {
    NSString *customerName = _context;
    NSString *contactName =self.lxrenxm.text;
    NSString *telePhone =self.lxrendh.text;
    NSString *department=self.bumen.text;
    NSString *position=self.zhiwu.text;
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
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
            NSLog(@"--------%@",error);
        }else{

        NSDictionary *saveForAddDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"saveForAddDic字典里面的内容为--》%@", saveForAddDic);
        if ([[saveForAddDic objectForKey:@"success"] boolValue] == YES) {
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
        }
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
    _customerEntity = [[CostomerContactEntity alloc]init];
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
