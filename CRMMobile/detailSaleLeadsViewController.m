//
//  detailSaleLeadsViewController.m
//  CRMMobile
//
//  Created by zhang on 15/12/10.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "detailSaleLeadsViewController.h"
#import "saleLeads.h"
#import "SaleOppEntity.h"
#import "addSaleLeadsViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "saleLeadsTableViewController.h"
@interface detailSaleLeadsViewController ()

@property (strong, nonatomic) IBOutlet UITextView *saleLead;
@property (strong, nonatomic) IBOutlet UITextField *creatTime;
- (IBAction)edit:(id)sender;
- (IBAction)delete:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextField *leadsAdd;
@end

@implementation detailSaleLeadsViewController
//@synthesize saleOppEntity=_saleOppEntity;
@synthesize saleLeads = _saleLeads;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"销售线索详情";
    self.scroll.contentSize = CGSizeMake(375, 600);
    self.customerNameStr.text=_saleLeads.customerNameStr;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    [self.saleLead.layer setBorderColor:color];
    self.saleLead.layer.borderWidth = 1;
    self.saleLead.layer.cornerRadius = 6;
    self.saleLead.layer.masksToBounds = YES;
    self.saleLead.editable = NO;
    
    self.leadsAdd.text=_saleLeads.saleClueID;
    self.creatTime.text = _saleLeads.creatingTime;
    self.saleLead.text = _saleLeads.salesLeads;
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

- (IBAction)edit:(id)sender {
    [_saleLeads setIndex:@"editSaleLeads"];
    addSaleLeadsViewController *editSaleLeads = [[addSaleLeadsViewController alloc]init];
    [editSaleLeads setSaleLeads:self.saleLeads];
    [self.navigationController pushViewController:editSaleLeads animated:YES];
}

- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleClueAction!delete.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&saleClueID=%@",sid,_saleLeads.saleClueID];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *deleteInfo  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"deleteInfo字典里面的内容为--》%@", deleteInfo);
        if ([[deleteInfo objectForKey:@"success"] boolValue] == YES) {
            saleLeadsTableViewController *saleOppTable = [[saleLeadsTableViewController alloc]init];
            [self.navigationController pushViewController:saleOppTable animated:YES];
        }
    }
}
@end
