//
//  NoticeTableViewController.m
//  CRMMobile
//
//  Created by zhang on 15/10/27.
//  Copyright (c) 2015年 dagong. All rights reserved.
//
#import "AppDelegate.h"
#import "NoticeTableViewController.h"
#import "config.h"

@interface NoticeTableViewController ()

@property (strong, nonatomic) NSMutableArray *fakeData;
@property (strong, nonatomic) NSMutableArray *userIdData;
@property (strong, nonatomic) NSMutableArray *dataing;
@property (strong, nonatomic) NSMutableArray *uid;

@end

@implementation NoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"1112");
    [self faker:@"1"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) faker: (NSString *) page{
    NSError *error;
    self.fakeData=[[NSMutableArray alloc] init];
    self.dataing=[[NSMutableArray alloc] init];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mnoticeManageAction!threeDatagrid1.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"page=%@&MOBILE_SID=%@",page,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    NSArray *images = [[NSArray alloc] initWithObjects:@"SouthAfrica.png",@"Mexico.png",
                       @"Argentina.png",@"Nigeria.png",@"England.png",@"USA.png",
                       @"Germany.png",@"Australia.png",@"Holland.png",@"Denmark.png",
                       @"Brazil.png",@"NorthKorea.png",@"Spain.png",@"Switzerland.png",nil];
    //    if([list count] ==0)
    //    {
    //        self.tableView.footerRefreshingText = @"没有更多数据";
    //
    //    }else
    //    {
    //        self.tableView.footerRefreshingText=@"加载中";
    //    }
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        [self.uid addObject:listdic];
        NSString *teamname = (NSString *)[listdic objectForKey:@"publishContent"];
        NSLog(@"%@",teamname);
        NSString *userId   = (NSString *)[listdic objectForKey:@"publishTimeStr"];
        NSLog(@"%@",userId);
        [self.fakeData     addObject:teamname];
        [self.userIdData   addObject:userId];
        [self.dataing   addObject:userId];
    }
    //[self userIdReturn:self.userIdDahttp://172.16.21.42:8080/dagongcrm/ta];
    //return self.fakeData;
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




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];}
    NSDictionary *item = [self.fakeData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[self.fakeData objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.52 alpha:1.0]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *testDetail =[@"提交人:" stringByAppendingString:self.fakeData[indexPath.row]];
    NSString *testDetail1 =[@"提交人:" stringByAppendingString:self.dataing[indexPath.row]];
    NSString *str =[testDetail1 stringByAppendingString:testDetail];
    [cell.detailTextLabel setText:str];
    [cell.imageView setImage:[UIImage imageNamed:@"image.png"]];
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fakeData count];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
