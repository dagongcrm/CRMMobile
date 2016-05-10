#import "LoginViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "HttpHelper.h"
#import "GLReusableViewController.h"
#import "MBProgressHUD+NJ.h"
#import "getLocationUtil.h"
#import "DateUtil.h"
#import "PhoneParameterUtil.h"
#import "OMGToast.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapLocationKit/AMapLocationRegionObj.h>
#define APIKey @"cdf41cce83fb64756ba13022997e5e74"

@interface LoginViewController () <MBProgressHUDDelegate,AMapLocationManagerDelegate> {
    MBProgressHUD *HUD;
    long long expectedLength;
    long long currentLength;
    BOOL blog;
    float acc;
}
@property (strong,nonatomic) NSMutableArray *authorityList;
@property (weak,  nonatomic) IBOutlet UIImageView *loginImg;
@property (strong,nonatomic) NSMutableArray *regions;
@end

@implementation LoginViewController

#pragma mark -lifeCycle
- (void)viewDidLoad
{
    blog = YES;
    [super viewDidLoad];
    [self setupUI];
    [self loadValue];
    [self setDeviceCode];
    [self locationInit];
}

-(void) setDeviceCode{
    NSString *deviceCode=[PhoneParameterUtil getPhoneModel];
    APPDELEGATE.deviceCode=deviceCode;
}

-(void) setupUI{
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    //  [self.loginImg setImage:[UIImage imageNamed:@"login6p"]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.accountField.placeholder    = @"用户名";
    self.passwdField.placeholder     = @"密码";
    self.passwdField.secureTextEntry = YES;
}

-(void)dismissKeyboard {
    [self.passwdField resignFirstResponder];
}

- (void)loadValue{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:@"userName"]!=nil){
        self.accountField.text = [ud objectForKey:@"userName"];
        self.passwdField.text =  [ud objectForKey:@"password"];
    }
}

- (IBAction)loginBtnClicked:(id)sender {
    [MBProgressHUD showMessage:@"加载中，请稍后" toView:self.view];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"muserAction!login.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=5.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"loginName=%@&password=%@",self.accountField.text,self.passwdField.text];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(!error){
        NSDictionary *loginDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        APPDELEGATE.sessionInfo = loginDic;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if([[ud objectForKey:@"userName"] isEqualToString:self.accountField.text])
        {
         APPDELEGATE.userChangeOrNot=@"nochange";
        }else{
         APPDELEGATE.userChangeOrNot=@"change";
        }
        if([[loginDic objectForKey:@"success"] boolValue] == YES)
        {
//            APPDELEGATE.roleAuthority=[self authorityDic];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:self.accountField.text forKey:@"userName"];
            [ud setObject:self.passwdField.text  forKey:@"password"];
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
    //设置一个目标经纬度
    CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(39.964818, 116.472973);
      __weak typeof(self) weakSelf = self;
    [weakSelf addCircleReionForCoordinate:coodinate];
   }

//定位功能
-(void)Location{
    //给精度赋值
    acc=[getLocationUtil getPositionAcc];
    //设置允许后台定位参数，保持不会被系统挂起
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
    //开始持续定位
    //设置定位精度
   [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=acc;//十米定位一次
     NSLog(@"abababababba-----%f",acc);
    //    _locationManager.distanceFilter=distance;
    [self.locationManager setDistanceFilter:distance];
    //启动跟踪定位
    [self.locationManager startUpdatingLocation];
     [OMGToast showWithText:@"开始定位" bottomOffset:20 duration:2];
   }

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (location.horizontalAccuracy < 200 && location.horizontalAccuracy != -1){
        if(blog==YES){
//            [self chuanzhi:location];
            [getLocationUtil chuanzhi:location];//往后台传值
        }else{
            NSLog(@"在公司区域");
        }
    } else {
        [self.locationManager stopUpdatingLocation];	 //停止获取
        [NSThread sleepForTimeInterval:10]; //阻塞10秒
        [self.locationManager startUpdatingLocation];	//重新获取
    }
    
}

//地理围栏
- (void)addCircleReionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapLocationCircleRegion *cirRegion200 = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate
                                                                                       radius:200.0
                                                                                   identifier:@"circleRegion200"];
    
    AMapLocationCircleRegion *cirRegion300 = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate
                                                                                       radius:300.0
                                                                                   identifier:@"circleRegion300"];
    
    //添加地理围栏
    [self.locationManager startMonitoringForRegion:cirRegion200];
    [self.locationManager startMonitoringForRegion:cirRegion300];
    
    //保存地理围栏
    [self.regions addObject:cirRegion200];
    [self.regions addObject:cirRegion300];
    
    //添加Overlay
    MACircle *circle200 = [MACircle circleWithCenterCoordinate:coordinate radius:200.0];
    MACircle *circle300 = [MACircle circleWithCenterCoordinate:coordinate radius:300.0];
    [self.mapView addOverlay:circle200];
    [self.mapView addOverlay:circle300];
    
    [self.mapView setVisibleMapRect:circle300.boundingMapRect];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region
{
    NSLog(@"进入公司区域:%@", region);
    blog = NO;
    [OMGToast showWithText:@"进入公司区域" bottomOffset:20 duration:0.5];
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region
{
    NSLog(@"走出公司区域:%@", region);
    blog = YES;
    [OMGToast showWithText:@"走出公司区域" bottomOffset:20 duration:0.5];
}

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
