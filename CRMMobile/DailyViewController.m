//
//  DailyViewController.m
//  CRMMobile
//
//  Created by why on 15/11/2.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "DailyViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "DailyTableViewController.h"

@interface DailyViewController ()
@property (strong,nonatomic)NSMutableArray *wordIdData;
@property (weak, nonatomic) IBOutlet UITextField *time;//riqi
//@property (weak, nonatomic) IBOutlet UITextField *zongjie;//zongjie
//@property (weak, nonatomic) IBOutlet UITextField *jihua;//jihua

@property (weak, nonatomic) IBOutlet UITextView *zongjie;

@property (weak, nonatomic) IBOutlet UITextView *jihua;

@property (weak, nonatomic) IBOutlet UITextField *bumen;//bumen
@property (weak, nonatomic) IBOutlet UITextField *leixing;
- (IBAction)deleteReport:(id)sender;//shangchubaogao
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation DailyViewController
@synthesize DailyEntity=_dailyEntity;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"日报详情";
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    [self.jihua.layer setBorderColor:color];
    self.jihua.layer.borderWidth = 1;
    self.jihua.layer.cornerRadius = 6;
    self.jihua.layer.masksToBounds = YES;
      self.jihua.editable = NO;
    [self.zongjie.layer setBorderColor:color];
    self.zongjie.layer.borderWidth = 1;
    self.zongjie.layer.cornerRadius = 6;
    self.zongjie.layer.masksToBounds = YES;
       self.zongjie.editable = NO;
    
    self.scroll.contentSize = CGSizeMake(375, 700);
    self.wordIdData = [[NSMutableArray alloc]init];
    self.time.text =_dailyEntity.time;
    self.zongjie.text =_dailyEntity.zongjie;
    self.jihua.text =_dailyEntity.mingrijihua;
    self.leixing.text = _dailyEntity.leixing;
    self.bumen.text = @"销售部";
    [self.time setEnabled:NO];
//    [self.zongjie setEnabled:NO];
//    [self.jihua setEnabled:NO];
    [self.leixing setEnabled:NO];
    [self.bumen setEnabled:NO];
    NSString *workId =_dailyEntity.workID;
    [self.wordIdData addObject:workId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)deleteReport:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//       NSLog(@"buttonIndex= %i",buttonIndex);
    if (buttonIndex==1) {
                NSError *error;
                NSString *workId = _dailyEntity.workID;
        NSLog(@"ididididiid>>>%@",workId);
                NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
                NSLog(@"sid为--》%@", sid);
                NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"taskReportAction!delete.action?"]];
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
                request.timeoutInterval=10.0;
                request.HTTPMethod=@"POST";
                NSString *param=[NSString stringWithFormat:@"workStatementActionID=%@&MOBILE_SID=%@",workId,sid];
                request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
                NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                NSDictionary *dailyDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                NSLog(@"dailyDic字典里面的内容为--》%@", dailyDic);
            if ([[dailyDic objectForKey:@"success"] boolValue] == YES) {
                DailyTableViewController *dailytv = [[DailyTableViewController alloc]init];
                [self.navigationController pushViewController:dailytv animated:YES];
                }
            }
}
@end
