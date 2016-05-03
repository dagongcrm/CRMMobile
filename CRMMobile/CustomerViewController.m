//
//  CustomerViewController.m
//  CRMMobile
//
//  Created by gwb on 16/4/28.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "CustomerViewController.h"
#import "config.h"
#import "CustomerInformationTableViewController.h"
#import "CustomercontactTableViewController.h"
#import "VisitPlanTableViewController.h"
#import "TaskRecordsTableViewController.h"
#import "SubmitTableViewController.h"
#import "trackingTableViewController.h"
#import "auditTableViewController.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface CustomerViewController ()
@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
   self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:NAVBLUECOLOR];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, self.navigationController.navigationBar.frame.size.height+13, 100, 50)];
    label.text=@"客户管理";
    label.font = [UIFont fontWithName:@"Helvetica" size:15];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    [self makeDivdLine:0 secondParam:99  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0 secondParam:150 thirdParam:SCREENWIDTH fourthParam:1];
    [self makeLeftImageButton:0 secondParam:100 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"客户档案" sixParam:@"kehudangan.png" sevenParam:@"kehudangan"];
    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:100 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"客户联系人" sixParam:@"kehulianxiren.png" sevenParam:@"kehulianxiren"];
    [self makeDivdLine:SCREENWIDTH/2 secondParam:100 thirdParam:1 fourthParam:50];

    
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(10, 165, 100, 40)];
    label2.text=@"拜访管理";
    label2.font = [UIFont fontWithName:@"Helvetica" size:15];
    label2.textColor = [UIColor blackColor];
    [self.view addSubview:label2];
    [self makeDivdLine:0 secondParam:204  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0 secondParam:255  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeLeftImageButton:0 secondParam:205 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"拜访计划" sixParam:@"baifangjihua.png" sevenParam:@"baifangjihua"];
    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:205 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"拜访纪录" sixParam:@"baifangjilu.png" sevenParam:@"baifangjilu"];
    [self makeDivdLine:SCREENWIDTH/2 secondParam:205 thirdParam:1 fourthParam:50];
    
    
    UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(10, 265, 100, 40)];
    label3.text=@"拜访管理";
    label3.font = [UIFont fontWithName:@"Helvetica" size:15];
    label3.textColor = [UIColor blackColor];
    [self.view addSubview:label3];
    [self makeDivdLine:0 secondParam:304  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0 secondParam:405  thirdParam:SCREENWIDTH fourthParam:1];
    
    [self makeLeftImageButton:0 secondParam:305 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务提交" sixParam:@"renwutijiao.png" sevenParam:@"renwutijiao"];
    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:305 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务跟踪" sixParam:@"renwugenzong.png" sevenParam:@"renwugenzong"];
    [self makeLeftImageButton:0 secondParam:355 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"任务审核" sixParam:@"renwushenhe.png" sevenParam:@"renwushenhe"];
    [self makeLeftImageButton:SCREENWIDTH/2 secondParam:355 thirdParam:SCREENWIDTH/2 fourthParam:50 fifthParam:@"" sixParam:@"" sevenParam:@"doNothing"];
    
    [self makeDivdLine:0 secondParam:355  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:SCREENWIDTH/2 secondParam:305 thirdParam:1 fourthParam:100];

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


-(void) kehudangan{
    [self.navigationController pushViewController:[[CustomerInformationTableViewController alloc] init] animated:YES];
}
-(void) kehulianxiren{
    [self.navigationController pushViewController:[[CustomercontactTableViewController alloc] init] animated:YES];

}
-(void) baifangjihua{
    [self.navigationController pushViewController:[[VisitPlanTableViewController alloc] init] animated:YES];

}
-(void) baifangjilu{
    [self.navigationController pushViewController:[[TaskRecordsTableViewController alloc] init] animated:YES];

}
-(void) renwutijiao{
    [self.navigationController pushViewController:[[SubmitTableViewController alloc] init] animated:YES];

}
-(void) renwugenzong{
    [self.navigationController pushViewController:[[trackingTableViewController alloc] init] animated:YES];

}
-(void) renwushenhe{
    [self.navigationController pushViewController:[[auditTableViewController alloc] init] animated:YES];

}


-(void) doNothing{
    NSLog(@"%@",@"doNothing");
}


@end
