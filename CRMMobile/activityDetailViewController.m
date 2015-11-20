//
//  activityDetailViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/16.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "activityDetailViewController.h"

@interface activityDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *activityName;

@end

@implementation activityDetailViewController
@synthesize marketActivity=_marketActivity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"活动计划";
    //self.listData = [[NSMutableArray alloc]init];
    self.activityName.text =_marketActivity.activityName;
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
