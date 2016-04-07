//
//  SettingTableViewController.m
//  CRMMobile
//
//  Created by why on 15/12/7.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "SettingTableViewController.h"
#import "LianViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "config.h"
@interface SettingTableViewController ()
@property (nonatomic,retain) NSArray *setListData;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"setting.plist" ofType:nil];
    _setListData= [NSMutableArray arrayWithContentsOfFile:dataPath];
    [self setExtraCellLineHidden:self.tableView];
}
// hide the extraLine隐藏分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_setListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [_setListData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[item objectForKey:@"Name"]];
    [cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"Image"]]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        LianViewController  *lianView = [[LianViewController alloc] init];
        [self.navigationController pushViewController:lianView animated:YES];
    }else if(indexPath.row==1){
        //清除缓存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否退出登录？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = 1012;
        [alertView show];
//
//        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//        myDelegate.sessionInfo = nil;
//        //    myDelegate.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        myDelegate.window.rootViewController = loginViewController;
//        myDelegate.window.backgroundColor = [UIColor whiteColor];
//        [myDelegate.window makeKeyAndVisible];

    }else if(indexPath.row==2){
//        NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
//        NSString *imagePath = [userName stringByAppendingString:@".png"];
//        // 获取沙盒目录
//        NSString *imageFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imagePath];
//        NSFileManager * fileManager = [[NSFileManager alloc]init];
//        [fileManager removeItemAtPath:imageFile error:nil];
        //清除缓存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否清理缓存？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = 1011;
        [alertView show];

    }
 }


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 1011) {
        [self clearCache];
        
    }else if(buttonIndex == 1 && alertView.tag == 1012){
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
                myDelegate.sessionInfo = nil;
                //    myDelegate.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
                LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                myDelegate.window.rootViewController = loginViewController;
                myDelegate.window.backgroundColor = [UIColor whiteColor];
                [myDelegate.window makeKeyAndVisible];

    }else if(buttonIndex == 1 && alertView.tag == 1015){
        
    }else if(buttonIndex == 1 && alertView.tag == 1016){
    
    }
    
}

//清理缓存
-(void) clearCache
{
    NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
            NSString *imagePath = [userName stringByAppendingString:@".png"];
            // 获取沙盒目录
            NSString *imageFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imagePath];
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            [fileManager removeItemAtPath:imageFile error:nil];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                              withObject:nil waitUntilDone:YES];});
    
}

-(void)clearCacheSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"缓存清理成功！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
