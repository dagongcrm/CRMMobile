//
//  AddSaleOppViewController.m
//  CRMMobile
//
//  Created by jam on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import "AddSaleOppViewController.h"
#import "SaleOppEntity.h"
#import "CustomerContactListViewController.h"

@interface AddSaleOppViewController ()

@property (strong,nonatomic)  NSString    *select;//用于判断下拉选

//选择  销售机会来源
@property (strong,nonatomic)  NSMutableArray    *selectSrcArray;
@property (strong,nonatomic)  NSMutableArray    *selectSrcIdArray;
@property (strong, nonatomic) NSMutableArray *uid;
@property (strong,nonatomic)  NSArray           *selectSrc;
@property (strong,nonatomic)  NSArray           *selectSrcId;
@property (nonatomic, retain) NSIndexPath       *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *chooseSrcButton;
@property (strong,nonatomic) NSString  *chooseSrcID;

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
- (IBAction)saleOppSrcSelect:(id)sender;
- (IBAction)oppStateSelect:(id)sender;

@end

@implementation AddSaleOppViewController
@synthesize saleOppEntity=_saleOppEntity;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self valuation];
    self.title=@"添加销售机会";
    self.scroll.contentSize = CGSizeMake(375, 700);
}
//赋值方法
- (void) valuation {
    _customerNameStr.text=_saleOppEntity.customerNameStr;
    _saleOppSrc.text=_saleOppEntity.saleOppSrc;
    _successProbability.text=_saleOppEntity.successProbability;
    _saleOppDescription.text=_saleOppEntity.saleOppDescription;
    _oppState.text=_saleOppEntity.oppState;
    _contact.text=_saleOppEntity.contact;
    _contactTel.text=_saleOppEntity.contactTel;
}
- (IBAction)cancel:(id)sender {
}

- (IBAction)save:(id)sender {
}

- (IBAction)customerNameSelect:(id)sender {
    
    NSString *customerNameStr= _customerNameStr.text;
    NSString *saleOppSrc=_saleOppSrc.text;
    NSString *successProbability=_successProbability.text;
    NSString *saleOppDescription=_saleOppDescription.text;
    NSString *oppState=_oppState.text;
    NSString *contact=_contact.text;
    NSString *contactTel=_contactTel.text;
    NSString *saleOppID=@"";//销售机会
//    for (int i=0; i<[self.selectBFFSIdForParam count]; i++) {
//        accessMethodID = [self.selectBFFSIdForParam objectAtIndex:i];
//    }
    
    _saleOppEntity=[[SaleOppEntity alloc] init];
    
    [_saleOppEntity setCustomerNameStr:customerNameStr];
    [_saleOppEntity setSaleOppSrc:saleOppSrc];
    [_saleOppEntity setSuccessProbability:successProbability];
    [_saleOppEntity setSaleOppDescription:saleOppDescription];
    [_saleOppEntity setOppState:oppState];
    [_saleOppEntity setContact:contact];
    [_saleOppEntity setContactTel:contactTel];
    
    [_saleOppEntity setIndex:@"addSaleOpp"];
    CustomerContactListViewController *list = [[CustomerContactListViewController alloc]init];
    [list setSaleOppEntity:_saleOppEntity];
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)saleOppSrcSelect:(id)sender {
    _select=@"saleOppSrc";
    [self saleOppSrcSelectArray];
    
//    self.selectSFForShow=[[NSMutableArray alloc] init];
//    self.selectSFIdForParam=[[NSMutableArray alloc] init];
//    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    listView.titleName.text = @"所属行业选择";
//    listView.backgroundColor=[UIColor blueColor];
//    listView.datasource = self;
//    listView.delegate = self;
//    [listView show];
}
//为 省份赋值
-(void) saleOppSrcSelectArray
{
//    NSError *error;
//    NSMutableArray *nextFlowSrcName=[[NSMutableArray alloc] init];
//    NSMutableArray *nextFlowSrcId=[[NSMutableArray alloc] init];
//    _uid=[[NSMutableArray alloc] init];
//    NSString *typeID = @"('SaleOppSrc')";
//    NSArray *list = [self list:typeID];
//    
//    for (int i = 0; i<[list count]; i++) {
//        NSDictionary *listdic = [list objectAtIndex:i];
//        NSLog(@"%@",listdic);
//        NSString *submitID = (NSString *)[listdic objectForKey:@"detailID"];
//        NSLog(@"%@",submitID);
//        NSString *teamname = (NSString *)[listdic objectForKey:@"detailName"];
//        NSLog(@"%@",teamname);
//        
//        [nextFlowSFName     addObject:teamname];
//        [nextFlowSFId  addObject:submitID];
//    }
//    _selectSF= [nextFlowSFName copy];
//    _selectSFId=[nextFlowSFId copy];
}


- (IBAction)oppStateSelect:(id)sender {
}

@end
