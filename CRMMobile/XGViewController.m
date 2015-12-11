//
//  XGViewController.m
//  CRMMobile
//
//  Created by why on 15/10/23.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "XGViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "config.h"

@interface XGViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUser;

@property (weak, nonatomic) IBOutlet UITextField *txtOPass;
@property (weak, nonatomic) IBOutlet UITextField *txtNPass;

- (IBAction)Summit:(id)sender;

@end

@implementation XGViewController
@synthesize mMeUser = _mMeUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改密码";
    NSString *uname = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
    self.txtUser.text=uname;
    [self.txtUser setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Summit:(id)sender {
    NSString *op = self.txtOPass.text;
    NSString *np = self.txtNPass.text;
    if ((op.length==0)&&(np.length==0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示通知" message:@"新密码和旧密码不能为空!" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];

    }else{
    NSLog(@"1111111111=======:%@",op);
    NSLog(@"2222222222=======:%@",np);
    if ([np isEqualToString:op]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示通知" message:@"新密码与原始密码不能一样！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        self.txtNPass.text=@"";
    }else{
//    NSDictionary *dic = [[NSDictionary alloc]init];
//    dic = APPDELEGATE.sessionInfo;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"muserAction!editUserInfo.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"oldPassword=%@&password=%@&MOBILE_SID=%@",op,np,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *editpassDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"editpassDic字典里面的内容为--》%@", editpassDic);
    if([[editpassDic objectForKey:@"success"] boolValue] == YES)
    {
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        myDelegate.sessionInfo = nil;
//        myDelegate.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        myDelegate.window.rootViewController = loginViewController;
        myDelegate.window.backgroundColor = [UIColor whiteColor];
        [myDelegate.window makeKeyAndVisible];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改失败" message:[editpassDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
    }
    }
    }
}
@end
