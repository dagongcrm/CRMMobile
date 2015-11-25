//
//  EditPlanViewController.m
//  CRMMobile
//
//  Created by peng on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//
#import "ZSYPopoverListView.h"
#import "CustomerTableViewController.h"
#import "PlanDetalViewController.h"
#import "CustomerContactListViewController.h"
#import "VisitPlanTableViewController.h"
#import "EditPlanViewController.h"
#import "AppDelegate.h"
#import "config.h"
@interface EditPlanViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextField *visitDate;
@property (weak, nonatomic) IBOutlet UITextField *theme;
@property (weak, nonatomic) IBOutlet UITextField *accessMethod;
@property (weak, nonatomic) IBOutlet UITextField *mainContent;
@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;
@property (weak, nonatomic) IBOutlet UITextField *respondent;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *visitProfile;
@property (weak, nonatomic) IBOutlet UITextField *result;
@property (weak, nonatomic) IBOutlet UITextField *customerRequirements;

@property (weak, nonatomic) IBOutlet UITextField *customerChange;
@property (weak, nonatomic) IBOutlet UITextField *visitorStr;
@property (nonatomic, retain) NSIndexPath       *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *access;


- (IBAction)save:(id)sender;
- (IBAction)customerName:(id)sender;
- (IBAction)goback:(id)sender;

@property (strong,nonatomic) NSString  *accessMethodID;//选择的拜访方式ID 用于提交
@property (strong, nonatomic) NSMutableArray *uid;
//@property (nonatomic, retain) NSIndexPath       *selectedIndexPath;
@property (strong,nonatomic)  NSArray           *selectBFFS;  //选择的 拜访方式名称
@property (strong,nonatomic)  NSArray           *selectBFFSId; //选择的 拜访方式ID
@property (strong,nonatomic)  NSMutableArray    *selectBFFSForShow; // 拜访方式
@property (strong,nonatomic)  NSMutableArray    *selectBFFSIdForParam;//拜访方式编号
@property (strong,nonatomic)NSMutableArray *listData;
@end

@implementation EditPlanViewController
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize DailyEntity=_dailyEntity;
@synthesize addCustomerEntity = _addCustomerEntity;
@synthesize nextArray;
@synthesize selectPicker;
//@synthesize selectedIndexPath = _selectedIndexPath;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改信息";
    //设置导航栏返回
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置返回键的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.scroll.contentSize = CGSizeMake(375, 1300);
//    self.listData = [[NSMutableArray alloc]init];
    self.customerNameStr.text =_dailyEntity.customerNameStr;
    self.visitDate.text =_dailyEntity.visitDate;
    self.theme.text =_dailyEntity.theme;
    self.accessMethod.text =_dailyEntity.accessMethod;
    self.mainContent.text =_dailyEntity.mainContent;
    self.respondentPhone.text =_dailyEntity.respondentPhone;
    self.respondent.text =_dailyEntity.respondent;
    self.address.text =_dailyEntity.address;
    self.visitProfile.text =_dailyEntity.visitProfile;
    self.result.text =_dailyEntity.result;
    self.customerRequirements.text =_dailyEntity.customerRequirements;
    self.customerChange.text =_dailyEntity.customerChange;
    self.visitorStr.text =_dailyEntity.visitorStr;
    if (_dailyEntity.customerNameStr.length==0) {
        self.customerNameStr.text=_dailyEntity.customerNameStr;
    }else{
        self.customerNameStr.text=_dailyEntity.customerNameStr;
    }
//    NSString *customerCallPlanIDs =_dailyEntity.customerCallPlanID;
//    [self.listData addObject:customerCallPlanIDs];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)save:(id)sender {
        NSString *c1=self.customerNameStr.text;
        NSString *c2=self.visitDate.text;
        NSString *c3=self.theme.text;
        NSString *c4=self.accessMethod.text;
        NSString *c5=self.mainContent.text;
        NSString *c6=self.respondentPhone.text;
        NSString *c7=self.respondent.text;
        NSString *c8=self.address.text;
        NSString *c9=self.visitProfile.text;
        NSString *c10=self.result.text;
        NSString *c11=self.customerRequirements.text;
        NSString *c12=self.customerChange.text;
        NSString *c13=self.visitorStr.text;
        NSString *customerCallPlanID =_dailyEntity.customerCallPlanID;
     NSLog(@"//////////////c1%@",c1);
     NSLog(@"c2%@",c2);
    NSLog(@"c3%@",c3);
    NSLog(@"c4%@",c4);
    NSLog(@"c5%@",c5);
    NSLog(@"c6%@",c6);
    NSLog(@"c7%@",c7);
    NSLog(@"c8%@",c8);
    if (c1.length==0||c2.length==0||c3.length==0||c4.length==0||c5.length==0||c6.length==0||c7.length==0||c8.length==0||c9.length==0||c10.length==0||c11.length==0||c12.length==0||c13.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"文本框输入框不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else{
        NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
        NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!edit.action?"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
         NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerCallPlanID=%@&customerName=%@&visitDate=%@&theme=%@&accessMethod=%@&mainContent=%@&respondentPhone=%@&respondent=%@&address=%@&visitProfile=%@&result=%@&customerRequirements=%@&customerChange=%@&visitorStr=%@",sid,customerCallPlanID,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *saveDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"saveDic字典里面的内容为--》%@", saveDic);
        if ([[saveDic objectForKey:@"success"] boolValue] == YES) {
            VisitPlanTableViewController *contant = [[VisitPlanTableViewController alloc]init];
            [self.navigationController pushViewController:contant animated:YES];
        }
    }
}

- (IBAction)customerName:(id)sender {
    NSString *customerName1 = self.customerNameStr.text;
    NSString *visitDate =self.visitDate.text;
    NSString *telePhone1 =self.theme.text;
    NSString *department1=self.accessMethod.text;
    NSString *position1=self.mainContent.text;
    NSString *respondentPhone = self.respondentPhone.text;
    NSString *respondent =self.respondent.text;
    NSString *address =self.address.text;
    NSString *visitProfile=self.visitProfile.text;
    NSString *result=self.result.text;
    NSString *customerRequirements = self.customerRequirements.text;
    NSString *customerChange =self.customerChange.text;
    NSString *visitorStr =self.visitorStr.text;

    [_dailyEntity setCustomerNameStr:customerName1];
    [_dailyEntity setVisitDate:visitDate];
    [_dailyEntity setTheme:telePhone1];
    [_dailyEntity setAccessMethod:department1];
    [_dailyEntity setMainContent:position1];
    [_dailyEntity setRespondentPhone:respondentPhone];
    [_dailyEntity setRespondent:respondent];
    [_dailyEntity setAddress:address];
    [_dailyEntity setVisitProfile:visitProfile];
    [_dailyEntity setResult:result];
    [_dailyEntity setCustomerRequirements:customerRequirements];
    [_dailyEntity setCustomerChange:customerChange];
    [_dailyEntity setVisitorStr:visitorStr];

    CustomerTableViewController *list = [[CustomerTableViewController alloc]init];
    [_dailyEntity setIndex:@"1"];
    [list setDailyEntity:_dailyEntity];
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)goback:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[PlanDetalViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (IBAction)access:(id)sender {
    [self selectBFFSArray];
    
    self.selectBFFSForShow=[[NSMutableArray alloc] init];
    self.selectBFFSIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"所属行业选择";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];

}
//为所属行业赋值
-(void) selectBFFSArray
{
    NSError *error;
    NSMutableArray *nextFlowBFFSName=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowBFFSId=[[NSMutableArray alloc] init];
    _uid=[[NSMutableArray alloc] init];
    NSString *typeID = @"('fangWenFS')";
    NSArray *list = [self list:typeID];
    
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        NSLog(@"%@",listdic);
        //        [self.uid addObject:listdic];
        NSString *submitID = (NSString *)[listdic objectForKey:@"detailID"];
        NSLog(@"%@",submitID);
        NSString *teamname = (NSString *)[listdic objectForKey:@"detailName"];
        NSLog(@"%@",teamname);
        
        [nextFlowBFFSName     addObject:teamname];
        [nextFlowBFFSId  addObject:submitID];
    }
    _selectBFFS= [nextFlowBFFSName copy];
    _selectBFFSId=[nextFlowBFFSId copy];
}


- (NSArray *)list:(NSString *)typeID{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mdictionaryDetailAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param  = [NSString stringWithFormat:@"&MOBILE_SID=%@&typeID=%@",sid,typeID];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *nextFlow = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",nextFlow);
    NSArray *list = [nextFlow objectForKey:@"obj"];
    
    return list;
}
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_selectBFFS count];
    
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
    cell.textLabel.text = _selectBFFS[indexPath.row];
    return cell;
}

//点击添加选择的人员
- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self.selectBFFSForShow    addObject:[self.selectBFFS   objectAtIndex:indexPath.row]];
    [self.selectBFFSIdForParam addObject:[self.selectBFFSId objectAtIndex:indexPath.row]];
    NSLog(@"self.selectHYIdForParam%@",self.selectBFFSIdForParam);
    [self buttonInputLabel:tableView];
    
}
//取消选择时的操作
- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    self.selectedIndexPath = indexPath;
    [self.selectBFFSForShow    removeObject:[self.selectBFFS   objectAtIndex:indexPath.row]];
    [self.selectBFFSIdForParam removeObject:[self.selectBFFSId objectAtIndex:indexPath.row]];
    [self buttonInputLabel:tableView];
}
-(void)buttonInputLabel:(ZSYPopoverListView *)tableView
{
    NSString *string =@"";
    if([self.selectBFFSForShow count]==0){
        [tableView dismiss];
        [self.access setTitle:@"plese choose again" forState:UIControlStateNormal];
    }else{
        for (NSString *str in self.selectBFFSForShow)
        {
            string = [string stringByAppendingFormat:@"%@,",str];
        }
        NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
        [self.access setTitle:title forState:UIControlStateNormal];
        NSString *selectBFFSIdForParam =@"";
        for (NSString *ztr in self.selectBFFSIdForParam)
        {
            selectBFFSIdForParam = [selectBFFSIdForParam stringByAppendingFormat:@"%@,",ztr];
        }
        selectBFFSIdForParam = [selectBFFSIdForParam substringWithRange:NSMakeRange(0, [selectBFFSIdForParam length] - 1)];
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        _accessMethodID=selectBFFSIdForParam;
    }
    
}


@end


