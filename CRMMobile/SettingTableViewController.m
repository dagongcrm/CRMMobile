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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        LianViewController  *lianView = [[LianViewController alloc] init];
        [self.navigationController pushViewController:lianView animated:YES];
    }else if(indexPath.row==1){
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        myDelegate.sessionInfo = nil;
        //    myDelegate.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        myDelegate.window.rootViewController = loginViewController;
        myDelegate.window.backgroundColor = [UIColor whiteColor];
        [myDelegate.window makeKeyAndVisible];

    }else if(indexPath.row==2){
        NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
        NSString *imagePath = [userName stringByAppendingString:@".png"];
        // 获取沙盒目录
        NSString *imageFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imagePath];
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        [fileManager removeItemAtPath:imageFile error:nil];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
