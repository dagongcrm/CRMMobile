//
//  AddSaleOppViewController.m
//  CRMMobile
//
//  Created by jam on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddSaleOppViewController.h"

@interface AddSaleOppViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextField *saleOppSrc;
@property (weak, nonatomic) IBOutlet UITextField *successProbability;
@property (weak, nonatomic) IBOutlet UITextField *saleOppDescription;
@property (weak, nonatomic) IBOutlet UITextField *oppState;
@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextField *contactTel;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation AddSaleOppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加销售机会";
    self.scroll.contentSize = CGSizeMake(375, 700);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (IBAction)cancel:(id)sender {
}

- (IBAction)save:(id)sender {
}
@end
