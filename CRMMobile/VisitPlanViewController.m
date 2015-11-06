//
//  VisitPlanViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/5.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "VisitPlanViewController.h"

@interface VisitPlanViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UILabel *visitDate;
@property (weak, nonatomic) IBOutlet UILabel *orgName;
- (IBAction)delete:(id)sender;

@end

@implementation VisitPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)delete:(id)sender {
}
@end
