//
//  ReminderDetailViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/16.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "GLReusableViewController.h"
#import "ReminderTableViewController.h"
#import "ReminderDetailViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "ReminderEntity.h"
#import "IndexViewController.h"
@interface ReminderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *qiYeMC;
@property (weak, nonatomic) IBOutlet UITextField *yeWuZL;
@property (weak, nonatomic) IBOutlet UITextField *hangYeFLMC;
@property (weak, nonatomic) IBOutlet UITextField *heTongJE;
@property (weak, nonatomic) IBOutlet UITextField *genZongSFJE;
@property (weak, nonatomic) IBOutlet UITextField *zhuChengXS;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *lianXiFS;
- (IBAction)goback:(id)sender;
- (IBAction)del:(id)sender;
@property (strong,nonatomic)NSMutableArray *listData;
@end

@implementation ReminderDetailViewController
@synthesize reminderEntity = _reminderEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroll.contentSize = CGSizeMake(375, 1050);
    self.listData = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    
    self.qiYeMC.text = _reminderEntity.submitName;
    self.yeWuZL.text = _reminderEntity.yeWuZLMC_cn;
    self.hangYeFLMC.text = _reminderEntity.hangYeFLMC;
    self.heTongJE.text = _reminderEntity.heTongJEStr;
    self.genZongSFJE.text = _reminderEntity.genZongSFJEStr;
    self.zhuChengXS.text = _reminderEntity.zhuChengXS;
   
    self.userName.text = _reminderEntity.userName;
    self.lianXiFS.text = _reminderEntity.lianXiFS;
    
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mRenWuSH_DGGJAction!renWuSH_DGGJForm1.action?flag=2&step=1"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
 
    NSString *qiYeBH = _reminderEntity.submitID;
    NSString *qiYeMC = _reminderEntity.submitName;
    NSString *yeWuZLMC_cn = _reminderEntity.yeWuZLMC_cn;
    NSString *yeWuZLBH= _reminderEntity.yeWuZLBH;
   
    NSString *ftn_ID = _reminderEntity.ftn_ID;
    NSString *hangYeFLMC= _reminderEntity.hangYeFLMC;
    NSString *heTongJE = _reminderEntity.heTongJEStr;
    NSString *genZongSFJE= _reminderEntity.genZongSFJEStr;
    NSString *zhuChengXS = _reminderEntity.zhuChengXS;
    NSString *userName = _reminderEntity.userName;
    NSString *lianXiFS = _reminderEntity.lianXiFS;
    
    NSString *param=[NSString stringWithFormat:@"ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC_cn=%@&MOBILE_SID=%@&hangYeFLMC=%@&heTongJE=%@&=%@&zhuChengXS=%@&userName=%@&lianXiFS=%@",ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC_cn,sid,hangYeFLMC,heTongJE,genZongSFJE,zhuChengXS,userName,lianXiFS];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)goback:(id)sender {
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mRenWuSH_DGGJAction!sendBack.action?step=1"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *bianHao = _reminderEntity.bianHao;
    NSString *qiYeMC = _reminderEntity.qiYeMC;
    NSString *yeWuZLMC_cn = _reminderEntity.yeWuZLMC_cn;
    
    NSString *userID = _reminderEntity.userID;
    NSString *hangYeFLMC= _reminderEntity.hangYeFLMC;
    NSString *heTongJE = _reminderEntity.heTongJEStr;
    NSString *genZongSFJE= _reminderEntity.genZongSFJEStr;
    NSString *zhuChengXS = _reminderEntity.zhuChengXS;
    NSString *userName = _reminderEntity.userName;
    NSString *lianXiFS = _reminderEntity.lianXiFS;
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    NSString *loginName = [[ad.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
    NSString *flowId1=@"";
    NSString *fln_UserCode1=@"";
    //    NSString *nextParticipants=@"";
    //NSString *userID=@"";
    if (loginName == nil||[loginName isEqualToString:@"yushasha"]) {
        NSLog(@"%@",@"1");
        flowId1=@"FTL_T2013081300001.begin";
        fln_UserCode1=userID;
        
    }else{
        NSLog(@"%@",@"2");
        flowId1=@"FTL_T2013081300001.003";
        fln_UserCode1=@"YongHu2013092200006";
    }
    
    
    NSString *param=[NSString stringWithFormat:@"bianHao=%@&qiYeMC=%@&yeWuZLMC_cn=%@&hangYeFLMC=%@&heTongJEStr=%@&genZongSFJEStr=%@&zhuChengXS=%@&userName=%@&lianXiFS=%@&MOBILE_SID=%@",bianHao,qiYeMC,yeWuZLMC_cn,hangYeFLMC,heTongJE,genZongSFJE,zhuChengXS,userName,lianXiFS,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        GLReusableViewController *mj = [[GLReusableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}
- (IBAction)del:(id)sender {
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mRenWuSH_DGGJAction!shenHeTG.action?a=1&shenHeRQZ=YongHu00000000000"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *yeWuZLBH= _reminderEntity.yeWuZLBH;
    NSString *qiYeBH = _reminderEntity.submitID;
    NSString *qiYeMC = _reminderEntity.submitName;
    NSString *yeWuZLMC = _reminderEntity.yeWuZL;
    NSString *ftn_ID = _reminderEntity.ftn_ID;
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    NSString *loginName = [[ad.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
    NSString *flowId=@"";
    NSString *fln_UserCode=@"";
    NSString *nextParticipants=@"";
    NSString *userID=@"";
    if (loginName == nil||[loginName isEqualToString:@"yushasha"]) {
        NSLog(@"%@",@"1");
        flowId=@"FTL_T2013081300001.003";
        fln_UserCode=@"XTYH20120510007";
        nextParticipants=@"USER_2014121700012";
        userID=@"USER_2014121700012";
    }else{
        NSLog(@"%@",@"2");
        flowId=@"FTL_T2013081300001.005";
        fln_UserCode=@"YongHu2015042000001";
    }
    
    NSString *param=[NSString stringWithFormat:@"userID=%@&nextParticipants=%@&templateNode_ID=%@&fln_UserCode=%@&ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",userID,nextParticipants,flowId,fln_UserCode,ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
   if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];       
       [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}
@end
