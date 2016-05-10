//
//  GetImgFromAlbumViewController.m
//  CRMMobile
//
//  Created by 刘国江 on 16/5/10.
//  Copyright © 2016年 dagong. All rights reserved.
//

#import "GetImgFromAlbumViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "config.h"
#import "MeViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

@interface GetImgFromAlbumViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation GetImgFromAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setUpUI];
}

-(void) setUpUI{
    UIButton *photoButton =[[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-100, 20 , 100, 100)];
    [photoButton setImage:[UIImage imageNamed:@"gongzuorizhi.png"] forState:UIControlStateNormal];
    SEL selector = NSSelectorFromString(@"getPhotoFromAlbum");
    [photoButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    photoButton.layer.cornerRadius = 50;
    photoButton.layer.borderWidth = 1.0;
    photoButton.backgroundColor=[UIColor groupTableViewBackgroundColor];
    photoButton.layer.borderColor =[UIColor clearColor].CGColor;
    photoButton.clipsToBounds = TRUE;
    [photoButton setTitle:@"相册" forState:UIControlStateNormal];
    [self.view addSubview:photoButton];
    
    
    UIButton *photoButton2 =[[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/3+100, 20, 100, 100)];
    [photoButton2 setImage:[UIImage imageNamed:@"gongzuorizhi.png"] forState:UIControlStateNormal];
    SEL selector2 = NSSelectorFromString(@"getPhotoFromCarema");
    [photoButton2 addTarget:self action:selector2 forControlEvents:UIControlEventTouchUpInside];
    photoButton2.layer.cornerRadius = 50;
    photoButton2.layer.borderWidth = 1.0;
    photoButton2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    photoButton2.layer.borderColor =[UIColor clearColor].CGColor;
    photoButton2.clipsToBounds = TRUE;
    [self.view addSubview:photoButton2];
    
    
}

-(void) makeDivdLine:(CGFloat) x secondParam:(CGFloat) y thirdParam:(CGFloat) width fourthParam:(CGFloat) height{
    UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
    navDividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [navDividingLine sizeToFit];
    [self.view addSubview:navDividingLine];
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

-(void) getPhotoFromAlbum{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:^{}];
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if(status == AVAuthorizationStatusDenied){
        return ;
    } else if(status == AVAuthorizationStatusRestricted){
    } else if(status == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                [self presentViewController:imagePickerController animated:YES completion:nil];
            } else {
                return;
            }
        }];
    }
}
#pragma mark --imgPickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *userName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"loginName"];
    NSString *imgFileName=[userName stringByAppendingString:@"imageNew"];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData=[NSData dataWithData:UIImagePNGRepresentation(image)];
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:imgFileName];
    [imageData writeToFile:fullPath atomically:NO];
     [self dismissViewControllerAnimated:YES completion:^{
         [self.navigationController popViewControllerAnimated:NO];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
