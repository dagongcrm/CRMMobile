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
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UITextField *customerNameStr;
@property (strong, nonatomic) IBOutlet UITextField *saleOppSrc;
@property (strong, nonatomic) IBOutlet UITextField *successProbability;

@property (strong, nonatomic) IBOutlet UITextView *saleOppDescription;

@property (strong, nonatomic) IBOutlet UITextField *oppState;
@property (strong, nonatomic) IBOutlet UITextField *contact;
@property (strong, nonatomic) IBOutlet UITextField *contactTel;
- (IBAction)delete:(id)sender;
- (IBAction)edit:(id)sender;



@end

@implementation DetailSaleOppViewController
@synthesize saleOppEntity=_saleOppEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"销售机会详情";
    self.scroll.contentSize = CGSizeMake(375, 680);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    
    
    [self.saleOppDescription.layer setBorderColor:color];
    self.saleOppDescription.layer.borderWidth = 1;
    self.saleOppDescription.layer.cornerRadius = 6;
    self.saleOppDescription.layer.masksToBounds = YES;
//    self.theme.editable = NO;
    self.customerNameStr.text=_saleOppEntity.customerNameStr;
    self.saleOppSrc.text=_saleOppEntity.saleOppSrcStr;
    self.successProbability.text=_saleOppEntity.successProbability;
    self.saleOppDescription.text=_saleOppEntity.saleOppDescription;
    self.oppState.text=_saleOppEntity.oppStateStr;
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
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
            NSLog(@"--------%@",error);
        }else{
        NSDictionary *deleteInfo  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"deleteInfo字典里面的内容为--》%@", deleteInfo);
        if ([[deleteInfo objectForKey:@"success"] boolValue] == YES) {
            SaleOppTableViewController *saleOppTable = [[SaleOppTableViewController alloc]init];
            [self.navigationController pushViewController:saleOppTable animated:YES];
        }
        }
    }
}
- (IBAction)edit:(id)sender {
    EditSaleOppViewController *editSaleOpp = [[EditSaleOppViewController alloc]init];
    [editSaleOpp setSaleOppEntity:self.saleOppEntity];
    [self.navigationController pushViewController:editSaleOpp animated:YES];
}
@end
