//
//  NoticeViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewController.h"
#import "CustomerInformationTableViewController.h"
#import "publicNoticeTableViewController.h"
#import "UIImage+Tint.h"
#import "UIScrollView+MJRefresh.h"
#import "UIColor+HexString.h"
#import "UIScrollView+MJExtension.h"

@interface NoticeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *publicNotice;
@property (weak, nonatomic) IBOutlet UIButton *notice;
@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;
@property (strong, nonatomic) NSMutableArray *NotificationListData;
@end

@implementation NoticeViewController
@synthesize leftSwipe;
@synthesize rightSwipe;
- (void)viewDidLoad {
        
    [super viewDidLoad];
    
    [self reloadData];
    self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipe];
    [self.view addGestureRecognizer:self.rightSwipe];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self  reloadData];
       //        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
//        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
//        self.swipeLabel.text = @"尼玛的, 你在往左边跑啊....";
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self  reloadData1];
        
    }
}

- (void)reloadData
{
   
        self.publicNotice.tintColor = [UIColor blueColor];
        self.notice.tintColor = [UIColor blackColor];
        publicNoticeTableViewController *nav = [[publicNoticeTableViewController alloc] init];
        nav.view.autoresizingMask = UIViewAutoresizingNone;
        [self addChildViewController:nav];
        nav.view.frame =  CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.view addSubview:nav.view];
        [nav didMoveToParentViewController:self];
   }
- (void)reloadData1
{
        self.publicNotice.tintColor = [UIColor blackColor];
        self.notice.tintColor = [UIColor blueColor];
        NoticeTableViewController *nav = [[NoticeTableViewController alloc] init];
        nav.view.autoresizingMask = UIViewAutoresizingNone;
        [self addChildViewController:nav];
        nav.view.frame =  CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.view addSubview:nav.view];
        [nav didMoveToParentViewController:self];
   }


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.NotificationListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];}
    [cell.textLabel setText:[self.NotificationListData objectAtIndex:indexPath.row]];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
