//
//  UploadViewController.m
//  CRMMobile
//
//  Created by why on 15/11/10.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "UploadViewController.h"
#import "config.h"
#import "AppDelegate.h"
//#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"

@interface UploadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *Image;
- (IBAction)Upload:(id)sender;
@property (strong,nonatomic)NSMutableArray *imgpathData;

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置图片为圆角的
    CALayer *lay  = self.Image.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:6.0];
    lay.borderWidth=1.0;
    lay.borderColor=[[UIColor grayColor] CGColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Upload:(id)sender {UIActionSheet *sheet;
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
       // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [self.Image setImage:savedImage];
    [self.imgpathData addObject:fullPath];
    self.Image.tag = 100;
    }
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
NSData * UIImageJPEGRepresentation ( UIImage *image, CGFloat compressionQuality);

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSLog(@"aaaaa");
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    [self pickerImg:fullPath];
    NSLog(@"cccc===>>>%@",fullPath);
}
-(void)pickerImg:(NSString *)path{
    NSString *fileName = @"currentImage";
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSLog(@"/////////////////////%@",sid);
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"uploadAction!upload.action"]];
//    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:URL];
//    [request setPostValue:sid forKey:@"MOBILE_SID"];
////    [request setValue:path forKey:@"file"];
//    [request setValue:fileName forKey:@"fileName"];
//    [request setFile:path withFileName:[NSString stringWithFormat:@"%@.png",fileName] andContentType:@"image/png" forKey:@"file"];
//    [request setCompletionBlock:^{
//        NSString *responseString = [request responseString];
//        [[[UIAlertView alloc]initWithTitle:@"上传成功" message:responseString delegate:self cancelButtonTitle:@"" otherButtonTitles:<#(NSString *), ...#>, nil]];
////    }];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&file=%@&fileName=%@",sid,path,fileName];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *imgDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"imgDic字典里面的内容为--》%@", imgDic);
    
}
@end
