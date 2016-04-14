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
//#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    //启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"];
//    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//顶部的字体颜色
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [NSThread sleepForTimeInterval:1.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window.rootViewController = loginViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    id itemsCache = [SDGridItemCacheTool itemsArray];
    if (!itemsCache) {
        NSArray *itemsArray =      @[@{@"客户档案"   : @"kehudangan"},
                                     @{@"客户联系人" : @"kehulianxiren"},
                                     @{@"拜访计划"   : @"baifangjihua"},
                                     @{@"拜访纪录"   : @"baifangjilu"},
                                     @{@"任务提交"   : @"renwutijiao"},
                                     @{@"任务跟踪"   : @"renwugenzong"},
                                     @{@"市场活动"   : @"shichanghuodong"},
                                     @{@"活动统计"   : @"huodongtongji"},
                                     @{@"工作日志"   : @"gongzuorizhi"},
                                     @{@"更多"      : @"gengduo1"}
                                     ];
        [SDGridItemCacheTool saveItemsArray:itemsArray];    
}
    return YES;
}
@end
