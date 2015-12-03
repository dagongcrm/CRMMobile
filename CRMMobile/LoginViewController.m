#import "LoginViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "HttpHelper.h"
#import "GLReusableViewController.h"
@interface LoginViewController ()
@end


@implementation LoginViewController
@synthesize accountField;
@synthesize passwdField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];  
    accountField.placeholder    = @"用户名";
    passwdField.placeholder     = @"密码";
    passwdField.secureTextEntry = YES;
    [self loadValue];    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


-(void)loadValue{
    NSUserDefaults *ud1 = [NSUserDefaults standardUserDefaults];
    if([ud1 objectForKey:@"userName"]!=nil){
        accountField.text = [ud1 objectForKey:@"userName"];
        passwdField.text = [ud1 objectForKey:@"password"];
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
    if([[loginDic objectForKey:@"success"] boolValue] == YES)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:accountField.text forKey:@"userName"];
        [ud setObject:passwdField.text forKey:@"password"];
        [ud synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"登录失败！用户名或密码错误！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
    }
    
}



@end
