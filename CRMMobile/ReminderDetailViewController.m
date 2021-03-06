//
//  ReminderDetailViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/16.
//  Copyright (c) 2015年 dagong. All rights reserved.
//
#import "auditEntity.h"
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

@property (strong, nonatomic) NSMutableArray *uid;
@property (strong, nonatomic) NSMutableArray *uid1;
@property (strong, nonatomic) NSMutableArray *userID;
@property (strong, nonatomic) NSMutableArray *userNames;

- (IBAction)goback:(id)sender;
- (IBAction)del:(id)sender;
@property (strong,nonatomic)NSMutableArray *listData;
@end

@implementation ReminderDetailViewController
NSString *userID111;
NSString *userName111;
@synthesize reminderEntity = _reminderEntity;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroll.contentSize = CGSizeMake(375, 700);
    
    self.title=@"任务审核";
    self.qiYeMC.text = _auditEntity.submitName;
    self.yeWuZL.text = _auditEntity.yeWuZL;
    self.hangYeFLMC.text = _auditEntity.hangYeFLMC;
    self.heTongJE.text = _auditEntity.heTongJE;
    self.genZongSFJE.text = _auditEntity.genZongSFJE;
    self.zhuChengXS.text=_auditEntity.zhuChengXS;
    self.userName.text=_auditEntity.userName;
    self.lianXiFS.text = _auditEntity.lianXiFS;
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mRenWuSH_DGGJAction!renWuSH_DGGJForm1.action?flag=2&step=1"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *yeWuZLBH= _auditEntity.yeWuZLBH;
    NSString *qiYeBH = _auditEntity.submitID;
    NSString *qiYeMC = _auditEntity.submitName;
    NSString *yeWuZLMC = _auditEntity.yeWuZL;
    NSString *ftn_ID = _auditEntity.ftn_ID;
    
    NSString *hangYeFLMC = _auditEntity.hangYeFLMC;
    NSString *heTongJE = _auditEntity.heTongJE;
    NSString *genZongSFJE = _auditEntity.genZongSFJE;
    NSString *zhuChengXS= _auditEntity.zhuChengXS;
    NSString *userName = _auditEntity.userName;
    NSString *lianXiFS = _auditEntity.lianXiFS;
    
    
    NSString *param=[NSString stringWithFormat:@"ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@&hangYeFLMC=%@&heTongJE=%@&genZongSFJE=%@&zhuChengXS=%@&userName=%@&lianXiFS=%@",ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid,hangYeFLMC,heTongJE,genZongSFJE,zhuChengXS,userName,lianXiFS];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    // Do any additional setup after loading the view from its nib.
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
    
    NSString *yeWuZLBH= _auditEntity.yeWuZLBH;
    NSString *qiYeBH = _auditEntity.submitID;
    NSString *qiYeMC = _auditEntity.submitName;
    NSString *yeWuZLMC = _auditEntity.yeWuZL;
    NSString *ftn_ID = _auditEntity.ftn_ID;
    NSString *userIDsession = _auditEntity.userID;
    NSLog(@"userID%@",userIDsession);
    NSLog(@"%@",qiYeBH);
    NSLog(@"%@",qiYeMC);
    NSLog(@"%@",yeWuZLBH);
    NSLog(@"%@",yeWuZLMC);
    NSLog(@"%@",ftn_ID);
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    NSString *loginName = [[ad.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
    NSLog(@"%@",loginName);
    NSString *flowId1=@"";
    NSString *fln_UserCode=@"";
    NSString *nextParticipants=@"";
    //NSString *userID=@"";
    NSString *roleId = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"roleIds"];
    NSLog(@"%@",roleId);
    if ([roleId isEqualToString:@"ROLE_2015030900001"]) {
        NSLog(@"%@",@"1");
        flowId1=@"FTL_T2013081300001.begin";
        fln_UserCode=userIDsession;
        
        NSString *param=[NSString stringWithFormat:@"userID=%@&nextParticipants=%@&templateNode_ID=%@&fln_UserCode=%@&ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",userIDsession,nextParticipants,flowId1,fln_UserCode,ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
            NSLog(@"--------%@",error);
        }else{
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            
            if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }        }
    }else{
        NSString *templateNode_ID;
        NSLog(@"%@",@"2");
        
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mWebFlowTemplateNodeAction!backUpCandidate.action?templateNode_ID=FTL_T2013081300001.002"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&ftn_ID=%@",sid,ftn_ID];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",weatherDic);
        NSArray *list = [weatherDic objectForKey:@"obj"];
        //    NSMutableArray *list = [weatherDic mutableCopy];
        NSLog(@"11111111%@",list);
        self.userID = [NSMutableArray new];
        self.userNames = [NSMutableArray new];
        for (int i = 0; i<[list count]; i++) {
            NSDictionary *listdic = [list objectAtIndex:i];
            [self.uid addObject:listdic];
            userID111 = (NSString *)[listdic objectForKey:@"userID"];
            userName111 = (NSString *)[listdic objectForKey:@"userName"];
            [self.userID addObject:userID111];
            [self.userNames addObject:userName111];
        }
        UIActionSheet *sheet;
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"提交给：" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int j = 0; j<[self.userID count]; j++) {
            
            NSString *a = [self.userNames objectAtIndex:j];
            [sheet addButtonWithTitle:a];
        }
        
        sheet.tag = 255;
        [sheet showInView:self.view];
        
        //        flowId1=@"FTL_T2013081300001.003";
        //        fln_UserCode1=@"YongHu2013092200006";
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSError *error;
        NSString *templateNode_ID;
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
        NSString *roleId = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"roleIds"];
        if ([roleId isEqualToString:@"ROLE_2015030900001"]) {
            templateNode_ID=@"FTL_T2013081300001.003";
        }else{
            templateNode_ID=@"FTL_T2013081300001.005";
        }
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mWebFlowTemplateNodeAction!candidate.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&templateNode_ID=%@",sid,templateNode_ID];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",weatherDic);
        NSArray *list = [weatherDic objectForKey:@"obj"];
        //    NSMutableArray *list = [weatherDic mutableCopy];
        NSLog(@"11111111%@",list);
        self.userID = [NSMutableArray new];
        self.userNames = [NSMutableArray new];
        for (int i = 0; i<[list count]; i++) {
            NSDictionary *listdic = [list objectAtIndex:i];
            [self.uid addObject:listdic];
            userID111 = (NSString *)[listdic objectForKey:@"userID"];
            userName111 = (NSString *)[listdic objectForKey:@"userName"];
            [self.userID addObject:userID111];
            [self.userNames addObject:userName111];
        }
        UIActionSheet *sheet;
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"提交给：" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int j = 0; j<[self.userID count]; j++) {
            
            NSString *a = [self.userNames objectAtIndex:j];
            [sheet addButtonWithTitle:a];
        }
        
        sheet.tag = 255;
        [sheet showInView:self.view];

//        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mRenWuSH_DGGJAction!shenHeTG.action?a=1&shenHeRQZ=YongHu00000000000"]];
//        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//        request.timeoutInterval=10.0;
//        request.HTTPMethod=@"POST";
//        
//        NSString *yeWuZLBH= _auditEntity.yeWuZLBH;
//        NSString *qiYeBH = _auditEntity.submitID;
//        NSString *qiYeMC = _auditEntity.submitName;
//        NSString *yeWuZLMC = _auditEntity.yeWuZL;
//        NSString *ftn_ID = _auditEntity.ftn_ID;
//        NSString*userID=_auditEntity.userID;
//        NSLog(@"%@",qiYeBH);
//        NSLog(@"%@",qiYeMC);
//        NSLog(@"%@",yeWuZLBH);
//        NSLog(@"%@",yeWuZLMC);
//        NSLog(@"%@",ftn_ID);
//        AppDelegate *ad = [[UIApplication sharedApplication] delegate];
//        NSString *loginName = [[ad.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
//        NSLog(@"%@",loginName);
//        NSString *flowId=@"";
//        NSString *fln_UserCode=@"";
//        NSString *nextParticipants=@"";
//        if (loginName == nil||[loginName isEqualToString:@"yushasha"]) {
//            NSLog(@"%@",@"1");
//            flowId=@"FTL_T2013081300001.003";
//            fln_UserCode=@"XTYH20120510007";
//            nextParticipants=@"USER_2014121700012";
//            userID=@"USER_2014121700012";
//        }else{
//            NSLog(@"%@",@"2");
//            flowId=@"FTL_T2013081300001.005";
//            fln_UserCode=@"YongHu2015042000001";
//        }
//        
//        
//        NSString *param=[NSString stringWithFormat:@"userID=%@&nextParticipants=%@&templateNode_ID=%@&fln_UserCode=%@&ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",userID,nextParticipants,flowId,fln_UserCode,ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
//        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//        if (error) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
//            [alert show];
//            NSLog(@"--------%@",error);
//        }else{
//
//        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        
//        if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];
//            [alert show];
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        }
    }
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"mmmmmmklklklklkl%lu",buttonIndex);
    if (actionSheet.tag == 255) {
        NSString * userID11 ;
        if (buttonIndex) {
            userID11 = [self.userID objectAtIndex:buttonIndex-1];
            NSLog(@"%@",userID11);
            NSError *error;
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
            
            NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mRenWuSH_DGGJAction!shenHeTG.action?a=1&shenHeRQZ=YongHu00000000000"]];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
            request.timeoutInterval=10.0;
            request.HTTPMethod=@"POST";
            
            NSString *yeWuZLBH= _auditEntity.yeWuZLBH;
            NSString *qiYeBH = _auditEntity.submitID;
            NSString *qiYeMC = _auditEntity.submitName;
            NSString *yeWuZLMC = _auditEntity.yeWuZL;
            NSString *ftn_ID = _auditEntity.ftn_ID;
            NSLog(@"%@",qiYeBH);
            NSLog(@"%@",qiYeMC);
            NSLog(@"%@",yeWuZLBH);
            NSLog(@"%@",yeWuZLMC);
            NSLog(@"%@",ftn_ID);
            AppDelegate *ad = [[UIApplication sharedApplication] delegate];
            NSString *loginName = [[ad.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
            NSLog(@"%@",loginName);
            NSString *flowId=@"";
            NSString *fln_UserCode=userID11;
            NSString *nextParticipants=@"";
            NSString *userID=@"";
            
            flowId=@"FTL_T2013081300001.003";
            
            
            NSString *param=[NSString stringWithFormat:@"userID=%@&nextParticipants=%@&templateNode_ID=%@&fln_UserCode=%@&ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",userID,nextParticipants,flowId,fln_UserCode,ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
            request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
                [alert show];
                NSLog(@"--------%@",error);
            }else{
                NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                
                if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];
                                [alert show];
                            }else{
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                            }
            }
            
        }else {
            return;
        }
        
    }
}

- (IBAction)del:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否审核？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
@end
