//
//  ShowAndDeleteViewController.m
//  CRMMobile
//
//  Created by why on 15/11/5.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "ShowAndDeleteViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "MonthTableViewController.h"
@interface ShowAndDeleteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *date;
//@property (weak, nonatomic) IBOutlet UITextField *zongjie;
//@property (weak, nonatomic) IBOutlet UITextField *jihua;
@property (weak, nonatomic) IBOutlet UITextView *zongjie;
@property (weak, nonatomic) IBOutlet UITextView *jihua;

@property (weak, nonatomic) IBOutlet UITextField *bumen;
@property (weak, nonatomic) IBOutlet UITextField *leixing;
@property (strong ,nonatomic)NSMutableArray *wordIdData;
- (IBAction)deleteMonth:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@end

@implementation ShowAndDeleteViewController

@synthesize monthEntity = _monthEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"月报详情";
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
    self.date.text =_monthEntity.time;
    self.zongjie.text =_monthEntity.zongjie;
    self.jihua.text =_monthEntity.mingrijihua;
    self.leixing.text = _monthEntity.leixing;
    self.bumen.text = @"销售部";
    [self.date setEnabled:NO];
//    [self.zongjie setEnabled:NO];
//    [self.jihua setEnabled:NO];
    [self.leixing setEnabled:NO];
    [self.bumen setEnabled:NO];
    NSString *workId =_monthEntity.workID;
    [self.wordIdData addObject:workId];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //       NSLog(@"buttonIndex= %i",buttonIndex);
    if (buttonIndex==1) {
        NSError *error;
        NSString *workId = _monthEntity.workID;
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
        NSDictionary *monthdelDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"monthdelDic字典里面的内容为--》%@", monthdelDic);
        if ([[monthdelDic objectForKey:@"success"] boolValue] == YES) {
            MonthTableViewController *monthtc = [[MonthTableViewController alloc]init];
            [self.navigationController pushViewController:monthtc animated:YES];
            
        }
    }
}
- (IBAction)deleteMonth:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示信息" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
@end
