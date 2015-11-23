//
//  ReminderDetailViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/16.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "ReminderTableViewController.h"
#import "ReminderDetailViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "ReminderEntity.h"
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
    self.title=@"任务审核";
    self.scroll.contentSize = CGSizeMake(375, 1050);
    self.listData = [[NSMutableArray alloc]init];
    
    self.qiYeMC.text = _reminderEntity.qiYeMC;
    self.yeWuZL.text = _reminderEntity.yeWuZLMC_cn;
    self.hangYeFLMC.text = _reminderEntity.hangYeFLMC;
    self.heTongJE.text = _reminderEntity.heTongJEStr;
    self.genZongSFJE.text = _reminderEntity.genZongSFJEStr;
    self.zhuChengXS.text = _reminderEntity.zhuChengXS;
    self.userName.text = @"于莎莎";
    self.lianXiFS.text = _reminderEntity.lianXiFS;
  
    NSString *reminders =_reminderEntity.bianHao;
    [self.listData addObject:reminders];
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
    NSLog(@"%@",loginName);
    NSString *flowId1=@"";
    NSString *fln_UserCode1=@"";
    NSString *nextParticipants=@"";
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
        ReminderTableViewController *mj = [[ReminderTableViewController alloc] init];
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
    NSLog(@"%@",loginName);
    NSString *flowId=@"";
    NSString *fln_UserCode=@"";
    NSString *nextParticipants=@"";
//    NSString *userID=@"";
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
    
    
    NSString *param=[NSString stringWithFormat:@"bianHao=%@&qiYeMC=%@&yeWuZLMC_cn=%@&hangYeFLMC=%@&heTongJEStr=%@&genZongSFJEStr=%@&zhuChengXS=%@&userName=%@&lianXiFS=%@&MOBILE_SID=%@",bianHao,qiYeMC,yeWuZLMC_cn,hangYeFLMC,heTongJE,genZongSFJE,zhuChengXS,userName,lianXiFS,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        ReminderTableViewController *mj = [[ReminderTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}
@end
