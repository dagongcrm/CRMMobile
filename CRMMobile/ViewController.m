//
//  ViewController.m
//  demo
//
//  Created by 伍德友 on 16/4/18.
//  Copyright (c) 2016年 伍德友. All rights reserved.
//

#import "ViewController.h"
#import "ContactModel.h"
#import "ContactTableViewCell.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "AppDelegate.h"
#import "config.h"
@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *serverDataArr;//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UISearchBar *searchBar;//搜索框
//@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;//搜索VC

@property (nonatomic, strong) NSMutableArray *fakeData;//
@property (nonatomic, strong) NSMutableArray *contactData;//联系方式2
@property (nonatomic, strong) NSMutableArray *customerNameStrData;//联系人1
@property (nonatomic, strong) NSMutableArray *phoneData;//电话数据
@property (nonatomic, strong) NSMutableArray *userName;
@property (nonatomic, strong) NSMutableArray *orgName;
@property (nonatomic, strong) NSMutableArray *contactIDData;//3
@property (nonatomic, strong) NSMutableArray *customerIDData;//4
@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation ViewController{
    NSMutableArray *_searchResultArr;//搜索结果Arr
}

#pragma mark - dataArr(模拟从服务器获取到的数据)
//- (NSArray *)serverDataArr{
//    if (!_serverDataArr) {
//        _serverDataArr=@[@{@"portrait":@"1",@"name":@"1"},@{@"portrait":@"2",@"name":@"花无缺"},@{@"portrait":@"3",@"name":@"东方不败"},@{@"portrait":@"4",@"name":@"任我行"},@{@"portrait":@"5",@"name":@"逍遥王"},@{@"portrait":@"6",@"name":@"阿离"},@{@"portrait":@"13",@"name":@"百草堂"},@{@"portrait":@"8",@"name":@"三味书屋"},@{@"portrait":@"9",@"name":@"彩彩"},@{@"portrait":@"10",@"name":@"陈晨"},@{@"portrait":@"11",@"name":@"多多"},@{@"portrait":@"12",@"name":@"峨嵋山"},@{@"portrait":@"7",@"name":@"哥哥"},@{@"portrait":@"14",@"name":@"林俊杰"},@{@"portrait":@"15",@"name":@"足球"},@{@"portrait":@"16",@"name":@"58赶集"},@{@"portrait":@"17",@"name":@"搜房网"},@{@"portrait":@"18",@"name":@"欧弟"}];
////        self.fakeData = [[NSMutableArray alloc]init];
////        self.contactData = [[NSMutableArray alloc]init];
////        self.customerNameStrData = [[NSMutableArray alloc]init];
////        self.phoneData = [[NSMutableArray alloc]init];
////        self.contactIDData = [[NSMutableArray alloc]init];
////        self.customerIDData = [[NSMutableArray alloc]init];
////        [self faker:@"1"];
//
//    }
//    return _serverDataArr;
//}

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"通讯录";
//    for (int i=0;i<11;i++) {
//        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
//         [self faker:stringInt];
//    }
    [self faker:@"1"];
    
//    self.dataArr=[NSMutableArray array];
//    for (NSDictionary *subDic in self.serverDataArr) {
//        ContactModel *model=[[ContactModel alloc]initWithDic:subDic];
//        [self.dataArr addObject:model];//放的是数据源的对象
//    }
//    
    _rowArr=[ContactDataHelper getFriendListDataBy:self.dataArr];
    _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
    [self setUpView];
    }


#pragma mark - setUpView
- (void)setUpView{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, kScreenHeight-49.0, kScreenWidth, 49.0)];
        [self.view insertSubview:self.tableView belowSubview:imageView];
}
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [_searchBar setBackgroundImage:[UIImage imageNamed:@"ic_searchBar_bgImage"]];
        [_searchBar sizeToFit];
        [_searchBar setPlaceholder:@"搜索"];
        [_searchBar.layer setBorderWidth:0.5];
        [_searchBar.layer setBorderColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1].CGColor];
        [_searchBar setDelegate:self];
        [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    }
    return _searchBar;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight-49.0) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        [_tableView setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
        _tableView.tableHeaderView=self.searchBar;
        //cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setTableFooterView:v];
    }
    return _tableView;
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
       return _rowArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_rowArr[section] count];
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14.5f]];
        [label setTextColor:[UIColor grayColor]];
        [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    }
    [label setText:[NSString stringWithFormat:@"  %@",_sectionArr[section+1]]];
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 22.0;
  
}
//
#pragma mark - UITableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    ContactTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
   
    ContactModel *model=_rowArr[indexPath.section][indexPath.row];
    
    [cell.headImageView setImage:[UIImage imageNamed:model.portrait]];
    [cell.nameLabel setText:model.name];
   
    
    return cell;
}

#pragma mark searchBar delegate
//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSArray *subViews;
    subViews = [(searchBar.subviews[0]) subviews];
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    searchBar.showsCancelButton = YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //取消
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

#pragma mark searchDisplayController delegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    //cell无数据时，不显示间隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView setTableFooterView:v];
    
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString
                               scope:[self.searchBar scopeButtonTitles][self.searchBar.selectedScopeButtonIndex]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:self.searchBar.text
                               scope:self.searchBar.scopeButtonTitles[searchOption]];
    return YES;
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < self.dataArr.count; i++) {
        NSString *storeString = [(ContactModel *)self.dataArr[i] name];
        NSString *storeImageString=[(ContactModel *)self.dataArr[i] portrait]?[(ContactModel *)self.dataArr[i] portrait]:@"";
        
        NSRange storeRange = NSMakeRange(0, storeString.length);
        
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            NSDictionary *dic=@{@"name":storeString,@"portrait":storeImageString};
            
            [tempResults addObject:dic];
        }
        
    }
    [_searchResultArr removeAllObjects];
    [_searchResultArr addObjectsFromArray:tempResults];
}
//获取数据
-(NSMutableArray *)faker:(NSString *)page{
    NSLog(@"page==>%@",page);
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"]objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"mcustomerContactAction!datagrid.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@",sid,page];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
        NSDictionary *contactDic  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSArray *list = [contactDic objectForKey:@"obj"];
        NSLog(@"pagecountpagecountpagecountpagecount==>>%lu",(unsigned long)[list count]);
         self.dataArr=[NSMutableArray array];
        for (int i = 0;i<[list count];i++) {
            NSDictionary *listDic =[list objectAtIndex:i];
            NSString *contactState = (NSString *)[listDic objectForKey:@"contactState"];
            if ([contactState isEqualToString:@"huoYue"]) {
                
               
//                for (NSDictionary *subDic in self.serverDataArr) {
                NSString *teamname = (NSString *)[listDic objectForKey:@"contactName"];//1
                NSString *telePhone = (NSString *)[listDic objectForKey:@"telePhone"];//2
                NSString *callphone = (NSString *)[listDic objectForKey:@"cellPhone"];//2-
                NSString *contactID = (NSString *)[listDic objectForKey:@"contactID"];//3
                NSString *customerID = (NSString *)[listDic objectForKey:@"customerID"];//4
                NSString *customerNameStr = (NSString *)[listDic objectForKey:@"customerNameStr"];
                NSString *phoneTime = (NSString *)[listDic objectForKey:@"phoneTime"];
                    ContactModel *model=[[ContactModel alloc] init];
                model.portrait = @"txl-1";
                model.name = teamname;
                model.customerName = customerNameStr;
                model.contactID = contactID;
                model.phone = callphone;
                [self.dataArr addObject:model];//放的是数据源的对象
//                }
                
                
                
//                [self.userName addObject:listDic];
//                NSString *teamname = (NSString *)[listDic objectForKey:@"contactName"];//1
//                NSString *telePhone = (NSString *)[listDic objectForKey:@"telePhone"];//2
//                NSString *callphone = (NSString *)[listDic objectForKey:@"cellPhone"];//2-
//                NSString *contactID = (NSString *)[listDic objectForKey:@"contactID"];//3
//                NSString *customerID = (NSString *)[listDic objectForKey:@"customerID"];//4
//                NSString *customerNameStr = (NSString *)[listDic objectForKey:@"customerNameStr"];
//                NSString *phoneTime = (NSString *)[listDic objectForKey:@"phoneTime"];
//                if (phoneTime  == nil || phoneTime == NULL) {
//                    [self.phoneData addObject:@"暂无通话记录"];
//                }else{
//                    [self.phoneData addObject:phoneTime];
//                }
//                if (teamname==nil||teamname==NULL) {
//                    teamname=@"暂无该联系人姓名";
//                }
//                if (telePhone==nil||telePhone==NULL) {
//                    telePhone=@"暂无该联系人电话";
//                }
//                if (customerNameStr==nil||customerNameStr==NULL) {
//                    customerNameStr=@"暂无企业信息";
//                }
//                if (contactID==nil||contactID==NULL) {
//                    contactID=@"null";
//                }
//                [self.fakeData addObject:teamname];//1
//                [self.contactData addObject:telePhone];//2
//                [self.contactIDData addObject:contactID];//3
//                [self.customerIDData addObject:customerID];//4
//                [self.customerNameStrData addObject:customerNameStr];
//                [self.fakeData set]
                
            }
        }
    }
//    _rowArr=[ContactDataHelper getFriendListDataBy:self.dataArr];
//    _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
    return self.dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
