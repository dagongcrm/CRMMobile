//
//  AddCustomerInformationViewController.m
//  CRMMobile
//
//  Created by yd on 15/11/4.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddCustomerInformationViewController.h"
#import "AppDelegate.h"
#import "CustomerInformationTableViewController.h"
#import "config.h"
#import "options.h"
#import "ZSYPopoverListView.h"



@interface AddCustomerInformationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customerName;
//@property (weak, nonatomic) IBOutlet UITextField *CustomerAddress;

@property (weak, nonatomic) IBOutlet UITextView *CustomerAddress;



@property (weak, nonatomic) IBOutlet UITextField *Phone;

//用于判断下拉选
@property (strong,nonatomic)  NSString    *select; // 所属行业

//选择 所属行业
@property (strong,nonatomic)  NSMutableArray    *selectHYForShow; // 所属行业
@property (strong,nonatomic)  NSMutableArray    *selectHYIdForParam;//所属行业编号
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong,nonatomic)  NSArray           *selectHY;  //选择的 行业名称
@property (strong,nonatomic)  NSArray           *selectHYId; //选择的 行业ID
@property (nonatomic, retain) NSIndexPath       *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *chooseHYButton;
@property (strong,nonatomic) NSString  *chooseHYID;//选择的 行业ID 用于提交

//选择 企业类型
@property (weak, nonatomic) IBOutlet UIButton *chooseQYLXButton;
@property (strong,nonatomic)  NSMutableArray    *selectQYLXForShow; // 企业类型
@property (strong,nonatomic)  NSMutableArray    *selectQYLXIdForParam;//企业类型编号
@property (strong,nonatomic)  NSArray           *selectQYLX;  //选择的 企业类型名称
@property (strong,nonatomic)  NSArray           *selectQYLXId; //选择的 企业类型ID
@property (strong,nonatomic) NSString  *chooseQYLXID;//选择的 行业ID 用于提交


//选择客户类别
@property (weak, nonatomic) IBOutlet UIButton *chooseKHLBButton;
@property (strong,nonatomic)  NSMutableArray    *selectKHLBForShow; // 客户类别
@property (strong,nonatomic)  NSMutableArray    *selectKHLBIdForParam;//客户类别编号
@property (strong,nonatomic)  NSArray           *selectKHLB;  //选择的 客户别累名称
@property (strong,nonatomic)  NSArray           *selectKHLBId; //选择的 客户类别ID
@property (strong,nonatomic) NSString  *chooseKHLBID;//选择的 客户类别ID 用于提交


//选择省份
@property (weak, nonatomic) IBOutlet UIButton *chooseSFButton;
@property (strong,nonatomic)  NSMutableArray    *selectSFForShow; // 省份
@property (strong,nonatomic)  NSMutableArray    *selectSFIdForParam;//省份编号
@property (strong,nonatomic)  NSArray           *selectSF;  //选择的 省份名称
@property (strong,nonatomic)  NSArray           *selectSFId; //选择的 省份ID
@property (strong,nonatomic) NSString  *chooseSFID;//选择的 省份ID 用于提交





@end

@implementation AddCustomerInformationViewController
@synthesize nextArray;
@synthesize selectPicker;
@synthesize selectedIndexPath = _selectedIndexPath;

//选择省份按钮
- (IBAction)selectSF:(id)sender {
    _select=@"SF";
    [self selectSFArray];
    
    self.selectSFForShow=[[NSMutableArray alloc] init];
    self.selectSFIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListViewSingle *listView = [[ZSYPopoverListViewSingle alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
    listView.titleName.text = @"请选择对应的省份";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
}
//为 省份赋值
-(void) selectSFArray
{
    NSError *error;
    NSMutableArray *nextFlowSFName=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowSFId=[[NSMutableArray alloc] init];
    _uid=[[NSMutableArray alloc] init];
    NSString *typeID = @"('shengFen')";
    NSArray *list = [self list:typeID];
    
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        NSLog(@"%@",listdic);
        NSString *submitID = (NSString *)[listdic objectForKey:@"detailID"];
        NSLog(@"%@",submitID);
        NSString *teamname = (NSString *)[listdic objectForKey:@"detailName"];
        NSLog(@"%@",teamname);
        
        [nextFlowSFName     addObject:teamname];
        [nextFlowSFId  addObject:submitID];
    }
    _selectSF= [nextFlowSFName copy];
    _selectSFId=[nextFlowSFId copy];
}






//选择所属行业按钮
- (IBAction)selectHY:(id)sender {
    _select=@"HY";
    [self selectHYArray];
    
    self.selectHYForShow=[[NSMutableArray alloc] init];
    self.selectHYIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListViewSingle *listView = [[ZSYPopoverListViewSingle alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    listView.titleName.text = @"所属行业选择";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];

    
}
//为所属行业赋值
-(void) selectHYArray
{
    NSError *error;
    NSMutableArray *nextFlowHYName=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowHYId=[[NSMutableArray alloc] init];
    _uid=[[NSMutableArray alloc] init];
    NSString *typeID = @"('suoShuHY')";
    NSArray *list = [self list:typeID];
    
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        NSLog(@"%@",listdic);
//        [self.uid addObject:listdic];
        NSString *submitID = (NSString *)[listdic objectForKey:@"bianHao"];
        NSLog(@"%@",submitID);
        NSString *teamname = (NSString *)[listdic objectForKey:@"detailName"];
        NSLog(@"%@",teamname);
        
        [nextFlowHYName     addObject:teamname];
        [nextFlowHYId  addObject:submitID];
    }
    _selectHY= [nextFlowHYName copy];
    _selectHYId=[nextFlowHYId copy];
}

//选择 企业类型
- (IBAction)selectQYLX:(id)sender {
    _select=@"QYLX";
    [self selectQYLXArray];
    
    self.selectQYLXForShow=[[NSMutableArray alloc] init];
    self.selectQYLXIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListViewSingle *listView = [[ZSYPopoverListViewSingle alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"企业类型选择";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
}
//为 企业类型赋值
-(void) selectQYLXArray
{
    NSError *error;
    NSMutableArray *nextFlowQYLXName=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowQYLXId=[[NSMutableArray alloc] init];
    _uid=[[NSMutableArray alloc] init];
    NSString *typeID = @"('qiYeLX')";
    NSArray *list = [self list:typeID];
    
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        NSLog(@"%@",listdic);
        //        [self.uid addObject:listdic];
        NSString *submitID = (NSString *)[listdic objectForKey:@"detailID"];
        NSLog(@"%@",submitID);
        NSString *teamname = (NSString *)[listdic objectForKey:@"detailName"];
        NSLog(@"%@",teamname);
        
        [nextFlowQYLXName     addObject:teamname];
        [nextFlowQYLXId  addObject:submitID];
    }
    _selectQYLX= [nextFlowQYLXName copy];
    _selectQYLXId=[nextFlowQYLXId copy];
}

//选择客户类别按钮
- (IBAction)selectKHLB:(id)sender {
    _select=@"KHLB";
    [self selectKHLBArray];
    
    self.selectKHLBForShow=[[NSMutableArray alloc] init];
    self.selectKHLBIdForParam=[[NSMutableArray alloc] init];
    ZSYPopoverListViewSingle *listView = [[ZSYPopoverListViewSingle alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"所属行业选择";
    listView.backgroundColor=[UIColor blueColor];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
}
//为 客户类别赋值
-(void) selectKHLBArray
{
    NSError *error;
    NSMutableArray *nextFlowKHLBName=[[NSMutableArray alloc] init];
    NSMutableArray *nextFlowKHLBId=[[NSMutableArray alloc] init];
    _uid=[[NSMutableArray alloc] init];
    NSString *typeID = @"('keHuLB')";
    NSArray *list = [self list:typeID];
    
    for (int i = 0; i<[list count]; i++) {
        NSDictionary *listdic = [list objectAtIndex:i];
        NSLog(@"%@",listdic);
        NSString *submitID = (NSString *)[listdic objectForKey:@"detailID"];
        NSLog(@"%@",submitID);
        NSString *teamname = (NSString *)[listdic objectForKey:@"detailName"];
        NSLog(@"%@",teamname);
        
        [nextFlowKHLBName     addObject:teamname];
        [nextFlowKHLBId  addObject:submitID];
    }
    _selectKHLB= [nextFlowKHLBName copy];
    _selectKHLBId=[nextFlowKHLBId copy];
}

- (NSArray *)list:(NSString *)typeID{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    //    NSString *ftn_HandleResult=myDelegate.options.ftn_HandleResult;
    //    NSString *flo_ID=myDelegate.options.flo_ID;
    //    NSString *templateNodeID =myDelegate.options.templateNodeID;
    //    NSString *chooseHYIDs = myDelegate.options.chooseHYIDs;
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
    if ([_select isEqualToString:@"HY"]){
       return [_selectHY count];
    }else if([_select isEqualToString:@"QYLX"]){
        return [_selectQYLX count];
    }else if([_select isEqualToString:@"KHLB"]){
        return [_selectKHLB count];
    }else if([_select isEqualToString:@"SF"]){
        return [_selectSF count];
    }else{
        return nil;
    }
//    return [_selectHY count];
}


//single choose
- (NSInteger)popoverListViewSingle:(ZSYPopoverListViewSingle *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_select isEqualToString:@"HY"]){
        return [_selectHY count];
    }else if([_select isEqualToString:@"QYLX"]){
        return [_selectQYLX count];
    }else if([_select isEqualToString:@"KHLB"]){
        return [_selectKHLB count];
    }else if([_select isEqualToString:@"SF"]){
        return [_selectSF count];
    }else{
        return nil;
    }
}

- (UITableViewCell *)popoverListViewSingle:(ZSYPopoverListViewSingle *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    if ([_select isEqualToString:@"HY"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectHY[indexPath.row];
        return cell;
    }else if([_select isEqualToString:@"QYLX"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectQYLX[indexPath.row];
        return cell;
    }else if([_select isEqualToString:@"KHLB"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectKHLB[indexPath.row];
        return cell;
    }else if([_select isEqualToString:@"SF"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectSF[indexPath.row];
        return cell;
    }else{
        return nil;
    }
    
}

- (void)popoverListViewSingle:(ZSYPopoverListViewSingle *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    if ([_select isEqualToString:@"HY"]){
        self.selectedIndexPath = indexPath;
        [self.selectHYForShow    removeObject:[self.selectHY   objectAtIndex:indexPath.row]];
        [self.selectHYIdForParam removeObject:[self.selectHYId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectHYIdForParam%@",self.selectHYIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"QYLX"]){
        self.selectedIndexPath = indexPath;
        [self.selectQYLXForShow    removeObject:[self.selectQYLX   objectAtIndex:indexPath.row]];
        [self.selectQYLXIdForParam removeObject:[self.selectQYLXId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectQYLXIdForParam%@",self.selectQYLXIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"KHLB"]){
        self.selectedIndexPath = indexPath;
        [self.selectKHLBForShow    removeObject:[self.selectKHLB   objectAtIndex:indexPath.row]];
        [self.selectKHLBIdForParam removeObject:[self.selectKHLBId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectKHLBIdForParam%@",self.selectKHLBIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"SF"]){
        self.selectedIndexPath = indexPath;
        [self.selectSFForShow    removeObject:[self.selectSF   objectAtIndex:indexPath.row]];
        [self.selectSFIdForParam removeObject:[self.selectSFId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectSFIdForParam%@",self.selectSFIdForParam);
        [self buttonInputLabel:tableView];
    }
}

- (void)popoverListViewSingle:(ZSYPopoverListViewSingle *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    if ([_select isEqualToString:@"HY"]){
        self.selectedIndexPath = indexPath;
        [self.selectHYForShow    removeObject:[self.selectHY   objectAtIndex:indexPath.row]];
        [self.selectHYIdForParam removeObject:[self.selectHYId objectAtIndex:indexPath.row]];
        [self.selectHYForShow    addObject:[self.selectHY   objectAtIndex:indexPath.row]];
        [self.selectHYIdForParam addObject:[self.selectHYId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectHYIdForParam%@",self.selectHYIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"QYLX"]){
        self.selectedIndexPath = indexPath;
        [self.selectQYLXForShow    removeAllObjects];
        [self.selectQYLXIdForParam removeAllObjects];
        [self.selectQYLXForShow    addObject:[self.selectQYLX   objectAtIndex:indexPath.row]];
        [self.selectQYLXIdForParam addObject:[self.selectQYLXId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectQYLXIdForParam%@",self.selectQYLXIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"KHLB"]){
        self.selectedIndexPath = indexPath;
        [self.selectKHLBForShow    removeAllObjects];
        [self.selectKHLBIdForParam removeAllObjects];
        [self.selectKHLBForShow    addObject:[self.selectKHLB   objectAtIndex:indexPath.row]];
        [self.selectKHLBIdForParam addObject:[self.selectKHLBId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectKHLBIdForParam%@",self.selectKHLBIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"SF"]){
        self.selectedIndexPath = indexPath;
        [self.selectSFForShow    removeObject:[self.selectSF   objectAtIndex:indexPath.row]];
        [self.selectSFIdForParam removeObject:[self.selectSFId objectAtIndex:indexPath.row]];
        [self.selectSFForShow    addObject:[self.selectSF   objectAtIndex:indexPath.row]];
        [self.selectSFIdForParam addObject:[self.selectSFId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectSFIdForParam%@",self.selectSFIdForParam);
        [self buttonInputLabel:tableView];
    }
    

}





- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_select isEqualToString:@"HY"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectHY[indexPath.row];
        return cell;
    }else if([_select isEqualToString:@"QYLX"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectQYLX[indexPath.row];
        return cell;
    }else if([_select isEqualToString:@"KHLB"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectKHLB[indexPath.row];
        return cell;
    }else if([_select isEqualToString:@"SF"]){
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selected = YES;
        cell.textLabel.text = _selectSF[indexPath.row];
        return cell;
    }else{
        return nil;
    }

//    static NSString *identifier = @"identifier";
//    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
//    if (nil == cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    cell.selected = YES;
//    cell.textLabel.text = _selectHY[indexPath.row];
//    return cell;
}

//点击添加选择的人员
- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_select isEqualToString:@"HY"]){
        self.selectedIndexPath = indexPath;
        [self.selectHYForShow    addObject:[self.selectHY   objectAtIndex:indexPath.row]];
        [self.selectHYIdForParam addObject:[self.selectHYId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectHYIdForParam%@",self.selectHYIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"QYLX"]){
        self.selectedIndexPath = indexPath;
        [self.selectQYLXForShow    addObject:[self.selectQYLX   objectAtIndex:indexPath.row]];
        [self.selectQYLXIdForParam addObject:[self.selectQYLXId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectQYLXIdForParam%@",self.selectQYLXIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"KHLB"]){
        self.selectedIndexPath = indexPath;
        [self.selectKHLBForShow    removeAllObjects];
        [self.selectKHLBIdForParam removeAllObjects];
        [self.selectKHLBForShow    addObject:[self.selectKHLB   objectAtIndex:indexPath.row]];
        [self.selectKHLBIdForParam addObject:[self.selectKHLBId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectKHLBIdForParam%@",self.selectKHLBIdForParam);
        [self buttonInputLabel:tableView];
    }else if([_select isEqualToString:@"SF"]){
        self.selectedIndexPath = indexPath;
        [self.selectSFForShow    addObject:[self.selectSF   objectAtIndex:indexPath.row]];
        [self.selectSFIdForParam addObject:[self.selectSFId objectAtIndex:indexPath.row]];
        NSLog(@"self.selectSFIdForParam%@",self.selectSFIdForParam);
        [self buttonInputLabel:tableView];
    }
    
    
//    self.selectedIndexPath = indexPath;
//    [self.selectHYForShow    addObject:[self.selectHY   objectAtIndex:indexPath.row]];
//    [self.selectHYIdForParam addObject:[self.selectHYId objectAtIndex:indexPath.row]];
//    NSLog(@"self.selectHYIdForParam%@",self.selectHYIdForParam);
//    [self buttonInputLabel:tableView];
}
//取消选择时的操作
- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    self.selectedIndexPath = indexPath;
    [self.selectHYForShow    removeObject:[self.selectHY   objectAtIndex:indexPath.row]];
    [self.selectHYIdForParam removeObject:[self.selectHYId objectAtIndex:indexPath.row]];
    [self buttonInputLabel:tableView];
}

-(void)buttonInputLabel:(ZSYPopoverListView *)tableView
{
    if ([_select isEqualToString:@"HY"]){
        NSString *string =@"";
        if([self.selectHYForShow count]==0){
            [tableView dismiss];
            [self.chooseHYButton setTitle:@"plese choose again" forState:UIControlStateNormal];
        }else{
            for (NSString *str in self.selectHYForShow)
            {
                string = [string stringByAppendingFormat:@"%@,",str];
            }
            NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
            [self.chooseHYButton setTitle:title forState:UIControlStateNormal];
            NSString *selectHYIdForParam =@"";
            for (NSString *ztr in self.selectHYIdForParam)
            {
                selectHYIdForParam = [selectHYIdForParam stringByAppendingFormat:@"%@,",ztr];
            }
            selectHYIdForParam = [selectHYIdForParam substringWithRange:NSMakeRange(0, [selectHYIdForParam length] - 1)];
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            _chooseHYID=selectHYIdForParam;
            
        }
        
    }else if([_select isEqualToString:@"QYLX"]){
        NSString *string =@"";
        if([self.selectQYLXForShow count]==0){
            [tableView dismiss];
            [self.chooseQYLXButton setTitle:@"plese choose again" forState:UIControlStateNormal];
        }else{
            for (NSString *str in self.selectQYLXForShow)
            {
                string = [string stringByAppendingFormat:@"%@,",str];
            }
            NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
            [self.chooseQYLXButton setTitle:title forState:UIControlStateNormal];
            NSString *selectQYLXIdForParam =@"";
            for (NSString *ztr in self.selectQYLXIdForParam)
            {
                selectQYLXIdForParam = [selectQYLXIdForParam stringByAppendingFormat:@"%@,",ztr];
            }
            selectQYLXIdForParam = [selectQYLXIdForParam substringWithRange:NSMakeRange(0, [selectQYLXIdForParam length] - 1)];
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            _chooseQYLXID=selectQYLXIdForParam;
        }
        
    }else if([_select isEqualToString:@"KHLB"]){
        NSString *string =@"";
        if([self.selectKHLBForShow count]==0){
            [tableView dismiss];
            [self.chooseKHLBButton setTitle:@"plese choose again" forState:UIControlStateNormal];
        }else{
            for (NSString *str in self.selectKHLBForShow)
            {
                string = [string stringByAppendingFormat:@"%@,",str];
            }
            NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
            [self.chooseKHLBButton setTitle:title forState:UIControlStateNormal];
            NSString *selectKHLBIdForParam =@"";
            for (NSString *ztr in self.selectKHLBIdForParam)
            {
                selectKHLBIdForParam = [selectKHLBIdForParam stringByAppendingFormat:@"%@,",ztr];
            }
            selectKHLBIdForParam = [selectKHLBIdForParam substringWithRange:NSMakeRange(0, [selectKHLBIdForParam length] - 1)];
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            _chooseKHLBID=selectKHLBIdForParam;
        }

    }else if([_select isEqualToString:@"SF"]){
        NSString *string =@"";
        if([self.selectSFForShow count]==0){
            [tableView dismiss];
            [self.chooseSFButton setTitle:@"plese choose again" forState:UIControlStateNormal];
        }else{
            for (NSString *str in self.selectSFForShow)
            {
                string = [string stringByAppendingFormat:@"%@,",str];
            }
            NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
            [self.chooseSFButton setTitle:title forState:UIControlStateNormal];
            NSString *selectSFIdForParam =@"";
            for (NSString *ztr in self.selectSFIdForParam)
            {
                selectSFIdForParam = [selectSFIdForParam stringByAppendingFormat:@"%@,",ztr];
            }
            selectSFIdForParam = [selectSFIdForParam substringWithRange:NSMakeRange(0, [selectSFIdForParam length] - 1)];
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            _chooseSFID=selectSFIdForParam;
        }
    }
    
    
//    NSString *string =@"";
//    if([self.selectHYForShow count]==0){
//        [tableView dismiss];
//        [self.chooseHYButton setTitle:@"plese choose again" forState:UIControlStateNormal];
//    }else{
//        for (NSString *str in self.selectHYForShow)
//        {
//            string = [string stringByAppendingFormat:@"%@,",str];
//        }
//        NSString * title = [string substringWithRange:NSMakeRange(0,[string length] - 1)];
//        [self.chooseHYButton setTitle:title forState:UIControlStateNormal];
//        NSString *selectHYIdForParam =@"";
//        for (NSString *ztr in self.selectHYIdForParam)
//        {
//            selectHYIdForParam = [selectHYIdForParam stringByAppendingFormat:@"%@,",ztr];
//        }
//        selectHYIdForParam = [selectHYIdForParam substringWithRange:NSMakeRange(0, [selectHYIdForParam length] - 1)];
//        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//        myDelegate.options.chooseHYIDs=selectHYIdForParam;
//    }
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
       NSString *hy=@"";   //所属行业
    for (int i=0; i<[self.selectHYForShow count]; i++) {
        hy = [self.selectHYForShow objectAtIndex:i];
    }
    NSString *qylx=@"";   //所属行业
    for (int i=0; i<[self.selectQYLXIdForParam count]; i++) {
        qylx = [self.selectQYLXIdForParam objectAtIndex:i];
    }
    NSString *khlb=@"";   //客户类别
    for (int i=0; i<[self.selectKHLBIdForParam count]; i++) {
        khlb = [self.selectKHLBIdForParam objectAtIndex:i];
    }
    NSString *sf=@"";   //省份
    for (int i=0; i<[self.selectSFIdForParam count]; i++) {
        sf = [self.selectSFIdForParam objectAtIndex:i];
    }
    NSString *cn=[_customerName text];
    NSString *ca=[_CustomerAddress text];
    NSString *p=[_Phone text];
    //验证
    if (_customerName.text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"客户名称不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];

    }else if(_CustomerAddress.text.length==0){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"客户地址不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else if(_Phone.text.length==0){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"联系电话不能为空！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else if (!([self validateMobile:self.Phone.text]||[self validatePhone:self.Phone.text]||[self validateTelphone:self.Phone.text])){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示" message:@"电话号码格式不正确！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];

    }
    else{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
   NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerInformationAction!add.action?"]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"customerName=%@&customerAddress=%@&phone=%@&MOBILE_SID=%@&industryID=%@&companyType=%@&customerClass=%@&province=%@",cn,ca,p,sid,hy,qylx,khlb,sf];
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
            [alert show];
            NSLog(@"--------%@",error);
        }else{
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"添加成功！"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         CustomerInformationTableViewController *mj = [[CustomerInformationTableViewController alloc] init];
        [self.navigationController pushViewController:mj animated:YES];
//        for (UIViewController *controller in self.navigationController.viewControllers)
//        {
//            if ([controller isKindOfClass:[CustomerInformationTableViewController class]])
//            {
//                [self.navigationController popToViewController:controller animated:YES];
//            }
//        }
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKeyedSubscript:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    }
    }
}

- (void)viewDidLoad {
    
    //为下拉选 赋值
//    [self selectHYArray];
//    [self selectQYLXArray];
    
    self.nextArray  = self.nextArray;
    selectPicker.delegate   = self;
    selectPicker.dataSource = self;

    [super viewDidLoad];
    self.title=@"添加客户档案";
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    [self.CustomerAddress.layer setBorderColor:color];
    self.CustomerAddress.layer.borderWidth = 1;
    self.CustomerAddress.layer.cornerRadius = 6;
    self.CustomerAddress.layer.masksToBounds = YES;

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
