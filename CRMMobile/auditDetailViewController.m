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

@interface auditDetailViewController ()
- (IBAction)quit:(id)sender;

- (IBAction)auditCommit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *qiYeMC;
@property (weak, nonatomic) IBOutlet UITextField *yeWuZL;
@end

@implementation auditDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *s= _auditEntity.submitName;
    NSString *y= _auditEntity.yeWuZL;
    self.qiYeMC.text = _auditEntity.submitName;
    self.yeWuZL.text = _auditEntity.yeWuZL;
    NSLog(@"s%@",s);
    
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
    NSLog(@"%@",qiYeBH);
    NSLog(@"%@",qiYeMC);
    NSLog(@"%@",yeWuZLBH);
    NSLog(@"%@",yeWuZLMC);
    NSLog(@"%@",ftn_ID);
    
    
        NSString *param=[NSString stringWithFormat:@"ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
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
        auditTableViewController *mj = [[auditTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}

- (IBAction)auditCommit:(id)sender {
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
        auditTableViewController *mj = [[auditTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }

}
@end
