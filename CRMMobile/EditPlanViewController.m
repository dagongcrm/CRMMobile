//
//  EditPlanViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

//#import "contactEntity.h"
#import "PlanDetalViewController.h"
#import "CustomerContactListViewController.h"
#import "VisitPlanTableViewController.h"
#import "EditPlanViewController.h"
#import "AppDelegate.h"
#import "config.h"
@interface EditPlanViewController ()
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
@property (nonatomic, retain) NSIndexPath       *selectedIndexPath;
- (IBAction)save:(id)sender;
- (IBAction)customerName:(id)sender;
- (IBAction)goback:(id)sender;



@property (strong,nonatomic)NSMutableArray *listData;
@end

@implementation EditPlanViewController
@synthesize contactEntity = _contactEntity;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize DailyEntity=_dailyEntity;
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
    self.customerNameStr.text =_dailyEntity.customerNameStr;
    self.visitDate.text =_dailyEntity.visitDate;
    self.theme.text =_dailyEntity.theme;
    self.accessMethod.text =_dailyEntity.accessMethod;
    self.mainContent.text =_dailyEntity.mainContent;
    self.respondentPhone.text =_dailyEntity.respondentPhone;
    self.respondent.text =_dailyEntity.respondent;
    self.address.text =_dailyEntity.address;
    self.visitProfile.text =_dailyEntity.visitProfile;
    self.result.text =_dailyEntity.result;
    self.customerRequirements.text =_dailyEntity.customerRequirements;
    self.customerChange.text =_dailyEntity.customerChange;
    self.visitorStr.text =_dailyEntity.visitorStr;
    
//    NSString *customerCallPlanIDs =_dailyEntity.customerCallPlanID;
//    [self.listData addObject:customerCallPlanIDs];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
        NSString *customerCallPlanID =_dailyEntity.customerCallPlanID;
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

- (IBAction)customerName:(id)sender {
    CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [_contactEntity setIndex:@"1"];
    [list setCustomerEntity:_contactEntity];
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)goback:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[PlanDetalViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

@end


