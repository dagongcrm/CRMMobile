//
//  SubmitTableViewController.m
//  CRMMobile
//
//  Created by zhang on 15/10/30.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "SubmitTableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "UIImage+Tint.h"
#import "WorkTableViewController.h"
#import "addTaskViewController.h"

@interface SubmitTableViewController ()

@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *userIdData;
@property (strong, nonatomic) NSMutableArray *dataing;
@property (strong, nonatomic) NSMutableArray *time;
@property (strong, nonatomic) NSMutableArray *uid;

@end

@implementation SubmitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self faker:@"1"];
    [self leftButtonInit];
}
-(NSMutableArray *) faker: (NSString *) page{
    NSError *error;
    self.fakeData=[[NSMutableArray alloc] init];
    self.dataing=[[NSMutableArray alloc] init];
    self.time=[[NSMutableArray alloc] init];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!renWuJBXXTJDatagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@&zhuangTai=0",page,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
        for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        [self.uid addObject:listdic];
            NSString *submitID = (NSString *)[listdic objectForKey:@""];
        NSString *teamname = (NSString *)[listdic objectForKey:@"qiYeMC"];
        NSLog(@"%@",teamname);
        NSString *userId   = (NSString *)[listdic objectForKey:@"yeWuZLMC_cn"];
        NSLog(@"%@",userId);
        NSString *time   = (NSString *)[listdic objectForKey:@"renWuTJSJStr"];       [self.fakeData     addObject:teamname];
        [self.time   addObject:time];
        [self.dataing   addObject:userId];
    }
    //[self userIdReturn:self.userId];
    return self.fakeData;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
        return [self.fakeData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [self.fakeData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[self.fakeData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"业务种类:" stringByAppendingString:self.dataing[indexPath.row]];
    NSString *testDetail1 =[@"  提交时间:" stringByAppendingString:self.time [indexPath.row]];
    NSString *str =[testDetail stringByAppendingString:testDetail1];
    [cell.detailTextLabel setText:str];
    [cell.imageView setImage:[UIImage imageNamed:@"0.png"]];
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (IBAction)addFlow:(id)sender
{
    addTaskViewController *la = [[addTaskViewController alloc] init];
      [self.navigationController pushViewController:la animated:YES];
}
-(void) leftButtonInit{
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addFlow:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage imageNamed:@"back001.png"] imageWithTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ResView) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,rightItem];
    
}
- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[WorkTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
