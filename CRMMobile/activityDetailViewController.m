//
//  activityDetailViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/16.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "activityDetailViewController.h"

@interface activityDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *activityDate;
@property (weak, nonatomic) IBOutlet UITextField *activityAddress;
@property (weak, nonatomic) IBOutlet UITextField *activityCost;
@property (weak, nonatomic) IBOutlet UITextField *activityContent;
@property (weak, nonatomic) IBOutlet UITextField *responsibleDepartmentStr;
@property (weak, nonatomic) IBOutlet UITextField *responsibleDepartmentPersonStr;
@property (weak, nonatomic) IBOutlet UITextField *activitySketch;
@property (weak, nonatomic) IBOutlet UITextField *activityName;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation activityDetailViewController
@synthesize marketActivity=_marketActivity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroll.contentSize = CGSizeMake(375, 1000);
    self.title=@"活动计划";
    //self.listData = [[NSMutableArray alloc]init];
    self.activityName.text =_marketActivity.activityName;
    self.activityAddress.text  = _marketActivity.activityAddress;
    self.activityContent.text = _marketActivity.activityContent;
    self.activityCost.text = _marketActivity.activityCost;
    self.activityDate.text = _marketActivity.activityDate;
    self.activitySketch.text = _marketActivity.activitySketch;
    self.responsibleDepartmentStr.text = _marketActivity.responsibleDepartmentStr;
    self.responsibleDepartmentPersonStr.text = _marketActivity.responsibleDepartmentPersonStr;
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
