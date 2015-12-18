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
- (IBAction)callMe:(id)sender;//联系我们

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


- (IBAction)callMe:(id)sender {
    NSLog(@"你好，先生！有什么可以帮到你的？");
    NSString *str = @"tel://";
    NSString *telephone = [str stringByAppendingString:@"01051087768"];
    NSLog(@"你好，你的电话：%@",telephone);
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:telephone];
    // 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
}
@end
