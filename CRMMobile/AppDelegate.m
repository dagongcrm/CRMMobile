//
//  AppDelegate.m
//  CRMMobile
//
//  Created by gwb on 15/10/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SDGridItemCacheTool.h"
#import "config.h"
#import "IntroViewController.h"

@implementation AppDelegate
@synthesize appDefault;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        NSArray *itemsArray =      @[@{@"客户档案"   : @"kehudangan"},
                                     @{@"客户联系人" : @"kehulianxiren"},
                                     @{@"拜访计划"   : @"baifangjihua"},
                                     @{@"拜访纪录"   : @"baifangjilu"},
                                     @{@"任务提交"   : @"renwutijiao"},
                                     @{@"任务跟踪"   : @"renwugenzong"},
                                     @{@"通知公告"   : @"shichanghuodong"},
                                     @{@"活动统计"   : @"huodongtongji"},
                                     @{@"工作日志"   : @"gongzuorizhi"}
                                     ];
        [SDGridItemCacheTool saveItemsArray:itemsArray];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [self ifFirstLanuch];
    if ([APPDELEGATE.appDefault boolForKey:@"firstLaunch"]){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        self.window = [[UIWindow alloc] initWithFrame:screenBounds];
        self.window.autoresizesSubviews = YES;
        IntroViewController *introViewController = [[IntroViewController alloc] init];
        self.window.rootViewController = introViewController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    }else{
        [NSThread sleepForTimeInterval:1.0];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        self.window.rootViewController = loginViewController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        }
    return YES;
}

-(void)ifFirstLanuch{
    APPDELEGATE.appDefault=[NSUserDefaults standardUserDefaults];
    if (![APPDELEGATE.appDefault boolForKey:@"everLaunched"])
    {
        [APPDELEGATE.appDefault setBool:YES forKey:@"everLaunched"];
        [APPDELEGATE.appDefault setBool:YES forKey:@"firstLaunch"];
    }
    else
    {
        [APPDELEGATE.appDefault setBool:NO forKey:@"firstLaunch"];
    }
}



@end
