//
//  LianViewController.m
//  CRMMobile
//
//  Created by why on 15/10/25.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "LianViewController.h"

@interface LianViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@end

@implementation LianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    self.mail.text = @"zhangyidg@dagongcredit.com";
    self.phone.text=@"010-51087768";
    [self.mail setEnabled:NO];
    [self.phone setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
