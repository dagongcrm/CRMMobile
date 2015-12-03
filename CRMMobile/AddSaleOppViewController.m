//
//  AddSaleOppViewController.m
//  CRMMobile
//
//  Created by jam on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddSaleOppViewController.h"
#import "SaleOppTableViewController.h"
#import "SaleOppEntity.h"
#import "CustomerContactListViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "ZSYPopoverListView.h"
#import "UIImage+Tint.h"

@interface AddSaleOppViewController ()

@property (strong,nonatomic)  NSString    *select;//用于判断下拉选

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
//选择  销售机会来源
@property (strong, nonatomic) IBOutlet UIButton *saleOppSrcSelect;//销售机会选择按钮
@property (strong,nonatomic)  NSMutableArray *selectOppSrcForShow;//已选择的销售机会列表
@property (strong,nonatomic)  NSMutableArray *selectSrcIdForParam;//已选择的销售机会ID列表
@property (strong,nonatomic)  NSArray *selectSrc;//可供选择的 销售机会
@property (strong,nonatomic)  NSArray *selectSrcId;//可供选择的 销售机会ID
@property (strong,nonatomic) NSString  *chooseOppSrcID;//用于提交的销售机会ID
@property (strong,nonatomic) NSString  *chooseOppSrc;//用于提交的销售机会

@property (strong, nonatomic) IBOutlet UIButton *selectOppStateSelectButton;//机会状态选择按钮
@property (strong,nonatomic)  NSMutableArray *selectOppStateForShow;//已选择的机会状态列表
@property (strong,nonatomic)  NSMutableArray *selectOppStateIdForParam;//已选择的机会状态ID列表
@property (strong,nonatomic)  NSArray *selectOppState;//可供选择的 机会状态
@property (strong,nonatomic)  NSArray *selectOppStateId;//可供选择的 机会状态ID
@property (strong,nonatomic) NSString  *chooseoppStateID;//用于提交的机会状态ID
@property (strong,nonatomic) NSString  *chooseoppState;//用于提交的机会状态

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *customerNameStr;
@property (weak, nonatomic) IBOutlet UITextField *saleOppSrc;
@property (weak, nonatomic) IBOutlet UITextField *successProbability;
@property (weak, nonatomic) IBOutlet UITextField *saleOppDescription;
@property (weak, nonatomic) IBOutlet UITextField *oppState;
@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextField *contactTel;



- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)customerNameSelect:(id)sender;
- (IBAction)oppStateSelect:(id)sender;
- (IBAction)saleOppSrcSelect:(id)sender;

- (IBAction)saleOppSrcSelect:(id)sender;

@end

@implementation AddSaleOppViewController
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize saleOppEntity=_saleOppEntity;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self valuation];
    [self BackButton];
    self.title=@"添加销售机会";
    self.scroll.contentSize = CGSizeMake(375, 700);
    
    //appear   appendviewDidLoad
}

-(void)BackButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage imageNamed:@"back002"] imageWithTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ResView) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,rightItem];
    
}


- (void)ResView
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[SaleOppTableViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

//赋值方法
- (void) valuation {
    _customerNameStr.text=_saleOppEntity.customerNameStr;
    _successProbability.text=_saleOppEntity.successProbability;
    _saleOppDescription.text=_saleOppEntity.saleOppDescription;
    _contact.text=_saleOppEntity.contact;
    _contactTel.text=_saleOppEntity.contactTel;
    if(_saleOppEntity.saleOppSrc.length!=0){
        _chooseOppSrcID=_saleOppEntity.saleOppSrc;
        _chooseOppSrc=_saleOppEntity.saleOppSrcStr;
        [self.saleOppSrcSelect setTitle:_saleOppEntity.saleOppSrcStr forState:UIControlStateNormal];
        
    }
    if(_saleOppEntity.oppState.length!=0){
        _chooseoppStateID=_saleOppEntity.oppState;
        _chooseoppState=_saleOppEntity.oppStateStr;
        [self.selectOppStateSelectButton setTitle:_saleOppEntity.oppStateStr forState:UIControlStateNormal];
    }
}
- (IBAction)cancel:(id)sender {
    [self ResView];
}

- (IBAction)save:(id)sender {
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"msaleOpportunityAction!add.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&customerName=%@&successProbability=%@&saleOppDescription=%@&contact=%@&contactTel=%@&saleOppSrc=%@&oppState=%@",sid,_saleOppEntity.customerName,_successProbability.text,_saleOppDescription.text,_contact.text,_contactTel.text,_chooseOppSrcID,_chooseoppStateID];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        SaleOppTableViewController *mj = [[SaleOppTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }

}

- (IBAction)customerNameSelect:(id)sender {
    _saleOppEntity=[[SaleOppEntity alloc] init];
    [_saleOppEntity setCustomerNameStr:_customerNameStr.text];
    [_saleOppEntity setSaleOppSrc:_chooseOppSrcID];
    [_saleOppEntity setSaleOppSrcStr:_chooseOppSrc];
    [_saleOppEntity setSuccessProbability:_successProbability.text];
    [_saleOppEntity setSaleOppDescription:_saleOppDescription.text];
    [_saleOppEntity setOppState:_chooseoppStateID];
    [_saleOppEntity setOppStateStr:_chooseoppState];
    [_saleOppEntity setContact:_contact.text];
    [_saleOppEntity setContactTel:_contactTel.text];
    [_saleOppEntity setIndex:@"addSaleOpp"];
    CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [list setSaleOppEntity:_saleOppEntity];
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)saleOppSrcSelect:(id)sender {
    _select=@"saleOppSrc";
    [self saleOppSrcSelectArray];
    self.selectOppSrcForShow=[[NSMutableArray alloc] init];
    self.selectSrcIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"请选择销售机会来源";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];

}
- (IBAction)oppStateSelectButton:(id)sender {
    _select=@"oppState";
    [self oppStateSelectArray];
    
    self.selectOppStateForShow=[[NSMutableArray alloc] init];
    self.selectOppStateIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"请选择机会状态";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
}



//为销售机会赋值
-(void) saleOppSrcSelectArray
{
    NSError *error;
    NSMutableArray *nextFlowBFFSName=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowBFFSId=[[NSMutableArray alloc] init];
//    _uid=[[NSMutableArray alloc] init];
    NSString *typeID = @"('xiaoShouJXLY')";
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
    _selectSrc= [nextFlowBFFSName copy];
    _selectSrcId=[nextFlowBFFSId copy];
}

//为机会状态赋值
-(void) oppStateSelectArray
{
    NSError *error;
    NSMutableArray *nextFlowBFFSName=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowBFFSId=[[NSMutableArray alloc] init];
    //    _uid=[[NSMutableArray alloc] init];
    NSString *typeID = @"('jiHuiZT')";
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
    _selectOppState= [nextFlowBFFSName copy];
    _selectOppStateId=[nextFlowBFFSId copy];
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
    if ([_select isEqualToString:@"saleOppSrc"]){
        return [_selectSrc count];
    }else if([_select isEqualToString:@"oppState"]){
        return [_selectOppState count];
    }else{
        return nil;
    }
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_select isEqualToString:@"saleOppSrc"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectSrc[indexPath.row];
        return cell;
    }else if([_select isEqualToString:@"oppState"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectOppState[indexPath.row];
        return cell;
    }else{
        return nil;
    }
    
    
    
}

////点击添加选择的人员
- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_select isEqualToString:@"saleOppSrc"]){
        self.selectedIndexPath = indexPath;
        [self.selectOppSrcForShow addObject:[self.selectSrc objectAtIndex:indexPath.row]];
        [self.selectSrcIdForParam addObject:[self.selectSrcId objectAtIndex:indexPath.row]];
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"oppState"]){
        self.selectedIndexPath = indexPath;
        [self.selectOppStateForShow addObject:[self.selectOppState objectAtIndex:indexPath.row]];
        [self.selectOppStateIdForParam addObject:[self.selectOppStateId objectAtIndex:indexPath.row]];
        [self buttonInputLabel:tableView];
    }
}
//取消选择时的操作
- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self.selectOppSrcForShow    removeObject:[self.selectSrc objectAtIndex:indexPath.row]];
    [self.selectSrcIdForParam removeObject:[self.selectSrcId objectAtIndex:indexPath.row]];
    [self buttonInputLabel:tableView];
}


-(void)buttonInputLabel:(ZSYPopoverListView *)tableView
{
    if ([_select isEqualToString:@"saleOppSrc"]){
        NSString *string =@"";
        if([self.selectOppSrcForShow count]==0){
            [tableView dismiss];
            [self.saleOppSrcSelect setTitle:@"plese choose again" forState:UIControlStateNormal];
        }else{
            for (NSString *str in self.selectOppSrcForShow)
            {
                string = [string stringByAppendingFormat:@"%@,",str];
            }
            NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
            [self.saleOppSrcSelect setTitle:title forState:UIControlStateNormal];
            _chooseOppSrc=title;
            NSString *selectSrcIdForParam =@"";
            for (NSString *ztr in self.selectSrcIdForParam)
            {
                selectSrcIdForParam = [selectSrcIdForParam stringByAppendingFormat:@"%@,",ztr];
            }
            selectSrcIdForParam = [selectSrcIdForParam substringWithRange:NSMakeRange(0, [selectSrcIdForParam length] - 1)];
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            _chooseOppSrcID=selectSrcIdForParam;
        }
    }else if([_select isEqualToString:@"oppState"]){
        NSString *string =@"";
        if([self.selectOppStateForShow count]==0){
            [tableView dismiss];
            [self.selectOppStateSelectButton setTitle:@"plese choose again" forState:UIControlStateNormal];
        }else{
            for (NSString *str in self.self.selectOppStateForShow)
            {
                string = [string stringByAppendingFormat:@"%@,",str];
            }
            NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
            [self.selectOppStateSelectButton setTitle:title forState:UIControlStateNormal];
            _chooseoppState=title;
            NSString *selectOppStateIdForParam =@"";
            for (NSString *ztr in self.self.selectOppStateIdForParam)
            {
                selectOppStateIdForParam = [selectOppStateIdForParam stringByAppendingFormat:@"%@,",ztr];
            }
            selectOppStateIdForParam = [selectOppStateIdForParam substringWithRange:NSMakeRange(0, [selectOppStateIdForParam length] - 1)];
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            _chooseoppStateID=selectOppStateIdForParam;
        }
        
    }
    
    
    
    
    
}



@end
