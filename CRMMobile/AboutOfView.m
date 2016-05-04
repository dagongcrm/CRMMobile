//
//  AboutOfView.m
//  CRMMobile
//
//  Created by 伍德友 on 16/5/4.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "AboutOfView.h"
#import "config.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface AboutOfView ()

@end

@implementation AboutOfView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    [self setUpUI];
}
- (void)setUpUI{
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:NAVBLUECOLOR];
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, self.navigationController.navigationBar.frame.size.height+13, 100, 50)];
//    label.text=@"客户管理";
//    label.font = [UIFont fontWithName:@"Helvetica" size:15];
//    label.textColor = [UIColor blackColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-35, 90, 70, 70)];
    imgView.image = [UIImage imageNamed:@"appIcon.png"];
    [self.view addSubview:imgView];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-35, 150, 100, 50)];
    label.text=@"版本号V1.1";
    label.font = [UIFont fontWithName:@"Helvetica" size:12];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    [self makeDivdLine:0 secondParam:200 thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0 secondParam:250 thirdParam:SCREENWIDTH fourthParam:1];
    [self makeLeftImageButton:0 secondParam:200 thirdParam:SCREENWIDTH fourthParam:50 fifthParam:@"产品名称：CRM移动端V1.1" sixParam:nil
                   sevenParam:nil];
 
    [self makeDivdLine:0 secondParam:270 thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0 secondParam:320 thirdParam:SCREENWIDTH fourthParam:1];
    [self makeLeftImageButton:0 secondParam:270 thirdParam:SCREENWIDTH fourthParam:50 fifthParam:@"开发者：大公信用软件有限公司" sixParam:nil
                   sevenParam:nil];
    
    [self makeDivdLine:0 secondParam:340 thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0 secondParam:390 thirdParam:SCREENWIDTH fourthParam:1];
    [self makeLeftImageButton:0 secondParam:340 thirdParam:SCREENWIDTH fourthParam:50 fifthParam:@"网址：www.dagongsoftware.com" sixParam:nil
                   sevenParam:nil];
//    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:100 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"客户联系人" sixParam:@"kehulianxiren.png" sevenParam:@"kehulianxiren"];
//    [self makeDivdLine:SCREENWIDTH/2 secondParam:100 thirdParam:1 fourthParam:50];
//    
//    
//    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(10, 165, 100, 40)];
//    label2.text=@"拜访管理";
//    label2.font = [UIFont fontWithName:@"Helvetica" size:15];
//    label2.textColor = [UIColor blackColor];
//    [self.view addSubview:label2];
//    [self makeDivdLine:0 secondParam:204  thirdParam:SCREENWIDTH fourthParam:1];
//    [self makeDivdLine:0 secondParam:255  thirdParam:SCREENWIDTH fourthParam:1];
//    [self makeLeftImageButton:0 secondParam:205 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"拜访计划" sixParam:@"baifangjihua.png" sevenParam:@"baifangjihua"];
//    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:205 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"拜访纪录" sixParam:@"baifangjilu.png" sevenParam:@"baifangjilu"];
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
//    [self makeLeftImageButton:0 secondParam:305 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务提交" sixParam:@"renwutijiao.png" sevenParam:@"renwutijiao"];
//    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:305 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务跟踪" sixParam:@"renwugenzong.png" sevenParam:@"renwugenzong"];
//    [self makeLeftImageButton:0 secondParam:355 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务审核" sixParam:@"renwushenhe.png" sevenParam:@"renwushenhe"];
//    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:355 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"" sixParam:@"" sevenParam:@"doNothing"];
//    
//    [self makeDivdLine:0 secondParam:355  thirdParam:SCREENWIDTH fourthParam:1];
//    [self makeDivdLine:SCREENWIDTH/2 secondParam:305 thirdParam:1 fourthParam:100];
    
}


-(void)makeLeftImageButton:(CGFloat) x secondParam:(CGFloat) y thirdParam:(CGFloat) width fourthParam:(CGFloat) height fifthParam:(NSString *) name sixParam:(NSString*) imgname sevenParam:(NSString *)touchFuction{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, width, height);
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:imgname] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgname] forState:UIControlStateHighlighted];
    button.imageEdgeInsets = UIEdgeInsetsMake(15, 25, 15, SCREENWIDTH/2-50);
    [button setTitle:name forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    SEL selector = NSSelectorFromString(touchFuction);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void) makeDivdLine:(CGFloat) x secondParam:(CGFloat) y thirdParam:(CGFloat) width fourthParam:(CGFloat) height{
    UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
    navDividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [navDividingLine sizeToFit];
    [self.view addSubview:navDividingLine];
}

@end
