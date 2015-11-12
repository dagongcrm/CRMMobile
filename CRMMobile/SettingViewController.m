//
//  SettingViewController.m
//  CRMMobile
//设置页面
//  Created by why on 15/10/25.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "SettingViewController.h"
#import "LianViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UploadViewController.h"
@interface SettingViewController ()
- (IBAction)Output:(id)sender;//退出登录
- (IBAction)lianxi:(id)sender;//联系我们
- (IBAction)upload:(id)sender;//上传文件

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Output:(id)sender {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.sessionInfo = nil;
//    myDelegate.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    myDelegate.window.rootViewController = loginViewController;
    myDelegate.window.backgroundColor = [UIColor whiteColor];
    [myDelegate.window makeKeyAndVisible];
}
- (IBAction)lianxi:(id)sender {
    LianViewController  *lianView = [[LianViewController alloc] init];
    [self.navigationController pushViewController:lianView animated:YES];
}
//上传文件
- (IBAction)upload:(id)sender {
    UploadViewController *upload = [[UploadViewController alloc]init];
    [self.navigationController pushViewController:upload animated:NO];
}
@end
