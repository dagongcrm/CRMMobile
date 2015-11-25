//
//  editTaskViewController.m
//  CRMMobile
//
//  Created by zhang on 15/11/11.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "editTaskViewController.h"
#import "ZSYPopoverListView.h"
#import "AppDelegate.h"
#import "config.h"
#import "SubmitTableViewController.h"
#import "submitTaskEntity.h"
#import "selectListTableViewController.h"

@interface editTaskViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Label;
- (IBAction)segmentControl:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chooseHY;
- (IBAction)selectHY:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)selectQiYe:(id)sender;
- (IBAction)save:(id)sender;
@property (nonatomic, retain) NSIndexPath       *selectedIndexPath;
@property (strong,nonatomic)  NSArray           *selectUser;
@property (strong,nonatomic)  NSArray           *selectUserId;
@property (strong,nonatomic)  NSMutableArray    *selectUserForShow;
@property (strong,nonatomic)  NSMutableArray    *selectUserIdForParam;
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong,nonatomic)  IBOutlet UIButton *chooseUserButton;

@property (strong, nonatomic) NSMutableArray *uidQiYe;
@property (strong,nonatomic)  NSArray           *selectUserQiYe;
@property (strong,nonatomic)  NSArray           *selectUserIdQiYe;
@property (strong,nonatomic)  NSMutableArray    *selectUserForShowQiYe;
@property (strong,nonatomic)  NSMutableArray    *selectUserIdForParamQiYe;
@property (strong,nonatomic)  IBOutlet UIButton *chooseUserButtonQiYe;

@property (strong, nonatomic) NSString *judge;

@property (strong,nonatomic)  IBOutlet UITextField *qiYeMC;
@property (strong,nonatomic)  IBOutlet UITextField *yeWuZL;
@property (weak, nonatomic) IBOutlet UITextField *HeTongJE;
@property (weak, nonatomic) IBOutlet UITextField *GenZongSF;
@property (weak, nonatomic) IBOutlet UITextField *GenZongSFJE;

@property (weak, nonatomic) IBOutlet UITextField *LianXiFS;

@end

@implementation editTaskViewController
@synthesize roleEntity=_roleEntity;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize selectUser=_selectUser;
@synthesize selectUserId=_selectUserId;
@synthesize selectUserForShow= _selectUserForShow;
@synthesize selectUserIdForParam=_selectUserIdForParam;
@synthesize selectPicker;
//@synthesize nextArray;

@synthesize selectUserQiYe=_selectUserQiYe;
@synthesize selectUserIdQiYe=_selectUserIdQiYe;
@synthesize selectUserForShowQiYe= _selectUserForShowQiYe;
@synthesize selectUserIdForParamQiYe=_selectUserIdForParamQiYe;
@synthesize selectPickerQiYe;

- (IBAction)selectHY:(id)sender {
    _judge=@"2";
    self.selectUserForShowQiYe=[[NSMutableArray alloc] init];
    self.selectUserIdForParamQiYe=[[NSMutableArray alloc] init];
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"行业选择";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];

}

- (IBAction)cancel:(id)sender {
    SubmitTableViewController *mj = [[SubmitTableViewController alloc] init];
    [self.navigationController pushViewController:mj animated:YES];
    
}

- (IBAction)selectQiYe:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.controllerJudge  = @"editUser";
    selectListTableViewController *role = [[selectListTableViewController alloc] init];
    [self.navigationController pushViewController: role animated:true];
//    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    listView.titleName.text = @"企业选择";
//    listView.backgroundColor=[UIColor blueColor];
//    listView.datasource = self;
//    listView.delegate = self;
//    [listView show];
}


- (IBAction)selectKind:(id)sender {
    _judge=@"1";
    self.selectUserForShow=[[NSMutableArray alloc] init];
    self.selectUserIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"业务种类选择";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
    
}

- (void)viewDidLoad {
    
    NSString * title = [_roleEntity.strChoose substringWithRange:NSMakeRange(0, [_roleEntity.strChoose length] - 1)];
    NSLog(@"%@", title);
    [super viewDidLoad];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    self.suoshuHY.text = myDelegate.hangYeFLMC;
    self.hetongJE.text = myDelegate.heTongJE;
    self.genzongSFJE.text = myDelegate.genZongSFJE;
    self.lianxiFS.text =myDelegate.lianXiFS;
    NSString *yeWuZL = myDelegate.yeWuZL;
    NSString *submitName = myDelegate.submitName;
    NSLog(@"%@",yeWuZL);
    self.HeTongJE.text = myDelegate.heTongJE;
    self.GenZongSFJE.text = myDelegate.genZongSFJE;
    self.LianXiFS.text = myDelegate.lianxiFS;
    [self.chooseUserButtonQiYe setTitle:submitName forState:UIControlStateNormal];
    [self.chooseUserButton setTitle:yeWuZL forState:UIControlStateNormal];
    _judge=@"";
        [self selectUserArray];
        [self selectUserArrayQiYe];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) selectUserArray
{
    NSError *error;
    self.uidQiYe=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowUserName=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowUserId=[[NSMutableArray alloc] init];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"myeWuZLWHAction!select.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param  = [NSString stringWithFormat:@"&MOBILE_SID=%@",sid];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *nextFlow = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",nextFlow);
    NSArray *list = [nextFlow objectForKey:@"obj"];
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        NSLog(@"%@",listdic);
        [self.uid addObject:listdic];
        NSString *submitID = (NSString *)[listdic objectForKey:@"bianHao"];
        NSLog(@"%@",submitID);
        NSString *teamname = (NSString *)[listdic objectForKey:@"zhongLeiMC_cn"];
        NSLog(@"%@",teamname);
        
        [nextFlowUserName     addObject:teamname];
        [nextFlowUserId  addObject:submitID];
    }
    //    for(NSDictionary *key in nextFlow)
    //    {
    //        NSLog(@"%@",key);
    //        [nextFlowUserName   addObject:(NSString *)[key objectForKey:@"qiYeMC"]];
    //        [nextFlowUserId     addObject:(NSString *)[key objectForKey:@"bianHao"]];
    //    }
    _selectUser= [nextFlowUserName copy];
    _selectUserId=[nextFlowUserId copy];
}

-(void) selectUserArrayQiYe
{
    NSError *error;
    self.uidQiYe=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowUserNameQiYe=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowUserIdQiYe=[[NSMutableArray alloc] init];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mhangYeFLWHAction!select.action?rows=30&isLeaf=1&isVisible=11&order=asc&sort=fenLeiPX"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param  = [NSString stringWithFormat:@"&MOBILE_SID=%@",sid];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *nextFlow = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",nextFlow);
    NSArray *list = [nextFlow objectForKey:@"obj"];
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        NSLog(@"%@",listdic);
        [self.uidQiYe addObject:listdic];
        NSString *submitID = (NSString *)[listdic objectForKey:@"bianHao"];
        NSLog(@"%@",submitID);
        NSString *teamname = (NSString *)[listdic objectForKey:@"fenLeiMC"];
        NSLog(@"%@",teamname);
        
        [nextFlowUserNameQiYe     addObject:teamname];
        [nextFlowUserIdQiYe  addObject:submitID];
    }
    
    _selectUserQiYe= [nextFlowUserNameQiYe copy];
    _selectUserIdQiYe=[nextFlowUserIdQiYe copy];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSUInteger s=nil;
    if ([self.judge isEqualToString:@"1"]) {
        return [_selectUser count];
    }
    return [_selectUserQiYe count];
    
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selected = YES;
    if ([self.judge isEqualToString:@"1"]) {
        cell.textLabel.text = _selectUser[indexPath.row];
    }
    
    if ([self.judge isEqualToString:@"2"]) {
        cell.textLabel.text = _selectUserQiYe[indexPath.row];
    }
    return cell;
}

//点击添加选择的人员
- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    if ([self.judge isEqualToString:@"1"]) {
        [self.selectUserForShow    addObject:[self.selectUser   objectAtIndex:indexPath.row]];
        [self.selectUserIdForParam addObject:[self.selectUserId objectAtIndex:indexPath.row]];
    }
    if ([self.judge isEqualToString:@"2"]) {
        [self.selectUserForShowQiYe    addObject:[self.selectUserQiYe objectAtIndex:indexPath.row]];
        [self.selectUserIdForParamQiYe addObject:[self.selectUserIdQiYe objectAtIndex:indexPath.row]];
        
    }
    [self buttonInputLabel:tableView];
}
//取消选择时的操作
- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    if ([self.judge isEqualToString:@"1"]) {
        [self.selectUserForShow    addObject:[self.selectUser   objectAtIndex:indexPath.row]];
        [self.selectUserIdForParam addObject:[self.selectUserId objectAtIndex:indexPath.row]];
    }
    if ([self.judge isEqualToString:@"2"]) {
        [self.selectUserForShowQiYe    addObject:[self.selectUser   objectAtIndex:indexPath.row]];
        [self.selectUserIdForParamQiYe addObject:[self.selectUserId objectAtIndex:indexPath.row]];
        
    }
    NSLog(@"%@",self.selectUserQiYe);
    NSLog(@"%@",self.selectUser);
    [self buttonInputLabel:tableView];
}


-(void)buttonInputLabel:(ZSYPopoverListView *)tableView
{
    NSString *string =@"";
    if ([self.judge isEqualToString:@"2"]) {
        if([self.selectUserForShowQiYe count]==0){
            [tableView dismiss];
            [self.chooseHY setTitle:@"plese choose again" forState:UIControlStateNormal];
        }else{
            for (NSString *str in self.selectUserForShowQiYe)
            {
                string = [string stringByAppendingFormat:@"%@,",str];
            }
            NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
            [self.chooseHY setTitle:title forState:UIControlStateNormal];
            NSString *selectUserIdForParam =@"";
            for (NSString *ztr in self.selectUserIdForParamQiYe)
            {
                selectUserIdForParam = [selectUserIdForParam stringByAppendingFormat:@"%@,",ztr];
            }
            selectUserIdForParam = [selectUserIdForParam substringWithRange:NSMakeRange(0, [selectUserIdForParam length] - 1)];
            //AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            APPDELEGATE.options.chooseUserIDs=selectUserIdForParam;
        }
    }
    if ([self.judge isEqualToString:@"1"]) {
        if([self.selectUserForShow count]==0){
            [tableView dismiss];
            [self.chooseUserButton setTitle:@"plese choose again" forState:UIControlStateNormal];
        }else{
            for (NSString *str in self.selectUserForShow)
            {
                string = [string stringByAppendingFormat:@"%@,",str];
            }
            NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
            [self.chooseUserButton setTitle:title forState:UIControlStateNormal];
            NSString *selectUserIdForParam =@"";
            for (NSString *ztr in self.selectUserIdForParam)
            {
                selectUserIdForParam = [selectUserIdForParam stringByAppendingFormat:@"%@,",ztr];
            }
            selectUserIdForParam = [selectUserIdForParam substringWithRange:NSMakeRange(0, [selectUserIdForParam length] - 1)];
            //AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            APPDELEGATE.options.chooseUserIDs=selectUserIdForParam;
            NSLog(@"chooseUserIDs%@",APPDELEGATE.options.chooseUserIDs);
        }
    }
    
}



- (IBAction)save:(id)sender {
//    NSString *suoshuHY = self.suoshuHY.text;
    NSString *hetongJE = self.hetongJE.text;
    NSString *genzongSFJE = self.genzongSFJE.text;
    NSString *lianxiFS = self.lianxiFS.text;
    NSError *error;
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *workId = myDelegate.judgeSubmitID;
    NSLog(@"%@",workId);
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    //NSURL *URL=[NSURL URLWithString:@"http://172.16.21.49:8080/dagongcrm/mJobSubmissionAction!add.action?"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mJobSubmissionAction!edit.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *qiYeBH1  = [_roleEntity.roleIdChoose substringWithRange:NSMakeRange(0, [_roleEntity.roleIdChoose length] - 1)];
    
    NSString *yeWuZLBH=@"";
    NSString *qiYeMC = [_roleEntity.strChoose substringWithRange:NSMakeRange(0, [_roleEntity.strChoose length] - 1)];;
    NSString *yeWuZLMC=@"";
    NSString *hangYeFLMC=@"";
    NSString *hangYeBH = @"";
    for(int i=0;i<[self.selectUserForShow count];i++){
        yeWuZLBH= [self.selectUserIdForParam objectAtIndex:i];
//        qiYeBH = [self.selectUserIdForParamQiYe objectAtIndex:i];
//        qiYeMC = [self.selectUserForShowQiYe objectAtIndex:i];
        yeWuZLMC = [self.selectUserForShow objectAtIndex:i];
        
    }
    
    if (yeWuZLBH == @"") {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        yeWuZLBH = appDelegate.yeWuZLBH;
        yeWuZLMC = appDelegate.yeWuZL;
    }
    for(int i=0;i<[self.selectUserForShowQiYe count];i++){
        hangYeBH= [self.selectUserIdForParamQiYe objectAtIndex:i];
        
        hangYeFLMC = [self.selectUserForShowQiYe objectAtIndex:i];
        
    }
    
    NSString *heTongJE = self.HeTongJE.text;
    NSString *genZongSFJE = self.GenZongSFJE.text;
    NSString *lianXiFS = self.LianXiFS.text;
    
    NSString *param=[NSString stringWithFormat:@"bianHao=%@&qiYeBH=%@&qiYeMC=%@&yeWuZLBH=%@&yeWuZLMC=%@&MOBILE_SID=%@&hangYeFLBH=%@&hangYeFLMC=%@&lianxiFS=%@&genZongSFJE=%@&gezongSF=%@&heTongJE=%@",workId,qiYeBH1,qiYeMC,yeWuZLBH,yeWuZLMC,sid,hangYeBH,hangYeFLMC,lianXiFS,genZongSFJE,genZongSFJE,heTongJE];
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


- (IBAction)segmentControl:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    int x = control.selectedSegmentIndex;
    /*添加代码，对片段变化做出响应*/
    if (x == 0) {
        self.GenZongSFJE.hidden = NO;
        self.Label.hidden = NO;
    }else{
        
        self.GenZongSFJE.hidden = YES;
        self.Label.hidden = YES;
        
    }

}
@end
