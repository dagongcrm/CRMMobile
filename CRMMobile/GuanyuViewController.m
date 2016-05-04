//
//  GuanyuViewController.m
//  CRMMobile
//
//  Created by why on 15/10/25.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "GuanyuViewController.h"
#import "config.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface GuanyuViewController ()
@end

@implementation GuanyuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    [self setUpUI];
}
- (void)setUpUI{
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:NAVBLUECOLOR];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, self.navigationController.navigationBar.frame.size.height+13, 100, 400)];
    label.text=@"客户管理";
    label.font = [UIFont fontWithName:@"Helvetica" size:15];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    [self makeDivdLine:0 secondParam:99  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0 secondParam:150 thirdParam:SCREENWIDTH fourthParam:1];
//    [self makeLeftImageButton:0 secondParam:100 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"客户档案" sixParam:@"kehudangan.png" sevenParam:@"kehudangan"];
//    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:100 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"客户联系人" sixParam:@"kehulianxiren.png" sevenParam:@"kehulianxiren"];
//    [self makeDivdLine:SCREENWIDTH/2 secondParam:100 thirdParam:1 fourthParam:50];
    
    
//    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(10, 165, 100, 40)];
//    label2.text=@"拜访管理";
//    label2.font = [UIFont fontWithName:@"Helvetica" size:15];
//    label2.textColor = [UIColor blackColor];
//    [self.view addSubview:label2];
//    [self makeDivdLine:0 secondParam:204  thirdParam:SCREENWIDTH fourthParam:1];
//    [self makeDivdLine:0 secondParam:255  thirdParam:SCREENWIDTH fourthParam:1];
////    [self makeLeftImageButton:0 secondParam:205 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"拜访计划" sixParam:@"baifangjihua.png" sevenParam:@"baifangjihua"];
////    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:205 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"拜访纪录" sixParam:@"baifangjilu.png" sevenParam:@"baifangjilu"];
//    [self makeDivdLine:SCREENWIDTH/2 secondParam:205 thirdParam:1 fourthParam:50];
//    
//    
//    UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(10, 265, 100, 40)];
//    label3.text=@"拜访管理";
//    label3.font = [UIFont fontWithName:@"Helvetica" size:15];
//    label3.textColor = [UIColor blackColor];
//    [self.view addSubview:label3];
//    [self makeDivdLine:0 secondParam:304  thirdParam:SCREENWIDTH fourthParam:1];
//    [self makeDivdLine:0 secondParam:405  thirdParam:SCREENWIDTH fourthParam:1];
//    
////    [self makeLeftImageButton:0 secondParam:305 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务提交" sixParam:@"renwutijiao.png" sevenParam:@"renwutijiao"];
////    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:305 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务跟踪" sixParam:@"renwugenzong.png" sevenParam:@"renwugenzong"];
////    [self makeLeftImageButton:0 secondParam:355 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务审核" sixParam:@"renwushenhe.png" sevenParam:@"renwushenhe"];
////    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:355 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"" sixParam:@"" sevenParam:@"doNothing"];
//    
//    [self makeDivdLine:0 secondParam:355  thirdParam:SCREENWIDTH fourthParam:1];
//    [self makeDivdLine:SCREENWIDTH/2 secondParam:305 thirdParam:1 fourthParam:100];
    
}

-(void) makeDivdLine:(CGFloat) x secondParam:(CGFloat) y thirdParam:(CGFloat) width fourthParam:(CGFloat) height{
    UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
    navDividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [navDividingLine sizeToFit];
    [self.view addSubview:navDividingLine];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
