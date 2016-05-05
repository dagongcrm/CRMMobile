//
//  LianXiController.m
//  CRMMobile
//
//  Created by 伍德友 on 16/5/5.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "LianXiController.h"
#import "lianxiCell.h"
#import "config.h"
@interface LianXiController (){
    NSMutableArray * title;
    NSMutableArray *content;
}

@end
@implementation LianXiController
-(NSMutableArray*)getTitle{
    if(!title){
        title = [[NSMutableArray alloc] initWithObjects:@"服务电话",@"电子邮箱", nil];
    }
    return title;
}
-(NSMutableArray*)getContent{
    if(!content){
        content = [[NSMutableArray alloc] initWithObjects:@"010-51087768",@"zhangyidg@dagongcredit.com", nil];
    }
    return content;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    [self initUpBar];
    [self setExtraCellLineHidden:self.tableView];
}
// hide the extraLine隐藏分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)initUpBar{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NAVCOLOR;
    [self getTitle];
    [self getContent];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return [title count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * cellId = @"lianxi";
    lianxiCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"lianxiCell" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.title.text = [title objectAtIndex:indexPath.section];
    cell.content.text = [content objectAtIndex:indexPath.section];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//      [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
@end
