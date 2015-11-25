//
//  DetailSaleOppViewController.m
//  CRMMobile
//
//  Created by jam on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
////customerName  customerNameStr saleOppSrc successProbability saleOppDescription oppState contact contactTel

#import "DetailSaleOppViewController.h"
#import "EditSaleOppViewController.h"
#import "SaleOppTableViewController.h"
#import "config.h"
#import "AppDelegate.h"

@interface DetailSaleOppViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextField *saleOppSrc;
@property (weak, nonatomic) IBOutlet UITextField *successProbability;
@property (weak, nonatomic) IBOutlet UITextField *saleOppDescription;
@property (weak, nonatomic) IBOutlet UITextField *oppState;
@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextField *contactTel;
- (IBAction)delete:(id)sender;
- (IBAction)edit:(id)sender;

@end

@implementation DetailSaleOppViewController
@synthesize saleOppEntity=_saleOppEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"销售机会详情";
    self.scroll.contentSize = CGSizeMake(375, 600);
    self.customerNameStr.text=_saleOppEntity.customerNameStr;
    self.saleOppSrc.text=_saleOppEntity.saleOppSrc;
    self.successProbability.text=_saleOppEntity.successProbability;
    self.saleOppDescription.text=_saleOppEntity.saleOppDescription;
    self.oppState.text=_saleOppEntity.oppState;
    self.contact.text=_saleOppEntity.contact;
    self.contactTel.text=_saleOppEntity.contactTel;
}


- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleOpportunityAction!delete.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&ids=%@",sid,_saleOppEntity.saleOppID];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *deleteInfo  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"deleteInfo字典里面的内容为--》%@", deleteInfo);
        if ([[deleteInfo objectForKey:@"success"] boolValue] == YES) {
            SaleOppTableViewController *saleOppTable = [[SaleOppTableViewController alloc]init];
            [self.navigationController pushViewController:saleOppTable animated:YES];
        }
    }
}
- (IBAction)edit:(id)sender {
    EditSaleOppViewController *editSaleOpp = [[EditSaleOppViewController alloc]init];
    [editSaleOpp setSaleOppEntity:self.saleOppEntity];
    [self.navigationController pushViewController:editSaleOpp animated:YES];
}
@end
