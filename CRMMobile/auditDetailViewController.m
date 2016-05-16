//
//  auditDetailViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "auditDetailViewController.h"
#import "auditEntity.h"
#import "auditTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "taskReminderTableViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface auditDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *qiYeMC;
@property (weak, nonatomic) IBOutlet UITextField *yeWuZL;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *suoShuHY;
@property (weak, nonatomic) IBOutlet UITextField *heTongJE;
@property (weak, nonatomic) IBOutlet UITextField *genZongSFJE;
@property (weak, nonatomic) IBOutlet UITextField *zhuChengXS;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *lianXiFS;

@property (strong, nonatomic) NSMutableArray *uid;
@property (strong, nonatomic) NSMutableArray *uid1;
@property (strong, nonatomic) NSMutableArray *userID;
@property (strong, nonatomic) NSMutableArray *userNames;
@property (strong, nonatomic) NSMutableArray *userID1;
@property (strong, nonatomic) NSMutableArray *userNames1;

- (IBAction)quit:(id)sender;

- (IBAction)auditCommit:(id)sender;

@end

@implementation auditDetailViewController
NSString *userID;
NSString *userName;
NSString *userID1;
NSString *userName1;
NSString *roleId;
NSString *flowId;
NSString *sid;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    roleId = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"roleIds"];
    if ([roleId isEqualToString:@"ROLE_2015030900001"]) {
       flowId =@"FTL_T2013081300001.003";
    }else{
        [self huoquTuiH];//获取退回人
       flowId =@"FTL_T2013081300001.005";
    }
    [self huoquTiJ];//获取提交人
    NSLog(@"++++%@",roleId);
}
-(void)initUI{
    self.title=@"任务审核";
    self.scroll.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT*1.2);
    self.qiYeMC.text = _auditEntity.submitName;
    self.yeWuZL.text = _auditEntity.yeWuZL;
    self.suoShuHY.text = _auditEntity.hangYeFLMC;
    self.heTongJE.text = _auditEntity.heTongJE;
    NSLog(@"%@",_auditEntity.genZongSFJE);
    self.genZongSFJE.text = _auditEntity.genZongSFJE;
    self.zhuChengXS.text=_auditEntity.zhuChengXS;
    self.userName.text=_auditEntity.userName;
    self.lianXiFS.text = _auditEntity.lianXiFS;
    sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
}

-(void)huoquTiJ{
     NSError *error;
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mWebFlowTemplateNodeAction!candidate.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&templateNode_ID=%@",sid,flowId];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    NSLog(@"11111111%@",list);
    self.userID = [NSMutableArray new];
    self.userNames = [NSMutableArray new];
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        [self.uid addObject:listdic];
        userID = (NSString *)[listdic objectForKey:@"userID"];
        userName = (NSString *)[listdic objectForKey:@"userName"];
        [self.userID addObject:userID];
        [self.userNames addObject:userName];
    }
}

-(void)huoquTuiH{
     NSError *error;
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mWebFlowTemplateNodeAction!backUpCandidate.action?templateNode_ID=FTL_T2013081300001.002"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&ftn_ID=%@",sid,_auditEntity.ftn_ID];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    NSLog(@"11111111%@",list);
    self.userID1= [NSMutableArray new];
    self.userNames1 = [NSMutableArray new];
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        [self.uid addObject:listdic];
        userID = (NSString *)[listdic objectForKey:@"userID"];
        userName = (NSString *)[listdic objectForKey:@"userName"];
        [self.userID1 addObject:userID];
        [self.userNames1 addObject:userName];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma 退出选择
- (IBAction)quit:(id)sender {
    if([roleId isEqualToString:@"ROLE_2015030900001"]){//如果是ROLE_2015030900001
        NSError *error;
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mRenWuSH_DGGJAction!sendBack.action?step=1"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *qiYeBH = _auditEntity.submitID;
        NSString *ftn_ID = _auditEntity.ftn_ID;
        NSString *param=[NSString stringWithFormat:@"fln_UserCode=%@&bianHao=%@&renWuJBXXBH=%@&ftn_ID=%@&templateNode_ID=%@&MOBILE_SID=%@",_auditEntity.userID,qiYeBH,qiYeBH,ftn_ID,@"FTL_T2013081300001.begin",sid];
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
                    auditTableViewController *mj = [[auditTableViewController alloc] init];
                    [self.navigationController pushViewController:mj animated:YES];
                        [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }else{
        UIActionSheet *sheet;
        sheet = [[UIActionSheet alloc] initWithTitle:@"提交给：" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int j = 0; j<[self.userID1 count]; j++) {
            NSString *a = [self.userNames1 objectAtIndex:j];
            [sheet addButtonWithTitle:a];
        }
        sheet.tag = 256;
        [sheet showInView:self.view];
    }
}

#pragma 提交选择
- (IBAction)auditCommit:(id)sender {
    UIActionSheet *sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"提交给：" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:nil];
    for (int j = 0; j<[self.userID count]; j++) {
        NSString *a = [self.userNames objectAtIndex:j];
        [sheet addButtonWithTitle:a];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}

#pragma 弹框响应方法
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        return;
    }
      if (actionSheet.tag == 255) {//提交
          NSString * userID11 ;
          userID11 = [self.userID objectAtIndex:buttonIndex-1];
          NSLog(@"buttonIndex==%ld",buttonIndex);
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
          AppDelegate *ad = [[UIApplication sharedApplication] delegate];
          NSString *loginName = [[ad.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
          NSLog(@"%@",loginName);
          NSString *flowId=@"";
          NSString *fln_UserCode=userID11;
          NSString *nextParticipants=@"";
          NSString *userID=@"";
          NSString *param=[NSString stringWithFormat:@"userID=%@&nextParticipants=%@&templateNode_ID=%@&fln_UserCode=%@&ftn_ID=%@&renWuJBXXBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",userID,nextParticipants,flowId,fln_UserCode,ftn_ID,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
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
                  APPDELEGATE.paramForaudit=@"fromAuditDetail";
                  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
                  [alert show];
              }else{
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  [alert show];
              }
          }
      }else  if (actionSheet.tag == 256) {//退回
          NSString * userID12 ;
          userID12 = [self.userID1 objectAtIndex:buttonIndex-1];
          NSLog(@"%@",userID12);
          
          NSError *error;
          NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!submit.action?a=1"]];
          NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
          request.timeoutInterval=10.0;
          request.HTTPMethod=@"POST";
          NSString *qiYeBH = _auditEntity.submitID;
          NSString *ftn_ID = _auditEntity.ftn_ID;
          NSString *fln_UserCode=userID12;
          NSString *param=[NSString stringWithFormat:@"fln_UserCode=%@&ftn_ID=%@&templateNode_ID=%@&renWuJBXXBH=%@&bianHao=%@&MOBILE_SID=%@",fln_UserCode,ftn_ID,@"FTL_T2013081300001.002",qiYeBH,qiYeBH,sid];
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
                  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
                  [alert show];
              }else{
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  [alert show];
              }
          }
      }
    }
@end
