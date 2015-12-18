
#import "TaskRecordsTableViewController.h"
#import "RecordsDetalViewController.h"
#import "config.h"
#import "AppDelegate.h"
@interface RecordsDetalViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextField *visitDate;

@property (weak, nonatomic) IBOutlet UITextField *accessMethodStr;
@property (weak, nonatomic) IBOutlet UITextView *theme;

@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;
@property (weak, nonatomic) IBOutlet UITextView *mainContent;
@property (strong, nonatomic) IBOutlet UITextView *customerChange;


@property (weak, nonatomic) IBOutlet UITextField *respondent;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextView *visitProfile;
@property (strong, nonatomic) IBOutlet UITextView *result;
@property (strong, nonatomic) IBOutlet UITextView *customerRequirements;

@property (weak, nonatomic) IBOutlet UITextField *visitorAttributionStr;
@property (weak, nonatomic) IBOutlet UITextField *visitor;

- (IBAction)del:(id)sender;
@property (strong,nonatomic)NSMutableArray *listData;
@end

@implementation RecordsDetalViewController
@synthesize DailyEntity=_dailyEntity;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"拜访记录详情";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.scroll.contentSize = CGSizeMake(375, 1280);
    self.listData = [[NSMutableArray alloc]init];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    

    [self.theme.layer setBorderColor:color];
    self.theme.layer.borderWidth = 1;
    self.theme.layer.cornerRadius = 6;
    self.theme.layer.masksToBounds = YES;
    self.theme.editable = NO;
    
    [self.customerChange.layer setBorderColor:color];
    self.customerChange.layer.borderWidth = 1;
    self.customerChange.layer.cornerRadius = 6;
    self.customerChange.layer.masksToBounds = YES;
    self.customerChange.editable = NO;
    
    [self.visitProfile.layer setBorderColor:color];
    self.visitProfile.layer.borderWidth = 1;
    self.visitProfile.layer.cornerRadius = 6;
    self.visitProfile.layer.masksToBounds = YES;
    self.visitProfile.editable = NO;
    
    [self.result.layer setBorderColor:color];
    self.result.layer.borderWidth = 1;
    self.result.layer.cornerRadius = 6;
    self.result.layer.masksToBounds = YES;
    self.result.editable = NO;
    
    [self.customerRequirements.layer setBorderColor:color];
    self.customerRequirements.layer.borderWidth = 1;
    self.customerRequirements.layer.cornerRadius = 6;
    self.customerRequirements.layer.masksToBounds = YES;
    self.customerRequirements.editable = NO;
    
    [self.mainContent.layer setBorderColor:color];
    self.mainContent.layer.borderWidth = 1;
    self.mainContent.layer.cornerRadius = 6;
    self.mainContent.layer.masksToBounds = YES;
    self.mainContent.editable = NO;
    self.customerNameStr.text =_dailyEntity.customerNameStr;
    self.visitDate.text =_dailyEntity.visitDate;
    self.theme.text =_dailyEntity.theme;
    self.accessMethodStr.text =_dailyEntity.accessMethodStr;
    self.mainContent.text =_dailyEntity.mainContent;
    self.respondentPhone.text =_dailyEntity.respondentPhone;
    self.respondent.text =_dailyEntity.respondent;
    self.address.text =_dailyEntity.address;
    self.visitProfile.text =_dailyEntity.visitProfile;
    self.result.text =_dailyEntity.result;
    self.customerRequirements.text =_dailyEntity.customerRequirements;
    self.customerChange.text =_dailyEntity.customerChange;
    self.visitorAttributionStr.text =_dailyEntity.visitorAttributionStr;
    self.visitor.text =_dailyEntity.visitorStr;
    [self.customerNameStr setEnabled:NO];
    [self.visitDate setEnabled:NO];
//    [self.theme setEnabled:NO];
    [self.visitorAttributionStr setEnabled:NO];
    [self.visitor setEnabled:NO];
    [self.accessMethodStr setEnabled:NO];
//    [self.mainContent setEnabled:NO];
    [self.respondentPhone setEnabled:NO];
    [self.respondent setEnabled:NO];
    [self.address setEnabled:NO];
    NSString *callRecordsID =_dailyEntity.callRecordsID;
    [self.listData addObject:callRecordsID];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (IBAction)del:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSError *error;
        NSString *callRecordsID = _dailyEntity.callRecordsID;
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallRecordsAction!delete.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"callRecordsID=%@&MOBILE_SID=%@",callRecordsID,sid];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        if ([[dailyDic objectForKey:@"success"] boolValue] == YES) {
            TaskRecordsTableViewController *dailytv = [[TaskRecordsTableViewController alloc]init];
            [self.navigationController pushViewController:dailytv animated:YES];
        }
    }
}
@end

