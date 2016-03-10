#import "LoginViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "HttpHelper.h"
#import "GLReusableViewController.h"
#import "MBProgressHUD+NJ.h"
//定位所需要的包
#import "OMGToast.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#define APIKey @"cdf41cce83fb64756ba13022997e5e74"//APIKey

@interface LoginViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    long long expectedLength;
    long long currentLength;
}

@property (strong,nonatomic) NSMutableArray *authorityList;
@property (weak, nonatomic) IBOutlet UIImageView *loginImg;

@end


@implementation LoginViewController
@synthesize locationManager=_locationManager;
@synthesize accountField;
@synthesize passwdField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
//     [self.loginImg setImage:[UIImage imageNamed:@"login6p"]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    accountField.placeholder    = @"用户名";
    passwdField.placeholder     = @"密码";
    passwdField.secureTextEntry = YES;
    [self loadValue];
    //可以判断进来的设备的型号
    CGSize iosDeviceScreenSize = [UIScreen mainScreen].bounds.size;
    NSLog(@"%f x %f",iosDeviceScreenSize.width,iosDeviceScreenSize.height);
    NSLog(@"jjjdjdjdjdjdjdjjdjd");
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        if (iosDeviceScreenSize.height==568) {
            //IPHONE5/5s/5c
            NSLog(@"IPHONE5/5s/5c");
            APPDELEGATE.deviceCode = @"5";
        }else if(iosDeviceScreenSize.height==667){
            //iphone6
            NSLog(@"iphone 6");
            APPDELEGATE.deviceCode = @"6";
        }else if(iosDeviceScreenSize.height==736){
            //iphone6plus
            NSLog(@"iphone6plus");
             APPDELEGATE.deviceCode = @"6p";
            
        }else{
            //iphone 4等其他设备
            NSLog(@"iphone 4等其他设备");
             APPDELEGATE.deviceCode = @"4";
        }
    }
    //进行定位
   [self locationInit];
}

-(void)dismissKeyboard {
    [passwdField resignFirstResponder];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)loadValue{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:@"userName"]!=nil){
        accountField.text = [ud objectForKey:@"userName"];
        passwdField.text =  [ud objectForKey:@"password"];
    }
}


//登录按钮事件
- (IBAction)loginBtnClicked:(id)sender {
    [MBProgressHUD showMessage:@"加载中，请稍后" toView:self.view];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"muserAction!login.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=20.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"loginName=%@&password=%@",accountField.text,passwdField.text];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(!error){
        NSDictionary *loginDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        APPDELEGATE.sessionInfo = loginDic;		
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if([[ud objectForKey:@"userName"] isEqualToString:accountField.text])
        {
         APPDELEGATE.userChangeOrNot=@"nochange";
        }else{
         APPDELEGATE.userChangeOrNot=@"change";
        }
        if([[loginDic objectForKey:@"success"] boolValue] == YES)
        {
            APPDELEGATE.roleAuthority=[self authorityDic];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:accountField.text forKey:@"userName"];
            [ud setObject:passwdField.text  forKey:@"password"];
            [ud synchronize];
            [self Location];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"登录失败！用户名或密码错误！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登陆超时" message:@"登陆超时请重新登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
    }
}
//定位功能初始化
-(void) locationInit{
    NSLog(@"地图初始化了");
    [AMapLocationServices sharedServices].apiKey = APIKey;
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate=self;
    
   }

//定位功能
-(void)Location{
    
    //设置允许后台定位参数，保持不会被系统挂起
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
    //开始持续定位
    //设置定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=10.0;//十米定位一次
//    _locationManager.distanceFilter=distance;
    [self.locationManager setDistanceFilter:distance];
    //启动跟踪定位
    [self.locationManager startUpdatingLocation];
   }

//将NSDate 转换成 NSString(定位)
- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    //业务处理
        NSError *error;
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
        NSString *userId = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"userId"];
       // NSLog(@"location:%@", location);
        CGFloat longitude=location.coordinate.longitude;
        CGFloat latitude=location.coordinate.latitude;
        NSString *time=[self dateToString:location.timestamp];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"locationAction!add.action?"]];
    
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"longitude=%f&latitude=%f&userID=%@&time=%@&MOBILE_SID=%@",longitude,latitude,userId,time,sid];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
            NSLog(@"--------%@",error);
        }else{
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
                [OMGToast showWithText:@"定位成功" bottomOffset:20 duration:0.5];
            }else{
                [OMGToast showWithText:@"定位数据发送失败" bottomOffset:20 duration:0.5];
            }
        }
}

//在回调函数中，获取定位坐标，进行业务处理。
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
//{
//      NSLog(@"定位失败");
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//    //业务处理
//    NSError *error;
//    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
//    NSString *userId = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"userId"];
//    NSLog(@"location:%@", location);
//    CGFloat longitude=location.coordinate.longitude;
//    CGFloat latitude=location.coordinate.latitude;
//    NSString *time=[self dateToString:location.timestamp];
//    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"locationAction!add.action?"]];
//    
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval=10.0;
//    request.HTTPMethod=@"POST";
//    NSString *param=[NSString stringWithFormat:@"longitude=%f&latitude=%f&userID=%@&time=%@&MOBILE_SID=%@",longitude,latitude,userId,time,sid];
//    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
//        [alert show];
//        NSLog(@"--------%@",error);
//    }else{
//        
//        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        
//        if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
//            [OMGToast showWithText:@"定位成功" bottomOffset:20 duration:0.5];
//        }else{
//            [OMGToast showWithText:@"定位数据发送失败" bottomOffset:20 duration:0.5];
//        }
//    }
//}
//权限判断
-(NSDictionary *)authorityDic{
    NSString *authorityPath = [[NSBundle mainBundle]pathForResource:@"AuthorityDictionary.plist" ofType:nil];
    self.authorityList= [NSMutableArray arrayWithContentsOfFile:authorityPath];
    NSString *role =[[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"roleIds"];
    __block NSDictionary *auths = [[NSDictionary alloc] init];
    if(![role rangeOfString:@","].length>0){
    [self.authorityList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"role"] isEqualToString:role]) {
            auths=[self.authorityList objectAtIndex:idx];
            *stop =YES;
        }
    }];}
    else{
        NSArray *rolearray = [role componentsSeparatedByString:@","];
        NSMutableDictionary  *roleauthcom=[[NSMutableDictionary  alloc] init];
        [roleauthcom setValue:[self setroleauthority:@"kehudangan"      rolearrayforadd:rolearray] forKey:@"kehudangan"];
        [roleauthcom setValue:[self setroleauthority:@"role"            rolearrayforadd:rolearray] forKey:@"role"];
        [roleauthcom setValue:[self setroleauthority:@"kehulianxiren"   rolearrayforadd:rolearray] forKey:@"kehulianxiren"];
        [roleauthcom setValue:[self setroleauthority:@"baifangjilu"     rolearrayforadd:rolearray] forKey:@"baifangjilu"];
        [roleauthcom setValue:[self setroleauthority:@"xiaoshoujihui"   rolearrayforadd:rolearray] forKey:@"xiaoshoujihui"];
        [roleauthcom setValue:[self setroleauthority:@"xiaoshouxiansuo" rolearrayforadd:rolearray] forKey:@"xiaoshouxiansuo"];
        [roleauthcom setValue:[self setroleauthority:@"baifangjihua"    rolearrayforadd:rolearray] forKey:@"baifangjihua"];
        [roleauthcom setValue:[self setroleauthority:@"huodongtongji"   rolearrayforadd:rolearray] forKey:@"huodongtongji"];
        [roleauthcom setValue:[self setroleauthority:@"gongzuobaogao"   rolearrayforadd:rolearray] forKey:@"gongzuobaogao"];
        [roleauthcom setValue:[self setroleauthority:@"renwutijiao"     rolearrayforadd:rolearray] forKey:@"renwutijiao"];
        [roleauthcom setValue:[self setroleauthority:@"renwushenhe"     rolearrayforadd:rolearray] forKey:@"renwushenhe"];
        [roleauthcom setValue:[self setroleauthority:@"renwugenzong"    rolearrayforadd:rolearray] forKey:@"renwugenzong"];
        auths=roleauthcom;
    }
    return  auths;
}


-(NSString *) setroleauthority:(NSString *)authname  rolearrayforadd:(NSArray *)rolearraytoadd
{
    NSMutableArray *multiRoleArray=[[NSMutableArray alloc] init];
    for(int i =0;i<[rolearraytoadd count];i++){
    [self.authorityList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([[obj objectForKey:@"role"] isEqualToString:[rolearraytoadd objectAtIndex:i]]) {
                               [multiRoleArray addObject:[[self.authorityList objectAtIndex:idx] objectForKey:authname]];
                                *stop =YES;
                    }
                    }];
    }
    NSString *authcom=@"";
    for (NSString *str in multiRoleArray)
        {
        authcom = [authcom stringByAppendingFormat:@"%@",str];
        }
    return authcom;
}

@end
