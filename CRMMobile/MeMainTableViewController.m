//
//  MeMainTableViewController.m
//  CRMMobile
//
//  Created by why on 15/12/7.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "MeMainTableViewController.h"
#import "TXLTableViewController.h"
#import "XGViewController.h"
#import "SettingTableViewController.h"
#import "GuanyuViewController.h"

@interface MeMainTableViewController ()
@property (nonatomic,retain) NSArray *optionListData;
@end

@implementation MeMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"Options.plist" ofType:nil];
    _optionListData= [NSMutableArray arrayWithContentsOfFile:dataPath];
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
    
    return [_optionListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [_optionListData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[item objectForKey:@"Name"]];
    [cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"Image"]]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
    TXLTableViewController  *tongxunlu = [[TXLTableViewController alloc] init];
         tongxunlu.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:tongxunlu animated:YES];
    }else if(indexPath.row==1){
        XGViewController  *xiugai = [[XGViewController alloc] init];
        [self.navigationController pushViewController:xiugai animated:YES];
    }else if(indexPath.row==2){
        SettingTableViewController  *setting = [[SettingTableViewController alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }else if (indexPath.row==3){
        GuanyuViewController  *guanyu = [[GuanyuViewController alloc] init];
        [self.navigationController pushViewController:guanyu animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
