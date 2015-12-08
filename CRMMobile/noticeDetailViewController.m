//
//  noticeDetailViewController.m
//  CRMMobile
//
//  Created by zhang on 15/12/7.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "noticeDetailViewController.h"
#import "NoticeTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "noticeEntity.h"

@interface noticeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *documentTitle;
@property (weak, nonatomic) IBOutlet UITextField *publishContent;
@property (weak, nonatomic) IBOutlet UITextField *publishOrganizationStr;
@property (weak, nonatomic) IBOutlet UITextField *publishScopeStr;
@property (weak, nonatomic) IBOutlet UITextField *publishTimeStr;
@property (weak, nonatomic) IBOutlet UITextField *attachment;

@end

@implementation noticeDetailViewController
@synthesize noticeEntity=_noticeEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"通知详情";
    self.scroll.contentSize = CGSizeMake(375, 600);
    self.documentTitle.text=_noticeEntity.documentTitle;
    self.publishContent.text=_noticeEntity.publishContent;
    self.publishOrganizationStr.text=_noticeEntity.publishOrganizationStr;
    self.publishScopeStr.text=_noticeEntity.publishScopeStr;
    self.publishTimeStr.text=_noticeEntity.publishTimeStr;
    self.attachment.text=_noticeEntity.attachment;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
