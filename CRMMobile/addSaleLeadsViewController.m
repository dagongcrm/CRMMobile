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

@interface addSaleLeadsViewController ()
//@property (weak, nonatomic) IBOutlet UITextField *saleLeads;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *customerName;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerChoose;
@property (weak, nonatomic) IBOutlet UITextField *leadsAdd;

@end

@implementation addSaleLeadsViewController
@synthesize saleLeads = _saleLeads;
@synthesize saleOppEntity=_saleOppEntity;
- (IBAction)customerSelect:(id)sender {
    _saleLeads=[[saleLeads alloc] init];
    [_saleLeads setCustomerNameStr:_customerName.text];
    [_saleLeads setSalesLeads:_leadsAdd.text];
    [_saleLeads setIndex:@"addSaleLeads"];
    CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [list setSaleLeads:_saleLeads];
    [self.navigationController pushViewController:list animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _customerName.text=_saleLeads.customerNameStr;
    _leadsAdd.text = _saleLeads.salesLeads;
    self.scroll.contentSize = CGSizeMake(375, 1000);
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
    //    self.tableView.delegate=self;
    //    self.tableView.dataSource=self;
    
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[saleLeadsTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {
    
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:@""];
    NSString *leadsAdd =_leadsAdd.text;
    NSString *customerName = _saleLeads.customerID;
    NSString *saleClubID = _saleLeads.saleClueID;
    NSString *creatingTime = _saleLeads.creatingTime;
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerID=%@&salesLeads=%@",sid,customerName,leadsAdd];
    if (_saleLeads.index == @"addSaleLeads") {
        URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleClueAction!add.action?"]];
    }else{
        URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleClueAction!edit.action?"]];
        param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerID=%@&salesLeads=%@&saleClueID=%@&creatingTime",sid,customerName,leadsAdd,saleClubID];
    }
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSLog(@"%@",_saleOppEntity.customerName);
    NSLog(@"saleOppEntity.saleLeadsAdd%@",_leadsAdd.text);
    
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        saleLeadsTableViewController *mj = [[saleLeadsTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    }
}

- (IBAction)cancel:(id)sender {
    [self ResView];
}
@end
