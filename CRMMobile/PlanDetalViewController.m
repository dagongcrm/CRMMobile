
#import "EditPlanViewController.h"
#import "PlanDetalViewController.h"
#import "VisitPlanTableViewController.h"
#import "OMGToast.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#define APIKey @"cdf41cce83fb64756ba13022997e5e74"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#import "config.h"
#import "AppDelegate.h"

@interface PlanDetalViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextView *theme;
@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;
@property (weak, nonatomic) IBOutlet UITextField *respondent;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (strong, nonatomic) IBOutlet UITextView *result;

@property (strong, nonatomic) IBOutlet UITextView *visitProfile;
@property (weak, nonatomic) IBOutlet UITextField *visitDate;
@property (strong, nonatomic) IBOutlet UITextView *customerRequirements;
@property (strong, nonatomic) IBOutlet UITextView *customerChange;

@property (weak, nonatomic) IBOutlet UITextField *visitorAttributionStr;
@property (strong, nonatomic) IBOutlet UITextField *accessmethod;


@property (weak, nonatomic) IBOutlet UITextView *mainContent;

@property (weak, nonatomic) IBOutlet UITextField *visitorStr;

- (IBAction)edit:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)addCallRecords:(id)sender;

@property (strong,nonatomic)NSMutableArray *listData;

@end

@implementation PlanDetalViewController
@synthesize customerCallPlanEntity=_customerCallPlanEntity;
@synthesize DailyEntity=_dailyEntity;
@synthesize locationManager=_locationManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"拜访计划详情";
    //调节scroll宽度和高度
    self.scroll.contentSize=CGSizeMake(SCREENWIDTH, SCREENHEIGHT*2.5);
    
    //赋值
    [self valuation];
    //GPS
    [self locationInit];
    
    
}


//赋值
- (void) valuation {
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    
    
    [self.theme.layer setBorderColor:color];
    self.theme.layer.borderWidth = 1;
    self.theme.layer.cornerRadius = 6;
    self.theme.layer.masksToBounds = YES;
    self.theme.editable = NO;
    
    [self.mainContent.layer setBorderColor:color];
    self.mainContent.layer.borderWidth = 1;
    self.mainContent.layer.cornerRadius = 6;
    self.mainContent.layer.masksToBounds = YES;
    self.mainContent.editable = NO;
    
    [self.address.layer setBorderColor:color];
    self.address.layer.borderWidth = 1;
    self.address.layer.cornerRadius = 6;
    self.address.layer.masksToBounds = YES;
    self.address.editable = NO;
    
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
    self.customerNameStr.text  =_customerCallPlanEntity.customerNameStr;
    _visitDate.text=_customerCallPlanEntity.visitDate;
    _theme.text=_customerCallPlanEntity.theme;
    _accessmethod.text=_customerCallPlanEntity.accessMethodStr;
    _respondentPhone.text=_customerCallPlanEntity.respondentPhone;
    _respondent.text=_customerCallPlanEntity.respondent;
    _address.text=_customerCallPlanEntity.address;
    _visitProfile.text=_customerCallPlanEntity.visitProfile;
    _result.text=_customerCallPlanEntity.result;
    _customerRequirements.text=_customerCallPlanEntity.customerRequirements;
    _customerChange.text=_customerCallPlanEntity.customerChange;
    _visitorAttributionStr.text=_customerCallPlanEntity.visitorAttributionStr;
    _visitorStr.text=_customerCallPlanEntity.baiFangRenStr;
    _mainContent.text=_customerCallPlanEntity.mainContent;
    
    [self.customerNameStr setEnabled:NO];
    [self.visitDate setEnabled:NO];
  
//    [self.customerChange setEnabled:NO];
    [self.visitorStr setEnabled:NO];
    [self.accessmethod setEnabled:NO];

    [self.respondentPhone setEnabled:NO];
    [self.respondent setEnabled:NO];

    [self.visitorAttributionStr setEnabled:NO];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)edit:(id)sender {
    EditPlanViewController *uc1 =[[EditPlanViewController alloc] init];
    [uc1 setCustomerCallPlanEntity:_customerCallPlanEntity];
    [self.navigationController pushViewController:uc1 animated:YES];
}

- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag=1;
    [alertView show];
}

- (IBAction)addCallRecords:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否 确认拜访？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"确认", nil];
    alertView.tag=2;
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)alertView.tag);
    if(alertView.tag==1){
        if (buttonIndex==1) {
            NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
            NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!delete.action?"]];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
            request.timeoutInterval=10.0;
            request.HTTPMethod=@"POST";
            NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&ids=%@",sid,_customerCallPlanEntity.customerCallPlanID];
            request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSDictionary *deleteInfo  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            //NSLog(@"deleteInfo字典里面的内容为--》%@", deleteInfo);
            if ([[deleteInfo objectForKey:@"success"] boolValue] == YES) {
                VisitPlanTableViewController *contant = [[VisitPlanTableViewController alloc]init];
                [self.navigationController pushViewController:contant animated:YES];
            }
        }
    }else if (alertView.tag==2){
        if (buttonIndex==1) {
            //调用定位方法
            [self Location:_customerCallPlanEntity.customerID];
            
            NSString *ci= _customerCallPlanEntity.customerCallPlanID;
            NSError *error;
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
            NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!addCallRecords.action?"]];
            
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
            request.timeoutInterval=10.0;
            request.HTTPMethod=@"POST";
            NSString *param=[NSString stringWithFormat:@"customerCallPlanID=%@&MOBILE_SID=%@",ci,sid];
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
                VisitPlanTableViewController *mj = [[VisitPlanTableViewController alloc] init];
                [self.navigationController pushViewController:mj animated:YES];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            }
        }
    }
}




-(void) updateLocation:(NSString *) customerID:(CLLocation *)location:(NSError *)error{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败，请检查您的GPS设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        VisitPlanTableViewController *mj = [[VisitPlanTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:NO];
        [alert show];
    }else{
        NSError *error;
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
        NSString *userId = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"userId"];
        NSLog(@"location:%@", location);
        CGFloat longitude=location.coordinate.longitude;
        CGFloat latitude=location.coordinate.latitude;
        NSString *time=[self dateToString:location.timestamp];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"locationAction!add.action?"]];
        
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"longitude=%f&latitude=%f&userID=%@&time=%@&customerID=%@&MOBILE_SID=%@",longitude,latitude,userId,time,customerID,sid];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
            [OMGToast showWithText:@"定位成功" bottomOffset:20 duration:0.5];
        }else{
            [OMGToast showWithText:@"定位数据发送失败" bottomOffset:20 duration:0.5];
        }
    }
}

//将NSDate 转换成 NSString(定位)
- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//定位功能初始化
-(void) locationInit{
    [AMapLocationServices sharedServices].apiKey = APIKey;
    self.locationManager = [[AMapLocationManager alloc] init];
}

//定位功能
-(void)Location:(NSString *) customerID{
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        NSLog(@"location:%@", location);
        [self updateLocation:customerID:location:error];
    }];
}


@end
