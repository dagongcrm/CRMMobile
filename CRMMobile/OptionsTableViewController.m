//
//  OptionsTableViewController.m
//  CRMMobile
//
//  Created by gwb on 15/10/23.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "OptionsTableViewController.h"
#import "TXLTableViewController.h"
#import "XGViewController.h"
#import "SettingViewController.h"
#import "GuanyuViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "LocationViewController.h"

@interface OptionsTableViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *OptionsListData;
@property (strong,nonatomic) MeUser *mMeUser;
@property (strong,nonatomic) XGViewController *xView;
@property (nonatomic, strong) NSMutableArray *ImageData;//zhaopianshuju
@property (weak, nonatomic) IBOutlet UITextField *txtname;//用户名
@property (weak, nonatomic) IBOutlet UITextField *txtOrg;//组织
@property (weak, nonatomic) IBOutlet UIImageView *Image;//头像
@property (strong,nonatomic) NSMutableArray *imgpathData;
@property (strong,nonatomic) NSMutableArray *imageNamesData;
@property  NSInteger index;
- (IBAction)ImgButton:(id)sender;//头像按钮

- (IBAction)editpass:(id)sender;//修改密码
- (IBAction)setting:(id)sender;//设置

- (IBAction)tongxun:(id)sender;//通信录

- (IBAction)guanyu:(id)sender;//关于
- (IBAction)moveImg:(id)sender;//换背景
- (IBAction)location:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *beijingImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation OptionsTableViewController
- (void)viewDidLoad {
    NAVCOLOR;
    [super viewDidLoad];
    //设置导航栏返回
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.scroll.contentSize = CGSizeMake(375, 700);
    _mMeUser = [[MeUser alloc] init];
    //顶部的图片区域
    //把图片添加到动态数组
    NSMutableArray * animateArray = [[NSMutableArray alloc]initWithCapacity:20];
    [animateArray addObject:[UIImage imageNamed:@"10002"]];
    [animateArray addObject:[UIImage imageNamed:@"10003"]];
    [animateArray addObject:[UIImage imageNamed:@"10004"]];
    [animateArray addObject:[UIImage imageNamed:@"10001"]];
    //为图片设置动态
    self.beijingImg.animationImages = animateArray;
    //为动画设置持续时间
    self.beijingImg.animationDuration = 30.0;
    //为默认的无限循环
    self.beijingImg.animationRepeatCount = 0;
    //开始播放动画
    [self.beijingImg startAnimating];
    [self.view addSubview:self.beijingImg];
    //取出登陆信息
    NSDictionary *Diclogin = [[NSDictionary alloc]init];
    Diclogin= APPDELEGATE.sessionInfo;
    NSString *loginName = [[Diclogin  objectForKey:@"obj"] objectForKey:@"loginName"];
    NSString *orgName = [[Diclogin objectForKey:@"obj"]objectForKey:@"orgName"];
   
    NSLog(@"==========%@",loginName);

    self.txtname.font = [UIFont fontWithName:@"System" size:20.0f];
    self.txtOrg.font = [UIFont fontWithName:@"System" size:20.0f];
    
    [self.txtname setEnabled:NO];
    [self.txtOrg setEnabled:NO];
    if ([loginName isEqualToString:@"admin"]) {
        self.txtname.text = @"超级管理员";
        self.txtOrg.text =@"管理员";
    }else{
        //普通用户
        self.txtname.text =loginName;
        self.txtOrg.text = orgName;
    }
    //必须在uiimageview加载之后设置
    
    //设置图片为圆角的
    CALayer *lay  = self.Image.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:6.0];
    lay.borderWidth=1.0;
    lay.borderColor=[[UIColor grayColor] CGColor];
    [self loadImageqq];
}
//获取头像判断
-(void)loadImageqq{
    NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
    NSString *imgNames = [userName stringByAppendingString:@".png"];
   NSString *dataPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgNames];
    NSLog(@"/././././././././.%@",dataPath);
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:dataPath];
    NSData *_data = UIImageJPEGRepresentation(savedImage, 1.0f);
    NSString *image64 = [_data base64Encoding];
    if (image64.length==0) {
        NSLog(@"本地没有照片");
        [self faker];
    }else{
        //取头像
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:dataPath];
        //    self.isFullScreen = NO;
        [self.Image setImage:savedImage];
//        NSMutableArray *imgsData= [NSMutableArray arrayWithContentsOfFile:dataPath];
//        NSString *img3 = [imgsData objectAtIndex:1];
//        NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:img3];
//        UIImage *youImage = [UIImage imageWithData:_decodedImageData];
//        [self.Image setImage:youImage];

    }
}
//获取数据
-(NSMutableArray *)faker{
    NSDictionary *DicImg= [[NSDictionary alloc]init];
    DicImg= APPDELEGATE.sessionInfo;
    NSString *imgFile = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"imageFile"];
    NSLog(@"%@",imgFile);
        if(imgFile!=nil){
   NSString *path = @"http://10.10.10.172:8080/dagongcrm/common/style/uploadImages/";
    NSString *path1 = [path stringByAppendingString:imgFile];
    NSString *imgpath = [path1 stringByAppendingString:@".jpg"];
    NSURL *url = [NSURL URLWithString:imgpath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [self.Image setImage:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    // 获取沙盒目录
    NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
    NSString *imgNames = [userName stringByAppendingString:@".png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgNames];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    }else{
        NSLog(@"暂无头像");
    }
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击修改图片
- (IBAction)ImgButton:(id)sender {
    UIActionSheet *sheet;
    //        // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
    sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    
            }else{
    
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            }
    sheet.tag = 255;
    [sheet showInView:self.view];
}
//点击调用相机

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;

                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                    }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"bbbbb");
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
    NSString *imgNames = [userName stringByAppendingString:@".png"];
    [self saveImage:image withName:imgNames];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgNames];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    //    self.isFullScreen = NO;
    [self.Image setImage:savedImage];
    self.imageNamesData=[[NSMutableArray alloc]init];
    [self.imageNamesData addObject:imgNames];
    self.Image.tag = 100;
//    NSLog(@"cccc===>>>%@",fullPath);
//    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
NSData * UIImageJPEGRepresentation ( UIImage *image, CGFloat compressionQuality);

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    NSString *path = [imageData base64Encoding];
    [self.imgpathData addObject:path] ;
    [self pickerImg:path];
}

-(void)pickerImg:(NSString *)path{
    NSLog(@"///////222222/////3333////%@", path);
    NSString *fileName = [self.imageNamesData objectAtIndex:1];
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"uploadAction!upload.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";

    NSString *param=[NSString stringWithFormat:@"file=%@&MOBILE_SID=%@&fileName=%@",path,sid,fileName];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *imgDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"imgDic字典里面的内容为--》%@", imgDic);
    NSLog(@"//////////1%@",path);
    NSLog(@"//////////2%@",fileName);
}
//xiugaimima
- (IBAction)editpass:(id)sender {
    //修改密码
    _xView =  [[XGViewController alloc]init];
    [self.navigationController pushViewController:_xView animated:YES];
}
//设置
- (IBAction)setting:(id)sender {
    SettingViewController *setView = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setView animated:YES];
}
//通讯录
- (IBAction)tongxun:(id)sender {
    TXLTableViewController *txlView = [[TXLTableViewController alloc] init];
    txlView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:txlView animated:YES];
}
//关于
- (IBAction)guanyu:(id)sender {
    GuanyuViewController *guanView = [[GuanyuViewController alloc] init];
    [self.navigationController pushViewController:guanView animated:YES];
}
- (IBAction)moveImg:(id)sender {
    NSLog(@"准备换背景图片");
}
- (IBAction)location:(id)sender {
    LocationViewController *locationView=[[LocationViewController alloc] init];
    locationView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:locationView animated:YES];
}
@end
