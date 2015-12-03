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
- (IBAction)goback:(id)sender;
- (IBAction)del:(id)sender;
@property (strong,nonatomic)NSMutableArray *listData;
@end

@implementation ReminderDetailViewController
@synthesize reminderEntity = _reminderEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroll.contentSize = CGSizeMake(375, 1100);

    self.title=@"任务审核";
    self.qiYeMC.text = _auditEntity.submitName;
    self.yeWuZL.text = _auditEntity.yeWuZL;
    self.hangYeFLMC.text = _auditEntity.hangYeFLMC;
    self.heTongJE.text = _auditEntity.heTongJE;
    NSLog(@"%@",_auditEntity.genZongSFJE);
    self.genZongSFJE.text = _auditEntity.genZongSFJE;
    self.zhuChengXS.text=_auditEntity.zhuChengXS;
    self.userName.text=_auditEntity.userName;
    self.lianXiFS.text = _auditEntity.lianXiFS;
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    
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
    NSLog(@"%@",qiYeBH);
    NSLog(@"%@",qiYeMC);
    NSLog(@"%@",yeWuZLBH);
    NSLog(@"%@",yeWuZLMC);
    NSLog(@"%@",ftn_ID);
    
    
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
    NSString *userID = _auditEntity.userID;
    NSLog(@"userID%@",userID);
    NSLog(@"%@",qiYeBH);
    NSLog(@"%@",qiYeMC);
    NSLog(@"%@",yeWuZLBH);
    NSLog(@"%@",yeWuZLMC);
    NSLog(@"%@",ftn_ID);
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
    
    
    NSString *param=[NSString stringWithFormat:@"userID=%@&nextParticipants=%@&templateNode_ID=%@&fln_UserCode=%@&ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",userID,nextParticipants,flowId1,fln_UserCode1,ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        if (APPDELEGATE.page!=@"") {
            GLReusableViewController *tvc = [[GLReusableViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
        }else{
            ReminderTableViewController *mj = [[ReminderTableViewController alloc] init];
            [self.navigationController pushViewController:mj animated:YES];
        }
        
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
    NSString *fln_UserCode=@"";
    NSString *nextParticipants=@"";
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
        
        if (APPDELEGATE.page!=@"") {
            GLReusableViewController *tvc = [[GLReusableViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
        }else{
            ReminderTableViewController *mj = [[ReminderTableViewController alloc] init];
            [self.navigationController pushViewController:mj animated:YES];
        }
        
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}
@end
