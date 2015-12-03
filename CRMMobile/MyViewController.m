




//
//  MyViewController.m
//  无限滚动轮播图 带小圆点
//
//  Created by CC on 15/11/25.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "MyViewController.h"
#import "UIViewAdditions.h"
@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
    label.backgroundColor = [UIColor yellowColor];
    label.text = self.tapID;
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    UIButton * butn = [UIButton buttonWithType:UIButtonTypeCustom];
    butn.frame = CGRectMake(self.view.centerX- 50, label.bottom + 30, 100, 30);
    [butn setTitle:@"返回" forState:UIControlStateNormal];
    butn.backgroundColor = [UIColor redColor];
    [butn addTarget:self action:@selector(backLastVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butn];
    
    

}

-(void)backLastVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
