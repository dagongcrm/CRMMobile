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


@end

@implementation submitTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"任务基本信息";
    self.scroll.contentSize = CGSizeMake(375, 1000);
    NSString *s= _submitTaskEntity.submitName;
    NSString *y= _submitTaskEntity.yeWuZL;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger *)buttonIndex{
           NSLog(@"buttonIndex= %i",buttonIndex);
    if (buttonIndex==1) {
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
            SubmitTableViewController *dailytv = [[SubmitTableViewController alloc]init];
            [self.navigationController pushViewController:dailytv animated:YES];
        }
    }
}

- (IBAction)edit:(id)sender {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.judgeSubmitID = _submitTaskEntity.submitID;
    myDelegate.submitName = _submitTaskEntity.submitName;
    myDelegate.yeWuZLBH = _submitTaskEntity.yeWuZLBH;
    myDelegate.yeWuZL =_submitTaskEntity.yeWuZL;
    editTaskViewController *la = [[editTaskViewController alloc] init];
    [self.navigationController pushViewController:la animated:YES];
}

- (IBAction)Commit:(id)sender {
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!submit.action?a=1&userID=USER_2015032500068&nextParticipants=USER_2015032500068&fln_UserCode=YongHu2013092200006&templateNode_ID=FTL_T2013081300001.002"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *yeWuZLBH= _submitTaskEntity.yeWuZLBH;
    NSString *qiYeBH = _submitTaskEntity.submitID;
    NSString *qiYeMC = _submitTaskEntity.submitName;
    NSString *yeWuZLMC = _submitTaskEntity.yeWuZL;
    NSString *ftn_ID = _submitTaskEntity.ftn_ID;
    NSLog(@"%@",qiYeBH);
    NSLog(@"%@",qiYeMC);
    NSLog(@"%@",yeWuZLBH);
    NSLog(@"%@",yeWuZLMC);
    NSLog(@"%@",ftn_ID);
        
   
    NSString *param=[NSString stringWithFormat:@"ftn_ID=%@&renWuJBXXBH=%@&bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@",ftn_ID,qiYeBH,qiYeBH,qiYeBH,qiYeMC,yeWuZLBH,yeWuZLMC,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        SubmitTableViewController *mj = [[SubmitTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }

}
@end
