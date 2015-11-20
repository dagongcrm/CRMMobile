//
//  EditSaleOppViewController.m
//  CRMMobile
//
//  Created by jam on 15/11/20.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "EditSaleOppViewController.h"

@interface EditSaleOppViewController ()

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

@implementation EditSaleOppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改销售机会";
    self.scroll.contentSize = CGSizeMake(375, 600);
    self.customerNameStr.text=_saleOppEntity.customerNameStr;
    self.saleOppSrc.text=_saleOppEntity.saleOppSrc;
    self.successProbability.text=_saleOppEntity.successProbability;
    self.saleOppDescription.text=_saleOppEntity.saleOppDescription;
    self.oppState.text=_saleOppEntity.oppState;
    self.contact.text=_saleOppEntity.contact;
    self.contactTel.text=_saleOppEntity.contactTel;
}

- (IBAction)cancel:(id)sender {
    
}

- (IBAction)save:(id)sender {
}
@end
