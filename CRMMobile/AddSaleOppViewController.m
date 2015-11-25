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
- (IBAction)customerNameSelect:(id)sender;

@end

@implementation AddSaleOppViewController
@synthesize saleOppEntity=_saleOppEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加销售机会";
    self.scroll.contentSize = CGSizeMake(375, 700);

}
//赋值方法
- (void) valuation {
    
//    _khmc.text=_customerCallPlanEntity.customerNameStr;
//    _visitDate.text=_customerCallPlanEntity.visitDate;
//    _theme.text=_customerCallPlanEntity.theme;
//    _respondentPhone.text=_customerCallPlanEntity.respondentPhone;
//    _respondent.text=_customerCallPlanEntity.respondent;
//    _address.text=_customerCallPlanEntity.address;
//    _visitProfile.text=_customerCallPlanEntity.visitProfile;
//    _result.text=_customerCallPlanEntity.result;
//    _customerRequirements.text=_customerCallPlanEntity.customerRequirements;
//    _customerChange.text=_customerCallPlanEntity.customerChange;
}
- (IBAction)cancel:(id)sender {
}

- (IBAction)save:(id)sender {
}

- (IBAction)customerNameSelect:(id)sender {
}
@end
