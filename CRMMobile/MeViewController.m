//
//  MeViewController.m
//  CRMMobile
//
//  Created by gwb on 16/4/29.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "MeViewController.h"
#import "config.h"
#import "CustomerInformationTableViewController.h"
#import "MailListTableViewController.h"
#import "TaskReportViewController.h"
#import "SubmitTableViewController.h"
#import "MarketManagementViewController.h"
#import "VisitPlanTableViewController.h"
#import "XGViewController.h"
#import "AboutOfView.h"
#import "LianXiController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GetImgFromAlbumViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface MeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) UIButton *photoButton;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setUpUI];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
    NSString *imgFileName=[userName stringByAppendingString:@"imageNew"];
    NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:imgFileName];
    NSData *data =[NSData dataWithContentsOfFile:dataPath];
    if(data){
        UIImage *image=[UIImage imageWithData:data];
        [self.photoButton setImage:image forState:UIControlStateNormal];
    }else{
    [self.photoButton setImage:[UIImage imageNamed:@"me_defaultpic.png"] forState:UIControlStateNormal];
    }
}

-(void)setUpUI{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self  action:nil];
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1.0];
    UIImageView *meImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT*0.3)];
    UIImage *image=[UIImage imageNamed:@"me_background.png"];
    meImageView.image=image;
    [self.view addSubview:meImageView];
    [self makeUpImageButton:0 secondParam:SCREENHEIGHT*0.3 thirdParam:SCREENWIDTH/3 fourthParam:80 fifthParam:@"通讯录" sixParam:@"tongxunlu_xuanzhong.jpg" sevenParam:@"tongxunlu"];
    [self makeUpImageButton:SCREENWIDTH/3 secondParam:SCREENHEIGHT*0.3 thirdParam:SCREENWIDTH/3 fourthParam:80 fifthParam:@"客户档案" sixParam:@"kehudangan.png" sevenParam:@"kehudangan"];
    [self makeUpImageButton:SCREENWIDTH/3*2 secondParam:SCREENHEIGHT*0.3 thirdParam:SCREENWIDTH/3 fourthParam:80 fifthParam:@"工作报告" sixParam:@"gongzuorizhi.png" sevenParam:@"gongzuobaogao"];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+80  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:SCREENWIDTH*0.33333    secondParam:SCREENHEIGHT*0.3  thirdParam:1 fourthParam:80];
    [self makeDivdLine:SCREENWIDTH*0.33333+SCREENWIDTH*0.33333  secondParam:SCREENHEIGHT*0.3  thirdParam:1 fourthParam:80];
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+10 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"任务提交" sixParam:@"renwutijiao.png" sevenParam:@"renwutijiao"];
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+50 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"活动统计" sixParam:@"huodongtongji.png" sevenParam:@"huodongtongji"];
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+90 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"拜访计划" sixParam:@"baifangjihua.png" sevenParam:@"baifangjihua"];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+10  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+50  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+90  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+130  thirdParam:SCREENWIDTH fourthParam:1];

    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+140 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"修改密码" sixParam:@"xiugaimima.png" sevenParam:@"xiugaimima"];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+140  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+180  thirdParam:SCREENWIDTH fourthParam:1];
    
    
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+190 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"联系我们" sixParam:@"app_phone.png" sevenParam:@"lianxiwomen"];
    [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+230 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"关于" sixParam:@"app_about.png" sevenParam:@"guanyu"];
    
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+190  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+230  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+270  thirdParam:SCREENWIDTH fourthParam:1];
    
     [self makeLeftImageButton:0 secondParam:SCREENHEIGHT*0.3+90+280 thirdParam:SCREENWIDTH fourthParam:40 fifthParam:@"退出登录" sixParam:nil sevenParam:@"tuichu"];
    
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+280  thirdParam:SCREENWIDTH fourthParam:1];
    [self makeDivdLine:0  secondParam:SCREENHEIGHT*0.3+90+330  thirdParam:SCREENWIDTH fourthParam:1];
    self.photoButton =[[UIButton alloc] initWithFrame:CGRectMake(20, SCREENWIDTH*0.3/2, 100, 100)];
   
    SEL selector = NSSelectorFromString(@"getPhoto");
    [self.photoButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.photoButton.layer.cornerRadius = 50;
    self.photoButton.layer.borderWidth = 1.0;
    self.photoButton.backgroundColor=[UIColor whiteColor];
    self.photoButton.layer.borderColor =[UIColor clearColor].CGColor;
    self.photoButton.clipsToBounds = TRUE;
    [self.view addSubview:self.photoButton];
    //取出登陆信息
    NSDictionary *Diclogin = [[NSDictionary alloc]init];
    Diclogin= APPDELEGATE.sessionInfo;
    NSString *loginName = [[Diclogin  objectForKey:@"obj"] objectForKey:@"loginName"];
    NSString *orgName   = [[Diclogin objectForKey:@"obj"]objectForKey:@"orgName"];
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, SCREENWIDTH*0.3/2+20, 100, 30)];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
     UILabel *jobLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, SCREENWIDTH*0.3/2+45, 100, 30)];
    jobLabel.textColor=[UIColor whiteColor];
    jobLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    if ([loginName isEqualToString:@"admin"]) {
        nameLabel.text=@"超级管理员";
       jobLabel.text=@"运营部";
    }else{
        //普通用户
        nameLabel.text=loginName;
        jobLabel.text=orgName;
    }
    [self.view addSubview:nameLabel];
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
    if(SCREENWIDTH>375){
    button.imageEdgeInsets = UIEdgeInsetsMake(20,50,35,60);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    }else{
        button.imageEdgeInsets = UIEdgeInsetsMake(30,45,30,55);
    }
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
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    if(name.length==2){
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREENWIDTH+90, 0, 0);
    }else{
        if ([name isEqualToString:@"退出登录"]) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREENWIDTH+400, 0, 0);
        }else{
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREENWIDTH+125, 0, 0);
        }
    }
 
    SEL selector = NSSelectorFromString(touchFuction);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma 相机的使用
//点击修改图片
- (void)getPhoto {
//    UIActionSheet *sheet;
//    sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片的来源" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:@"相册", nil];
//    sheet.tag = 255;
//    [sheet showInView:self.view];
    //[self.navigationController pushViewController:[[GetImgFromAlbumViewController alloc] init] animated:NO];
}

//点击调用相机
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController pushViewController:[[GetImgFromAlbumViewController alloc] init] animated:YES];
        } else {
            return;
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:^{}];
        }
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:^{}];
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    // 保存图片至本地，方法见下文
//    NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
//    NSString *imgNames = [userName stringByAppendingString:@".png"];
//    [self saveImage:image withName:imgNames];
//    
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgNames];
//    
//    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
//    [self.Image setImage:savedImage];
//    self.imageNames11 = imgNames;
//    self.Image.tag = 100;
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:^{}];
//}
//
//NSData * UIImageJPEGRepresentation ( UIImage *image, CGFloat compressionQuality);
//
//#pragma mark - 保存图片至沙盒
//- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//    // 获取沙盒目录
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    // 将图片写入文件
//    [imageData writeToFile:fullPath atomically:NO];
//    NSString *path = [imageData base64Encoding];
//    self.imagePaths11 = path;
//    [self pickerImg:path];
//}

#pragma 客户档案
-(void) kehudangan{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[CustomerInformationTableViewController alloc] init] animated:YES];
}
#pragma 通讯录
-(void) tongxunlu{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[MailListTableViewController alloc] init] animated:YES];
    
}
#pragma 工作报告
-(void) gongzuobaogao{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[TaskReportViewController alloc] init] animated:YES];
    
}
#pragma 任务提交
-(void) renwutijiao{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[SubmitTableViewController alloc] init] animated:YES];
    
}
#pragma 活动统计
-(void) huodongtongji{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[MarketManagementViewController alloc] init] animated:YES];
    
}
#pragma 拜访计划
-(void) baifangjihua{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[VisitPlanTableViewController alloc] init] animated:YES];
    
}
#pragma 修改密码
-(void) xiugaimima{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[XGViewController alloc] init] animated:YES];
    
}
#pragma 联系我们
-(void) lianxiwomen{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[LianXiController alloc] init] animated:YES];
    
}
#pragma 关于
-(void) guanyu{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[AboutOfView alloc] init] animated:YES];

}

#pragma 退出提示
-(void) tuichu{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"是否退出登录？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma 退出回调方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        myDelegate.sessionInfo = nil;
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        myDelegate.window.rootViewController = loginViewController;
        myDelegate.window.backgroundColor = [UIColor whiteColor];
        [myDelegate.window makeKeyAndVisible];
    }
}
@end
