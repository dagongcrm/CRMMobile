#import "LoginViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "HttpHelper.h"
#import "GLReusableViewController.h"
@interface LoginViewController ()
@property (strong,nonatomic) NSMutableArray *authorityList;
@property (weak, nonatomic) IBOutlet UIImageView *loginImg;

@end


@implementation LoginViewController
@synthesize accountField;
@synthesize passwdField;


- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    }

- (IBAction)loginBtnClicked:(id)sender {
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"muserAction!login.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"loginName=%@&password=%@",accountField.text,passwdField.text];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *loginDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.sessionInfo  = loginDic;
    NSLog(@"%@",loginDic);
    if([[loginDic objectForKey:@"success"] boolValue] == YES)
    {
        myDelegate.roleAuthority=[self authorityDic];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:accountField.text forKey:@"userName"];
        [ud setObject:passwdField.text  forKey:@"password"];
        [ud synchronize];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"登录失败！用户名或密码错误！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
    }
}

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
        [roleauthcom setValue:[self setroleauthority:@"kehudangan"  rolearrayforadd:rolearray] forKey:@"kehudangan"];
        [roleauthcom setValue:[self setroleauthority:@"role"  rolearrayforadd:rolearray] forKey:@"role"];
        [roleauthcom setValue:[self setroleauthority:@"kehulianxiren"  rolearrayforadd:rolearray] forKey:@"kehulianxiren"];
        [roleauthcom setValue:[self setroleauthority:@"baifangjilu"  rolearrayforadd:rolearray] forKey:@"baifangjilu"];
        [roleauthcom setValue:[self setroleauthority:@"xiaoshoujihui"  rolearrayforadd:rolearray] forKey:@"xiaoshoujihui"];
        [roleauthcom setValue:[self setroleauthority:@"xiaoshouxiansuo"  rolearrayforadd:rolearray] forKey:@"xiaoshouxiansuo"];
        [roleauthcom setValue:[self setroleauthority:@"baifangjihua"  rolearrayforadd:rolearray] forKey:@"baifangjihua"];
        [roleauthcom setValue:[self setroleauthority:@"huodongtongji"  rolearrayforadd:rolearray] forKey:@"huodongtongji"];
        [roleauthcom setValue:[self setroleauthority:@"gongzuobaogao"  rolearrayforadd:rolearray] forKey:@"gongzuobaogao"];
        [roleauthcom setValue:[self setroleauthority:@"renwutijiao"  rolearrayforadd:rolearray] forKey:@"renwutijiao"];
        [roleauthcom setValue:[self setroleauthority:@"renwushenhe"  rolearrayforadd:rolearray] forKey:@"renwushenhe"];
        [roleauthcom setValue:[self setroleauthority:@"renwugenzong"  rolearrayforadd:rolearray] forKey:@"renwugenzong"];
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
