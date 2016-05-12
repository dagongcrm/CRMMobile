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
@property (nonatomic,copy) NSString *templateId;

- (IBAction)quit:(id)sender;

- (IBAction)auditCommit:(id)sender;

@end

@implementation auditDetailViewController
NSString *userID;
NSString *userName;
NSString *userID1;
NSString *userName1;
- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)quit:(id)sender {
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
    NSString *fln_UserCode=@"";
    NSString *nextParticipants=@"";
    //NSString *userID=@"";
    NSString *roleId = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"roleIds"];
    NSLog(@"%@",roleId);
    if ([roleId isEqualToString:@"ROLE_2015030900001"]) {
        NSLog(@"%@",@"1");
        flowId1=@"FTL_T2013081300001.begin";
        fln_UserCode=userIDsession;
        
        NSString *param=[NSString stringWithFormat:@"userID=%@&nextParticipants=%@&templateNode_ID=%@&fln_UserCode=%@&ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",userID,nextParticipants,flowId1,fln_UserCode,ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
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
                
                if (APPDELEGATE.page!=@"") {
                    taskReminderTableViewController *tvc = [[taskReminderTableViewController alloc] init];
                    [self.navigationController pushViewController:tvc animated:YES];
                }else{
                    auditTableViewController *mj = [[auditTableViewController alloc] init];
                    [self.navigationController pushViewController:mj animated:YES];
                }
                
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }
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
            userID = (NSString *)[listdic objectForKey:@"userID"];
            userName = (NSString *)[listdic objectForKey:@"userName"];
            [self.userID addObject:userID];
            [self.userNames addObject:userName];
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

- (IBAction)auditCommit:(id)sender {
    NSError *error;
    NSString *templateNode_ID;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
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
    NSArray *list = [weatherDic objectForKey:@"obj"];
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
    UIActionSheet *sheet;
    
    sheet = [[UIActionSheet alloc] initWithTitle:@"提交给：" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:nil];
    for (int j = 0; j<[self.userID count]; j++) {
        
        NSString *a = [self.userNames objectAtIndex:j];
        [sheet addButtonWithTitle:a];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
           
            AppDelegate *ad = [[UIApplication sharedApplication] delegate];
            NSString *loginName = [[ad.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
            NSString *flowId=@"";
            NSString *fln_UserCode=userID11;
            NSString *nextParticipants=@"";
            NSString *userID=@"";
            
            flowId=@"FTL_T2013081300001.003";
//            NSString *loginName = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"loginName"];
            if ([loginName isEqualToString:@"ehongmin"]) {
                flowId=@"FTL_T2013081300001.006";
            }
            
            
            
            
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
                    
//                    if (APPDELEGATE.page!=@"") {
//                        taskReminderTableViewController *tvc = [[taskReminderTableViewController alloc] init];
//                        [self.navigationController pushViewController:tvc animated:YES];
//                    }else{
//                        auditTableViewController *mj = [[auditTableViewController alloc] init];
//                        [self.navigationController pushViewController:mj animated:YES];
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
//                    }
                    
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

@end
