//
//  MeViewController.m
//  CRMMobile
//
//  Created by gwb on 16/4/29.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "MeViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface MeViewController ()


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setUpUI];
}

-(void)viewWillAppear:(BOOL)animated{
self.navigationController.navigationBarHidden = YES;
}

-(void)setUpUI{
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1.0];
    UIImageView *meImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT*0.3)];
    UIImage *image=[UIImage imageNamed:@"me_background.png"];
    meImageView.image=image;
    [self.view addSubview:meImageView];
    [self makeUpImageButton:0 secondParam:SCREENHEIGHT*0.3 thirdParam:SCREENWIDTH/3 fourthParam:80 fifthParam:@"通讯录" sixParam:@"tongxunlu_xuanzhong.jpg" sevenParam:@""];
    [self makeUpImageButton:SCREENWIDTH/3 secondParam:SCREENHEIGHT*0.3 thirdParam:SCREENWIDTH/3 fourthParam:80 fifthParam:@"客户档案" sixParam:@"kehudangan.png" sevenParam:@""];
    [self makeUpImageButton:SCREENWIDTH/3*2 secondParam:SCREENHEIGHT*0.3 thirdParam:SCREENWIDTH/3 fourthParam:80 fifthParam:@"工作报告" sixParam:@"gongzuorizhi.png" sevenParam:@""];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+80  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:SCREENWIDTH*0.33333    secondParam:SCREENHEIGHT*0.3  thirdParam:1 fourthParam:80];
    [self makeDivdLine:SCREENWIDTH*0.33333+SCREENWIDTH*0.33333  secondParam:SCREENHEIGHT*0.3  thirdParam:1 fourthParam:80];
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+10 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"任务提交" sixParam:@"renwutijiao.png" sevenParam:@""];
    
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+50 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"活动统计" sixParam:@"huodongtongji.png" sevenParam:@""];
    
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+90 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"拜访计划" sixParam:@"baifangjihua.png" sevenParam:@""];
    
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+10  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+50  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+90  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+130  thirdParam:SCREENWIDTH fourthParam:1];
    
    
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+140 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"修改密码" sixParam:@"xiugaimima.png" sevenParam:@""];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+140  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+180  thirdParam:SCREENWIDTH fourthParam:1];
    
    
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+190 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"联系我们" sixParam:@"app_phone.png" sevenParam:@""];
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+230 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"关于" sixParam:@"app_about.png" sevenParam:@""];
    
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+190  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+230  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+270  thirdParam:SCREENWIDTH fourthParam:1];
    
    UIButton *photoButton =[[UIButton alloc] initWithFrame:CGRectMake(20, SCREENWIDTH*0.3/2, 100, 100)];
    [photoButton setImage:[UIImage imageNamed:@"me_defaultpic.png"] forState:UIControlStateNormal];
    SEL selector = NSSelectorFromString(@"");
    [photoButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    photoButton.layer.cornerRadius = 50;
    photoButton.layer.borderWidth = 1.0;
    photoButton.backgroundColor=[UIColor whiteColor];
    photoButton.layer.borderColor =[UIColor clearColor].CGColor;
    photoButton.clipsToBounds = TRUE;
    [self.view addSubview:photoButton];
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, SCREENWIDTH*0.3/2+20, 60, 30)];
    nameLabel.text=@"李晓明";
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:nameLabel];
    
    UILabel *jobLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, SCREENWIDTH*0.3/2+45, 60, 30)];
    jobLabel.text=@"金融机构部";
    jobLabel.textColor=[UIColor whiteColor];
    jobLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [self.view addSubview:jobLabel];
    
    
}


-(void) makeDivdLine:(CGFloat) x secondParam:(CGFloat) y thirdParam:(CGFloat) width fourthParam:(CGFloat) height{
    UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
    navDividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [navDividingLine sizeToFit];
    [self.view addSubview:navDividingLine];
}



-(void)makeUpImageButton:(CGFloat) x secondParam:(CGFloat) y thirdParam:(CGFloat) width fourthParam:(CGFloat) height fifthParam:(NSString *) name sixParam:(NSString*) imgname sevenParam:(NSString *)touchFuction{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    button.frame = CGRectMake(x, y,width,height);//button的frame
    button.backgroundColor = [UIColor whiteColor];//button的背景颜色
    [button setImage:[UIImage imageNamed:imgname] forState:UIControlStateNormal];//给button添加image
    button.imageEdgeInsets = UIEdgeInsetsMake(30,45,30,55);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    [button setTitle:name forState:UIControlStateNormal];//设置button的title
    button.titleLabel.font = [UIFont systemFontOfSize:14];//title字体大小
    button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    button.titleEdgeInsets = UIEdgeInsetsMake(51, -button.titleLabel.bounds.size.width-55, 0, 0);
    SEL selector = NSSelectorFromString(touchFuction);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)makeLeftImageButton:(CGFloat) x secondParam:(CGFloat) y thirdParam:(CGFloat) width fourthParam:(CGFloat) height fifthParam:(NSString *) name sixParam:(NSString*) imgname sevenParam:(NSString *)touchFuction{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, width, height);
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:imgname] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgname] forState:UIControlStateHighlighted];
    button.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, SCREENWIDTH-40);
    [button setTitle:name forState:UIControlStateNormal];
    if(name.length==2){
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREENWIDTH+90, 0, 0);
    }else{
        
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREENWIDTH+125, 0, 0);
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    SEL selector = NSSelectorFromString(touchFuction);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}






@end
