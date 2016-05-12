//
//  submitTaskDetailViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/4.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "submitTaskDetailViewController.h"
#import "ZSYPopoverListView.h"
#import "AppDelegate.h"
#import "SubmitTableViewController.h"
#import "config.h"
#import "editTaskViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface submitTaskDetailViewController ()
- (IBAction)delete:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)Commit:(id)sender;
- (IBAction)selectKind:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *qiYeMC1;//企业名称
@property (weak, nonatomic) IBOutlet UITextField *yeWuZL;//业务种类
@property (strong,nonatomic)  IBOutlet UITextField *qiYeBH;
@property (strong,nonatomic)  IBOutlet UITextField *yeWuZLBH;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *suosuhy;//所属行业
@property (weak, nonatomic) IBOutlet UITextField *hetongje;//合同金额
@property (weak, nonatomic) IBOutlet UITextField *genzongshoufeije;//跟踪收费金额
@property (weak, nonatomic) IBOutlet UITextField *zhuchengxc;//主承销商
@property (weak, nonatomic) IBOutlet UITextField *lianxifs;//联系方式
@property (weak, nonatomic) IBOutlet UITextField *yewucbr;//业务承办人
@property (strong,nonatomic) NSMutableArray *listName;//
@property (strong,nonatomic) NSMutableArray *listId;//

@end

@implementation submitTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"任务基本信息";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""                                                                     style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    self.scroll.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    self.qiYeMC1.text = _submitTaskEntity.submitName;
    self.yeWuZL.text = _submitTaskEntity.yeWuZL;
    self.suosuhy.text = _submitTaskEntity.hangYeFLMC;
    self.hetongje.text=_submitTaskEntity.heTongJE;
    self.genzongshoufeije.text=_submitTaskEntity.genZongSFJE;
    self.zhuchengxc.text=_submitTaskEntity.zhuChengXS;
    self.lianxifs.text=_submitTaskEntity.lianXiFS;
    self.yewucbr.text=_submitTaskEntity.userName;
    [self.qiYeMC1 setEnabled:NO];
    [self.yeWuZL setEnabled:NO];
    [self.suosuhy setEnabled:NO];
    [self.hetongje setEnabled:NO];
    [self.genzongshoufeije setEnabled:NO];
    [self.zhuchengxc setEnabled:NO];
    [self.lianxifs setEnabled:NO];
    [self.yewucbr setEnabled:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag=255;
    [alertView show];
}

- (IBAction)edit:(id)sender {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.judgeSubmitID = _submitTaskEntity.submitID;
    myDelegate.submitName = _submitTaskEntity.submitName;
    myDelegate.yeWuZLBH = _submitTaskEntity.yeWuZLBH;
    myDelegate.yeWuZL =_submitTaskEntity.yeWuZL;
    myDelegate.hangYeFLBH = _submitTaskEntity.hangYeFLBH;
    myDelegate.hangYeFLMC = _submitTaskEntity.hangYeFLMC;
    myDelegate.heTongJE = _submitTaskEntity.heTongJE;
    myDelegate.gezongSF = _submitTaskEntity.genZongSF;
    myDelegate.genZongSFJE = _submitTaskEntity.genZongSFJE;
    myDelegate.lianxiFS = _submitTaskEntity.lianXiFS;
    editTaskViewController *la = [[editTaskViewController alloc] init];
    [self.navigationController pushViewController:la animated:YES];
}

- (IBAction)Commit:(id)sender {
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mWebFlowTemplateNodeAction!candidate.action?templateNode_ID=FTL_T2013081300001.002"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@",sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    NSArray *list = [weatherDic objectForKey:@"obj"];
    //    NSMutableArray *list = [weatherDic mutableCopy];
    NSLog(@"11111111%@",list);
    NSString *userID;
    NSString *userName;
//    NSString *userID1;
//    NSString *userName1;
   self.listName = [[NSMutableArray alloc]init];
    self.listId = [[NSMutableArray alloc]init];
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
//        NSDictionary *listdic1 = [list objectAtIndex:1];
        //        [self.uid addObject:listdic];
        //        [self.uid1 addObject:listdic1];
        userID = (NSString *)[listdic objectForKey:@"userID"];
        userName = (NSString *)[listdic objectForKey:@"userName"];
        [self.listName addObject:userName];
        [self.listId addObject:userID];
//        userID1 = (NSString *)[listdic1 objectForKey:@"userID"];
//        userName1 = (NSString *)[listdic1 objectForKey:@"userName"];
        //        [self.userID addObject:userID];
        //        [self.userNames addObject:userName];
    }
    UIActionSheet *sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"提交给：" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:nil];
    for (int j = 0; j<[self.listName count]; j++) {
        NSString *a = [self.listName objectAtIndex:j];
        [sheet addButtonWithTitle:a];
    }
    sheet.tag = 260;
    [sheet showInView:self.view];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger *)buttonIndex{
    NSLog(@"buttonIndex= %i",buttonIndex);
    if (buttonIndex==1 && alertView.tag==255) {
        NSError *error;
        NSString *workId = _submitTaskEntity.submitID;
        NSLog(@"ididididiid>>>%@",workId);
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
        NSLog(@"sid为--》%@", sid);
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!delete.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"ids=%@&MOBILE_SID=%@",workId,sid];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"dailyDic字典里面的内容为--》%@", dailyDic);
        if ([[dailyDic objectForKey:@"success"] boolValue] == YES) {
//            SubmitTableViewController *dailytv = [[SubmitTableViewController alloc]init];
//            [self.navigationController pushViewController:dailytv animated:YES];
             [self.navigationController popViewControllerAnimated:YES];
        }
}
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        
        NSLog(@"mmmmmmklklklklkl%lu",buttonIndex);
        NSString * userID123 ;
        if (actionSheet.tag == 260) {
            if (buttonIndex>0) {
                userID123 = [self.listId objectAtIndex:buttonIndex-1];
               NSLog(@"userID123==>>",userID123);
                NSError *error;
                AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
                NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
            
                NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!submit.action?a=1&userID=USER_2015032500068&nextParticipants=USER_2015032500068&templateNode_ID=FTL_T2013081300001.002"]];
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
                request.timeoutInterval=10.0;
                request.HTTPMethod=@"POST";
            
                NSString *yeWuZLBH= _submitTaskEntity.yeWuZLBH;
                NSString *qiYeBH = _submitTaskEntity.submitID;
                NSString *qiYeMC = _submitTaskEntity.submitName;
                NSString *yeWuZLMC = _submitTaskEntity.yeWuZL;
                NSString *ftn_ID = _submitTaskEntity.ftn_ID;
                NSString *hangYeFLMC = _submitTaskEntity.hangYeFLMC;
                NSLog(@"%@",qiYeBH);
                NSLog(@"%@",qiYeMC);
                NSLog(@"%@",yeWuZLBH);
                NSLog(@"%@",yeWuZLMC);
                NSLog(@"%@",ftn_ID);
                NSLog(@"hangYeFLMC%@",hangYeFLMC);
            
                NSString *param=[NSString stringWithFormat:@"ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@&fln_UserCode=%@",ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid,userID123];
                request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
                NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            
                if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                    SubmitTableViewController *mj = [[SubmitTableViewController alloc] init];
//                    [self.navigationController pushViewController:mj animated:YES];
//                    [CATransaction begin];
//                    [CATransaction setCompletionBlock:^{
//                        [mj CAReload];
//                     }];
                    APPDELEGATE.customerForAddSaleLead=@"fromSubmit";
                     [self.navigationController popViewControllerAnimated:YES];
//                     [CATransaction commit];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
            
        }else{
            return;
        }
        }else{
            return;
        }
    }
@end
