//
//  AddCustomerCallPlanViewController.m
//  CRMMobile
//
//  Created by yd on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddCustomerCallPlanViewController.h"
#import "AppDelegate.h"
#import "HZQDatePickerView.h"
#import "config.h"
#import "CustomerCallPlanViewController.h"
#import "ZSYPopoverListView.h"
#import "CustomerCallPlanDetailMessageEntity.h"
#import "CustomerContactListViewController.h"
#import "VisitPlanTableViewController.h"
@interface AddCustomerCallPlanViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;


@property (weak, nonatomic) IBOutlet UITextView *theme;


@property (weak, nonatomic) IBOutlet UITextField *visitDate;  //拜访时间

@property (weak, nonatomic) IBOutlet UITextField *respondentPhone;  //受访人电话

@property (weak, nonatomic) IBOutlet UITextView *address;

@property (weak, nonatomic) IBOutlet UITextField *respondent;
@property (strong, nonatomic) IBOutlet UITextView *visitProfile;

@property (strong, nonatomic) IBOutlet UITextView *result;
@property (strong, nonatomic) IBOutlet UITextView *customerRequirements;
@property (strong, nonatomic) IBOutlet UITextView *customerChange;

@property (weak, nonatomic) IBOutlet UITextField *khmc;
- (IBAction)selectDate:(id)sender;
- (IBAction)cancel:(id)sender;

@property (strong,nonatomic) NSString  *accessMethodID;//选择的拜访方式ID 用于提交


@property (strong, nonatomic) HZQDatePickerView *pikerView;


@property (weak, nonatomic) IBOutlet UIButton *accessMethod;   //访问方式

//下拉选
@property (strong, nonatomic) NSMutableArray *uid;
@property (nonatomic, retain) NSIndexPath       *selectedIndexPath;
@property (strong,nonatomic)  NSArray           *selectBFFS;  //选择的 拜访方式名称
@property (strong,nonatomic)  NSArray           *selectBFFSId; //选择的 拜访方式ID
@property (strong,nonatomic)  NSMutableArray    *selectBFFSForShow; // 拜访方式
@property (strong,nonatomic)  NSMutableArray    *selectBFFSIdForParam;//拜访方式编号



@end

@implementation AddCustomerCallPlanViewController
@synthesize nextArray;
@synthesize selectPicker;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize customerCallPlanEntity = _customerCallPlanEntity;


//选择客户名称
- (IBAction)addCustomer:(id)sender {
    
    NSString *theme=_theme.text;
    NSString *visitDate=_visitDate.text;
    NSString *respondentPhone=_respondentPhone.text;
   
    
    NSString *respondent=_respondent.text;
    NSString *address=_address.text;
    NSString *visitProfile=_visitProfile.text;
    NSString *result=_result.text;
    NSString *customerRequirements=_customerRequirements.text;
    NSString *customerChange=_customerChange.text;
    NSString *accessMethodID=@"";//拜访方式
  
    for (int i=0; i<[self.selectBFFSIdForParam count]; i++) {
        accessMethodID = [self.selectBFFSIdForParam objectAtIndex:i];
    }
    
    _customerCallPlanEntity=[[CustomerCallPlanDetailMessageEntity alloc] init];
    
    [_customerCallPlanEntity setTheme:theme];
    [_customerCallPlanEntity setAccessMethod:accessMethodID];
    [_customerCallPlanEntity setRespondentPhone:respondentPhone];
    [_customerCallPlanEntity setRespondent:respondent];
    [_customerCallPlanEntity setAddress:address];
    [_customerCallPlanEntity setVisitProfile:visitProfile];
    [_customerCallPlanEntity setVisitDate:visitDate];
    [_customerCallPlanEntity setResult:result];
    [_customerCallPlanEntity setCustomerRequirements:customerRequirements];
    [_customerCallPlanEntity setCustomerChange:customerChange];
    
    [_customerCallPlanEntity setIndex:@"addCustomerCallPlan"];
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
-(BOOL) validateTelphone:(NSString *)mobile
{
    NSString *phoneRegex = @"\\d{3}-\\d{8}|\\d{4}-\\d{7,8}";
   
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
   
    return [phoneTest evaluateWithObject:mobile];
}
-(BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
-(BOOL) validatePhone:(NSString *)phone
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    return [phoneNumber evaluateWithObject:phone];
}
//添加
- (IBAction)add:(id)sender {
    NSString *customerID=_customerCallPlanEntity.customerID;
    NSString *theme=_theme.text;
    NSString *visitDate=_visitDate.text;
    NSString *respondentPhone=_respondentPhone.text;
    NSString *respondent=_respondent.text;
    NSString *address=_address.text;
    NSString *visitProfile=_visitProfile.text;
    NSString *result=_result.text;
    NSString *customerRequirements=_customerRequirements.text;
    NSString *customerChange=_customerChange.text;
    NSString *accessMethodID=@"";//拜访方式
 
    for (int i=0; i<[self.selectBFFSIdForParam count]; i++) {
        accessMethodID = [self.selectBFFSIdForParam objectAtIndex:i];
    }
  
    if (theme.length==0||visitDate.length==0||accessMethodID.length==0||respondentPhone.length==0||respondent.length==0||address.length==0||visitProfile.length==0||result.length==0||customerChange.length==0||customerRequirements.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"文本框输入框不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    
        
    }else if (!([self validateMobile:self.respondentPhone.text]||[self validatePhone:self.respondentPhone.text]||[self validateTelphone:self.respondentPhone.text])){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"电话号码格式不正确！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
        
    }else{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerCallPlanAction!add.action?"]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&theme=%@&visitDate=%@&respondentPhone=%@&respondent=%@&address=%@&visitProfile=%@&result=%@&customerRequirements=%@&customerChange=%@&customerID=%@&accessMethod=%@",sid,theme,visitDate,respondentPhone,respondent,address,visitProfile,result,customerRequirements,customerChange,customerID,accessMethodID];
    
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
        CustomerCallPlanViewController *mj = [[CustomerCallPlanViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
        }
  }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //赋值
    [self valuation];
    //调节scroll宽度和高度
    self.title=@"拜访添加";
    self.scroll.contentSize=CGSizeMake(375, 1025);
//    [self dateVerify];
}

//赋值方法
- (void) valuation {
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    
    
    [self.theme.layer setBorderColor:color];
    self.theme.layer.borderWidth = 1;
    self.theme.layer.cornerRadius = 6;
    self.theme.layer.masksToBounds = YES;
    
    
    [self.address.layer setBorderColor:color];
    self.address.layer.borderWidth = 1;
    self.address.layer.cornerRadius = 6;
    self.address.layer.masksToBounds = YES;
    
    [self.customerChange.layer setBorderColor:color];
    self.customerChange.layer.borderWidth = 1;
    self.customerChange.layer.cornerRadius = 6;
    self.customerChange.layer.masksToBounds = YES;
    
    [self.visitProfile.layer setBorderColor:color];
    self.visitProfile.layer.borderWidth = 1;
    self.visitProfile.layer.cornerRadius = 6;
    self.visitProfile.layer.masksToBounds = YES;
    
    [self.result.layer setBorderColor:color];
    self.result.layer.borderWidth = 1;
    self.result.layer.cornerRadius = 6;
    self.result.layer.masksToBounds = YES;
    
    [self.customerRequirements.layer setBorderColor:color];
    self.customerRequirements.layer.borderWidth = 1;
    self.customerRequirements.layer.cornerRadius = 6;
    self.customerRequirements.layer.masksToBounds = YES;
    
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

- (IBAction)selectDate:(id)sender {
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    //        _pikerView.frame = CGRectMake(0, 0, ScreenRectWidth, ScreenRectHeight + 20);
    DateType type ;
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    
    [self.view addSubview:_pikerView];
}

- (IBAction)cancel:(id)sender {
    [self ResView];
}
- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[VisitPlanTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    self.visitDate.text = [NSString stringWithFormat:@"%@", date];
}
@end
