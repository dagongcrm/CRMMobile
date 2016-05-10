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
#import "GuanyuViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "LocationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewAdditions.h"
#import "MyViewController.h"
#import "SettingTableViewController.h"
#import "MeMainTableViewController.h"
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
@interface OptionsTableViewController()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) NSArray *OptionsListData;
@property (strong,nonatomic) MeUser *mMeUser;
@property (strong,nonatomic) XGViewController *xView;
@property (nonatomic, strong) NSMutableArray *ImageData;//zhaopianshuju
@property (weak, nonatomic) IBOutlet UITextField *txtname;//用户名
@property (weak, nonatomic) IBOutlet UITextField *txtOrg;//组织
@property (weak, nonatomic) IBOutlet UIImageView *Image;//头像
@property (strong ,nonatomic)NSString *imageNames11;
@property (strong ,nonatomic)NSString *imagePaths11;

//@property (weak, nonatomic)UIScrollView *scrollView;
@property (weak, nonatomic)UIPageControl *pageView;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UIScrollView * headScroll;
@property (nonatomic,strong)UIPageControl * pageControl;
@property (nonatomic,strong)NSArray * imagesArray;
@property (nonatomic,strong)NSTimer *time;
@property  NSInteger index;
- (IBAction)ImgButton:(id)sender;//头像按钮
- (IBAction)moveImg:(id)sender;//换背景

@property (weak, nonatomic) IBOutlet UIImageView *beijingImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation OptionsTableViewController
- (void)viewDidLoad {
    NAVCOLOR;
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

//    self.scroll.contentSize = CGSizeMake(375, 1300);
    _mMeUser = [[MeUser alloc] init];
    
    self.imagesArray = @[@"11.JPG",@"12.JPG",@"13.JPG",@"14.JPG",@"15.JPG",@"16.JPG"];
    [self setupScrollView];
    [self setupPageControl];

    //取出登陆信息
    NSDictionary *Diclogin = [[NSDictionary alloc]init];
    Diclogin= APPDELEGATE.sessionInfo;
    NSString *loginName = [[Diclogin  objectForKey:@"obj"] objectForKey:@"loginName"];
    NSString *orgName   = [[Diclogin objectForKey:@"obj"]objectForKey:@"orgName"];
    self.txtname.font   = [UIFont fontWithName:@"System" size:20.0f];
    self.txtOrg.font    = [UIFont fontWithName:@"System" size:20.0f];
    [self.txtname setEnabled:NO];
    [self.txtOrg  setEnabled:NO];
    if ([loginName isEqualToString:@"admin"]) {
        self.txtname.text = @"超级管理员";
        self.txtOrg.text =@"运营部";
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
    UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(0,324,self.view.bounds.size.width,1)];
    navDividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [navDividingLine sizeToFit];
    [self.view addSubview:navDividingLine];
    
    MeMainTableViewController *nav = [[MeMainTableViewController alloc] init];
    nav.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:nav];
    nav.view.frame =  CGRectMake(0, 325, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:nav.view];
    [nav didMoveToParentViewController:self];
}
//轮播加点击
//添加UISrollView
- (void)setupScrollView{
    // 添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 62, self.view.width, 150);
    scrollView.bounces = NO;
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    self.headScroll = scrollView;
    // 添加图片
    for (int i = 0; i<self.imagesArray.count; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        
        imageView.frame = CGRectMake(i * scrollView.width, 0, self.view.width, 200);
        imageView.image = [UIImage imageNamed:self.imagesArray[i]];
        [scrollView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tap];
        
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(self.imagesArray.count * scrollView.width, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.time = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

//添加pageControl
- (void)setupPageControl{
    // 添加PageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.centerX - 35, self.headScroll.height * 1.25, 70, 20)];
    _pageControl.numberOfPages = self.imagesArray.count;
    [self.view addSubview:_pageControl];
    [self.time fire];
    [[NSRunLoop currentRunLoop]addTimer:self.time forMode:NSRunLoopCommonModes];
    // 设置圆点的颜色
    [self changePageControlImage:self.pageControl];
    
}
//改变pagecontrol中圆点样式
- (void)changePageControlImage:(UIPageControl *)pageControl
{
    static UIImage *imgCurrent = nil;
    static UIImage *imgOther = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        imgCurrent = [UIImage imageNamed:@"dot"];
        imgOther = [UIImage imageNamed:@"dotk"];
    });
    
    
    if (iOS7) {
        [pageControl setValue:imgCurrent forKey:@"_currentPageImage"];
        [pageControl setValue:imgOther forKey:@"_pageImage"];
    } else {
        for (int i = 0;i < self.imagesArray.count; i++) {
            UIImageView *imageVieW = [pageControl.subviews objectAtIndex:i];
            imageVieW.frame = CGRectMake(imageVieW.frame.origin.x, imageVieW.frame.origin.y, 20, 20);
            imageVieW.image = pageControl.currentPage == i ? imgCurrent : imgOther;
        }
    }
}


#pragma mark --pageControl方法
- (void)changePage:(UIPageControl *)page{
    [self.headScroll setContentOffset:CGPointMake(self.view.width * page.currentPage, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int halfX = scrollView.frame.size.width / 2;
    int page = (scrollView.contentOffset.x - halfX) / self.view.width + 1;
    self.pageControl.currentPage = page;
    [self changePageControlImage:_pageControl];
    
}

- (void)timeAction{
    NSInteger page = self.pageControl.currentPage;
    page++;
    if (page == self.imagesArray.count) {
        page = 0;
    }
    CGPoint point = CGPointMake(self.view.width * page, 0);
    [self.headScroll setContentOffset:point animated:YES];
}
//轮播点击进入详情方法
-(void)tapClick:(UITapGestureRecognizer *)recognizer{
//    
//    UIImageView *imaView = (UIImageView *)recognizer.view;
//    MyViewController * MVC = [[MyViewController alloc]init];
//    
//    MVC.tapID = [NSString
//                 stringWithFormat:@"%@",[self.imagesArray objectAtIndex:imaView.tag - 100]];
//    NSLog(@"%@",MVC.tapID);
//    [self presentViewController:MVC animated:YES completion:nil];
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
    if(imgFile!=nil||imgFile!=NULL){
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
    // 判断是否支持相机
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//    sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图片的来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
//    }else{
     sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片的来源" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:@"相册", nil];
//            }
    sheet.tag = 255;
    [sheet showInView:self.view];
}

//点击调用相机
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"mmmmmmklklklklkl%lu",buttonIndex);
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            
//            switch (buttonIndex) {
//                case 0:
//                    // 相册
//                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    break;
//                case 1:
//                    // 相机
//                    sourceType = UIImagePickerControllerSourceTypeCamera;
//                    break;
//                    }
//        }
//            else {
                if (buttonIndex == 0) {
                   sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                  } else {
                    return;
            }
//        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:^{}];
//        [self presentModalViewController:imagePickerController animated:YES];
        //判断相机是否能够使用
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusAuthorized) {
            // authorized
            [self presentViewController:imagePickerController animated:YES completion:nil];
        } else if(status == AVAuthorizationStatusDenied){
            // denied
            return ;
        } else if(status == AVAuthorizationStatusRestricted){
            // restricted
        } else if(status == AVAuthorizationStatusNotDetermined){
            // not determined
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                } else {
                    return;
                }
            }];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"bbbbb");
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 保存图片至本地，方法见下文
    NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
    NSString *imgNames = [userName stringByAppendingString:@".png"];
    [self saveImage:image withName:imgNames];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgNames];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [self.Image setImage:savedImage];
    self.imageNames11 = imgNames;
    self.Image.tag = 100;
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
    self.imagePaths11 = path;
    [self pickerImg:path];
}

-(void)pickerImg:(NSString *)path{
    NSLog(@"///////222222/////3333////%@", path);
    NSString *fileName = self.imageNames11;
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

@end
