//
//  ShowAndDeleteWeekViewController.m
//  CRMMobile
//
//  Created by why on 15/11/5.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "ShowAndDeleteWeekViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "WeekTableViewController.h"
@interface ShowAndDeleteWeekViewController ()
@property (strong,nonatomic)NSMutableArray *wordIdData;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *zongjie;
@property (weak, nonatomic) IBOutlet UITextField *jihua;
@property (weak, nonatomic) IBOutlet UITextField *bumen;
@property (weak, nonatomic) IBOutlet UITextField *leixing;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll1;

- (IBAction)deleteWeek:(id)sender;


@end

@implementation ShowAndDeleteWeekViewController
@synthesize weekEntity = _weekEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"周报详情";
    self.scroll1.contentSize = CGSizeMake(375, 1000);
    self.wordIdData = [[NSMutableArray alloc]init];
    self.time.text =_weekEntity.time;
    self.zongjie.text =_weekEntity.zongjie;
    self.jihua.text =_weekEntity.mingrijihua;
    self.leixing.text = _weekEntity.leixing;
    self.bumen.text = @"销售部";
    [self.time setEnabled:NO];
    [self.zongjie setEnabled:NO];
    [self.jihua setEnabled:NO];
    [self.leixing setEnabled:NO];
    [self.bumen setEnabled:NO];
    NSString *workId =_weekEntity.workID;
    [self.wordIdData addObject:workId];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //       NSLog(@"buttonIndex= %i",buttonIndex);
    if (buttonIndex==1) {
        NSError *error;
        NSString *workId = _weekEntity.workID;
        NSLog(@"ididididiid>>>%@",workId);
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
        NSLog(@"sid为--》%@", sid);
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"taskReportWAction!delete.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"workStatementActionID=%@&MOBILE_SID=%@",workId,sid];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *weekdelDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"weekdelDic字典里面的内容为--》%@", weekdelDic);
        if ([[weekdelDic objectForKey:@"success"] boolValue] == YES) {
            WeekTableViewController *weektc = [[WeekTableViewController alloc]init];            
            [self.navigationController pushViewController:weektc animated:YES];

        }
    }
}

- (IBAction)deleteWeek:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
    
}
@end
