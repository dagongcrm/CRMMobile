//
//  ActivityViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "ActivityViewController.h"
#import "activityEntity.h"
#import "config.h"
#import "AppDelegate.h"
@interface ActivityViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *activityName;
@property (weak, nonatomic) IBOutlet UITextField *activityDateStr;

@property (weak, nonatomic) IBOutlet UITextField *activityAddress;
@property (weak, nonatomic) IBOutlet UITextField *activityContent;
@property (weak, nonatomic) IBOutlet UITextField *activityCost;
@property (weak, nonatomic) IBOutlet UITextField *responsibleDepartmentStr;
@property (weak, nonatomic) IBOutlet UITextField *responsibleDepartmentPersonStr;
@property (weak, nonatomic) IBOutlet UITextField *activitySketch;

@property (strong,nonatomic)NSMutableArray *listData;
@end

@implementation ActivityViewController
@synthesize activityEntity = _activityEntity;
- (void)viewDidLoad {
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [super viewDidLoad];
    self.title=@"任务审核";
    //设置导航栏返回
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.scroll.contentSize = CGSizeMake(375, 1050);
    self.listData = [[NSMutableArray alloc]init];
    self.activityName.text = _activityEntity.activityName;
   
    self.activityDateStr.text = _activityEntity.activityDateStr;
    self.activityAddress.text = _activityEntity.activityAddress;
    self.activityContent.text = _activityEntity.activityContent;
    self.activityCost.text = _activityEntity.activityCost;
    self.responsibleDepartmentStr.text = _activityEntity.responsibleDepartmentStr;
    self.responsibleDepartmentPersonStr.text = _activityEntity.responsibleDepartmentPersonStr;
    self.activitySketch.text = _activityEntity.activitySketch;
     NSLog(@"qqqqqqqq",_activityName);
    
    [self.activityName setEnabled:NO];
    [self.activityDateStr setEnabled:NO];
    [self.activityAddress setEnabled:NO];
    [self.activityContent setEnabled:NO];
    [self.activityCost setEnabled:NO];
    [self.responsibleDepartmentStr setEnabled:NO];
    [self.responsibleDepartmentPersonStr setEnabled:NO];
    [self.activitySketch setEnabled:NO];

    NSString *reminders =_activityEntity.activityID;
    [self.listData addObject:reminders];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
