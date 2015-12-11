//
//  CustomerCallPlanEditViewController.m
//  CRMMobile
//
//  Created by yd on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "CustomerCallPlanEditViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "CustomerCallPlanViewController.h"
#import "ZSYPopoverListView.h"
#import "CustomerContactListViewController.h"
#import "HZQDatePickerView.h"
@interface CustomerCallPlanEditViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *visitDate;  //拜访时间

@property (weak, nonatomic) IBOutlet UITextView *theme;
@property (weak, nonatomic) IBOutlet UITextView *address;
- (IBAction)selectate:(id)sender;


- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;    //受访人电话

@property (weak, nonatomic) IBOutlet UITextField *respondent;    //受访人员

@property (weak, nonatomic) IBOutlet UITextField *visitProfile;    //拜访概要

@property (weak, nonatomic) IBOutlet UITextField *result;    //达成结果

@property (weak, nonatomic) IBOutlet UITextField *customerRequirements;   //客户需求

@property (weak, nonatomic) IBOutlet UITextField *customerChange;   //客户变故

@property (weak, nonatomic) IBOutlet UITextField *khmc;    //客户名称



@property (weak, nonatomic) IBOutlet UIButton *accessMethod;   //访问方式按钮
//下拉选
@property (strong, nonatomic) NSMutableArray *uid;
@property (nonatomic, retain) NSIndexPath       *selectedIndexPath;
@property (strong,nonatomic)  NSArray           *selectBFFS;  //选择的 拜访方式名称
@property (strong,nonatomic)  NSArray           *selectBFFSId; //选择的 拜访方式ID
@property (strong,nonatomic)  NSMutableArray    *selectBFFSForShow; // 拜访方式
@property (strong,nonatomic)  NSMutableArray    *selectBFFSIdForParam;//拜访方式编号
@property (strong,nonatomic) NSString  *accessMethodID;//选择的拜访方式ID 用于提交
@property (strong, nonatomic) HZQDatePickerView *pikerView;

@end

@implementation CustomerCallPlanEditViewController
@synthesize customerCallPlanEntity=_customerCallPlanEntity;
@synthesize nextArray;
@synthesize selectPicker;
@synthesize selectedIndexPath = _selectedIndexPath;

//选择客户名称
- (IBAction)addCustomer:(id)sender {

    [_customerCallPlanEntity setIndex:@"editCustomerCallPlan"];
    CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [list setCustomerCallPlanEntity:_customerCallPlanEntity];
    
    [self.navigationController pushViewController:list animated:YES];
    
}

//选择访问方式
- (IBAction)accessMethod:(id)sender {
    [self selectBFFSArray];
    
    self.selectBFFSForShow=[[NSMutableArray alloc] init];
    self.selectBFFSIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"访问方式选择";
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
        [self.accessMethod setTitle:@"plese choose again" forState:UIControlStateNormal];
    }else{
        for (NSString *str in self.selectBFFSForShow)
        {
            string = [string stringByAppendingFormat:@"%@,",str];
        }
        NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
        [self.accessMethod setTitle:title forState:UIControlStateNormal];
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


//保存修改
- (IBAction)edit:(id)sender {
    NSString *customerCallPlanID=_customerCallPlanEntity.customerCallPlanID;
    
    NSString *customerID=_customerCallPlanEntity.customerID;
    NSLog(@"-----------------------------%@",customerID);
    NSString *customerName=_customerCallPlanEntity.customerNameStr;
    NSLog(@"-----------------------------%@",customerName);
    NSString *visitDate=_visitDate.text;
    NSString *theme=_theme.text;
    NSString *respondentPhone=_respondentPhone.text;
    NSString *respondent=_respondent.text;
    NSString *address=_address.text;
    NSString *visitProfile=_visitProfile.text;
    NSString *result=_result.text;
    NSString *customerRequirements=_customerRequirements.text;
    NSString *customerChange=_customerChange.text;
    NSString *visitorAttribution=_customerCallPlanEntity.visitorAttribution; //拜访人归属
    NSString *visitor=_customerCallPlanEntity.baiFangRen;   //拜访人
    NSString *accessMethodID=@"";//拜访方式
    for (int i=0; i<[self.selectBFFSIdForParam count]; i++) {
        accessMethodID = [self.selectBFFSIdForParam objectAtIndex:i];
    }
    
    if (theme.length==0||visitDate.length==0||respondentPhone.length==0||respondent.length==0||address.length==0||visitProfile.length==0||result.length==0||customerChange.length==0||customerRequirements.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"文本框输入框不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!edit.action?"]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerCallPlanID=%@&visitDate=%@&theme=%@&respondentPhone=%@&respondent=%@&address=%@&visitProfile=%@&result=%@&customerRequirements=%@&customerChange=%@&visitorAttribution=%@&visitor=%@&accessMethod=%@&customerID=%@&customerName=%@",sid,customerCallPlanID,visitDate,theme,respondentPhone,respondent,address,visitProfile,result,customerRequirements,customerChange,visitorAttribution,visitor,accessMethodID,customerID,customerName];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"更新成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        CustomerCallPlanViewController *mj = [[CustomerCallPlanViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];

        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }

    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"拜访计划修改";
    self.scroll.contentSize=CGSizeMake(375, 750);
    //赋值
    [self valuation];
}

//赋值方法
- (void) valuation {
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    
    [self.theme.layer setBorderColor:color];
    self.theme.layer.borderWidth = 1;
    self.theme.layer.cornerRadius = 6;
    self.theme.layer.masksToBounds = YES;
//    self.theme.editable = NO;
    
    [self.address.layer setBorderColor:color];
    self.address.layer.borderWidth = 1;
    self.address.layer.cornerRadius = 6;
    self.address.layer.masksToBounds = YES;
//    self.address.editable = NO;
    _khmc.text=_customerCallPlanEntity.customerNameStr;
    _visitDate.text=_customerCallPlanEntity.visitDate;
    _theme.text=_customerCallPlanEntity.theme;
    _respondentPhone.text=_customerCallPlanEntity.respondentPhone;
    _respondent.text=_customerCallPlanEntity.respondent;
    _address.text=_customerCallPlanEntity.address;
    _visitProfile.text=_customerCallPlanEntity.visitProfile;
    _result.text=_customerCallPlanEntity.result;
    _customerRequirements.text=_customerCallPlanEntity.customerRequirements;
    _customerChange.text=_customerCallPlanEntity.customerChange;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectate:(id)sender {
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    //        _pikerView.frame = CGRectMake(0, 0, ScreenRectWidth, ScreenRectHeight + 20);
    DateType type ;
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    
    [self.view addSubview:_pikerView];
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    self.visitDate.text = [NSString stringWithFormat:@"%@", date];
}
- (IBAction)cancel:(id)sender {
    [self ResView];
}
- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CustomerCallPlanViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
@end
