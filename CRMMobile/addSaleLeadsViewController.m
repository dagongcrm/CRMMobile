//
//  addSaleLeadsViewController.m
//  CRMMobile
//
//  Created by zhang on 15/12/3.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "addSaleLeadsViewController.h"
#import "UIImage+Tint.h"
#import "SaleOppEntity.h"
#import "CustomerContactListViewController.h"
#import "saleLeadsTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "MarketViewController.h"
#import "NullString.h"

@interface addSaleLeadsViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *customerName;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerChoose;
@property (strong, nonatomic) IBOutlet UITextView *leadsAdd;


@end

@implementation addSaleLeadsViewController
@synthesize saleLeads = _saleLeads;
@synthesize saleOppEntity=_saleOppEntity;

- (IBAction)customerSelect:(id)sender {
    [_saleLeads setCustomerNameStr:_customerName.text];
    [_saleLeads setSalesLeads:_leadsAdd.text];
    CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [list setSaleLeads:_saleLeads];
    [self.navigationController pushViewController:list animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"------%@",_saleLeads.index);
    if ([_saleLeads.index isEqualToString:@"editSaleLeads"]) {
        self.title=@"销售线索修改";
    }else{
        self.title=@"销售线索添加";
    }
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    
    [self.leadsAdd.layer setBorderColor:color];
    self.leadsAdd.layer.borderWidth = 1;
    self.leadsAdd.layer.cornerRadius = 6;
    self.leadsAdd.layer.masksToBounds = YES;
    _customerName.text=_saleLeads.customerNameStr;
    _leadsAdd.text = _saleLeads.salesLeads;
    self.scroll.contentSize = CGSizeMake(375, 1000);
    //设置导航栏返回
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//手机号码验证
- (IBAction)save:(id)sender {
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:@""];
    NSString *leadsAdd =_saleLeads.salesLeads;
    NSString *leadsAdd1 =self.leadsAdd.text;
    NSString *customerName = _saleLeads.customerID;
    NSString *saleClubID = _saleLeads.saleClueID;
    NSString *creatingTime = _saleLeads.creatingTime;
    NSString *customerNameStr = _saleLeads.customerNameStr;
    NSString *userID = _saleLeads.userID;
    NSLog(@"leadsAddleadsAddleadsAdd%@",leadsAdd);
    NSLog(@"leadsAdd1leadsAdd1leadsAdd1%@",leadsAdd1);

    NSString *param=@"";
    
    
    if ([_saleLeads.index isEqualToString:@"addSaleLeads"]) {
        if ([NullString isBlankString:customerNameStr]) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"温馨提示" message:@"客户名称不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                        [alertView show];
        }else{
        URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleClueAction!add.action?"]];
        param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerID=%@&customerNameStr=%@&salesLeads=%@",sid,customerName,customerNameStr,leadsAdd1];
        }
    }else{
        if ([NullString isBlankString:customerNameStr]) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"温馨提示" message:@"客户名称不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alertView show];
        }else{
        URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleClueAction!edit.action?"]];
        param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerID=%@&customerNameStr=%@&salesLeads=%@&saleClueID=%@&creatingTime=%@&userID=%@",sid,customerName,customerNameStr,leadsAdd1,saleClubID,creatingTime,userID];
        }
    }
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]  animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    }
}

- (IBAction)cancel:(id)sender {
    if ([_saleLeads.index isEqualToString:@"addSaleLeads"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([_saleLeads.index isEqualToString:@"editSaleLeads"]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
    }
}
@end
