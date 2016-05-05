#import "SDHomeViewController.h"
#import "UIView+SDExtension.h"
#import "SDHomeGridView.h"
#import "SDHomeGridItemModel.h"
#import "SDScanViewController.h"
#import "SDAddItemViewController.h"
#import "SDGridItemCacheTool.h"
#import "CRMTableViewController.h"
#import "CustomerInformationTableViewController.h"
#import "config.h"
#import "CustomercontactTableViewController.h"
#import "CustomerCallPlanDetailViewController.h"
#import "TaskRecordsTableViewController.h"
#import "SubmitTableViewController.h"
#import "trackingTableViewController.h"
#import "SaleOppTableViewController.h"
#import "MarketManagementViewController.h"
#import "TaskReportTableViewController.h"
#import "SDCycleScrollView.h"
#import "VisitPlanTableViewController.h"
#import "HomeSearchViewController.h"
#import "TaskReportViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define kHomeHeaderViewHeight 110

@interface SDHomeViewController () <SDHomeGridViewDeleate,SDCycleScrollViewDelegate,UISearchBarDelegate>
@property (nonatomic, weak)   UIView         *headerView;
@property (nonatomic, weak)   SDHomeGridView *mainView;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, strong) NSArray        *destionClassArray;
@property (nonatomic, strong) UISearchBar    *searchBar;
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;
@property (nonatomic, strong) UIButton       *searchButton;
@end

@implementation SDHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1.0];
    [self  setupMainView];
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.barTintColor = NAVBLUECOLOR;
    //去掉返回的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self  action:nil];
    self.destionClassArray=@[[CustomerInformationTableViewController class],
                             [CustomercontactTableViewController class],
                             [VisitPlanTableViewController class],
                             [TaskRecordsTableViewController class],
                             [SubmitTableViewController class],
                             [trackingTableViewController class],
                             [SaleOppTableViewController class],
                             [MarketManagementViewController class],
                             [TaskReportViewController class]];
    [self setUpScrollView];
}

-(void) setUpScrollView{
    SDCycleScrollView *cycleView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 110, self.view.sd_width, 90)];
    cycleView.autoScrollTimeInterval = 3.0;
    cycleView.dotColor=NAVBLUECOLOR;
    cycleView.imageURLStringsGroup=@[@"http://10.10.10.172:8888/cms/pic3.jpg",
                                     @"http://10.10.10.172:8888/cms/pic2.jpg",
                                     @"http://10.10.10.172:8888/cms/pic1.jpg"];
    UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(0,cycleView.sd_y-1.05,self.view.sd_width,1.05)];
    navDividingLine.backgroundColor = [UIColor colorWithRed:(221 / 255.0) green:(221 / 255.0) blue:(221 / 255.0) alpha:1];
    [navDividingLine sizeToFit];
    UIView *navDividingLine2 = [[UIView alloc] initWithFrame:CGRectMake(0,cycleView.sd_y+cycleView.sd_height,self.view.sd_width,1.05)];
    navDividingLine2.backgroundColor = [UIColor colorWithRed:(221 / 255.0) green:(221 / 255.0) blue:(221 / 255.0) alpha:1];
    [navDividingLine2 sizeToFit];
    [self.view addSubview:navDividingLine];
    [self.view addSubview:navDividingLine2];
    [self.view addSubview:cycleView];
    CGRect rectStatus =[[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGFloat seachBarHeight=rectStatus.size.height+rectNav.size.height;
    self.searchBar= [[UISearchBar alloc]initWithFrame:CGRectMake(0, seachBarHeight, SCREENWIDTH, 110-seachBarHeight)];
    [self.searchBar setTranslucent:YES];
    [self.searchBar setBackgroundColor:[UIColor whiteColor]];
    self.searchBar.searchBarStyle=UISearchBarStyleMinimal;
    [self.searchBar setPlaceholder:@"客户/活动/任务"];
    self.searchBar.delegate=self;
    [self.view addSubview:self.searchBar];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat headerY = 0;
    headerY = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) ? 64 : 0;
    _headerView.frame = CGRectMake(0, headerY, self.view.sd_width, kHomeHeaderViewHeight);
    if(SCREENWIDTH>375){
        _mainView.frame = CGRectMake(0, 170, self.view.sd_width, 380);
    }else{
        _mainView.frame = CGRectMake(0, 170, self.view.sd_width, 360);
    }
    
    UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(0,_mainView.sd_height+170,self.view.sd_width,1.05)];
    navDividingLine.backgroundColor = [UIColor colorWithRed:(221 / 255.0) green:(221 / 255.0) blue:(221 / 255.0) alpha:1];
    [navDividingLine sizeToFit];
    [self.view addSubview:navDividingLine];
}

#pragma mark  -private actions
- (void)setupHeader{
    UIView *header = [[UIView alloc] init];
    header.bounds = CGRectMake(0, 0, self.view.sd_width, kHomeHeaderViewHeight);
    header.backgroundColor = [UIColor colorWithRed:(38 / 255.0) green:(42 / 255.0) blue:(59 / 255.0) alpha:1];
    [self.view addSubview:header];
    _headerView = header;
    UIButton *scan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, header.sd_width * 0.5, header.sd_height)];
    [scan setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
    [scan addTarget:self action:@selector(scanButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:scan];
    UIButton *pay = [[UIButton alloc] initWithFrame:CGRectMake(scan.sd_width, 0, header.sd_width * 0.5, header.sd_height)];
    [pay setImage:[UIImage imageNamed:@"home_pay"] forState:UIControlStateNormal];
    [header addSubview:pay];
}

- (void)scanButtonClicked{
    SDBasicViewContoller *desVc = [[SDScanViewController alloc] init];
    [self.navigationController pushViewController:desVc animated:YES];
}

- (void)setupMainView{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [rightButton setImage:[UIImage imageNamed:@"daiban.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchprogram)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIButton *rightButton3 = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,5)];
    UIBarButtonItem *rightItem3 = [[UIBarButtonItem alloc]initWithCustomView:rightButton3];
    UIButton *rightButton2 = [[UIButton alloc]initWithFrame:CGRectMake(0,10,20,20)];
    [rightButton2 setImage:[UIImage imageNamed:@"xiaoxi.png"]forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(searchprogram)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:rightButton2];
    NSArray* array = @[rightItem,rightItem3,rightItem2];
    self.navigationItem.rightBarButtonItems= array;
    SDHomeGridView *mainView = [[SDHomeGridView alloc] init];
    mainView.gridViewDelegate = self;
    mainView.showsVerticalScrollIndicator = NO;
    [self setupDataArray];
    mainView.gridModelsArray = _dataArray;
    [self.view addSubview:mainView];
    _mainView = mainView;
}

- (void)setupDataArray{
    NSArray *itemsArray = [SDGridItemCacheTool itemsArray];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *itemDict in itemsArray) {
        SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
        model.destinationClass = [SDBasicViewContoller class];
        model.imageResString =[itemDict.allValues firstObject];
        model.title = [itemDict.allKeys firstObject];
        [temp addObject:model];
    }
    _dataArray = [temp copy];
}

#pragma mark -SDHomeGridViewDeleate
- (void)homeGrideView:(SDHomeGridView *)gridView selectItemAtIndex:(NSInteger)index{
    SDHomeGridItemModel *model = _dataArray[index];
    [model setDestinationClass:[self.destionClassArray objectAtIndex:index]];
    UIViewController *vc = [[model.destinationClass alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeGrideViewmoreItemButtonClicked:(SDHomeGridView *)gridView{
    SDAddItemViewController *addVc = [[SDAddItemViewController alloc] init];
    addVc.title = @"添加更多";
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)homeGrideViewDidChangeItems:(SDHomeGridView *)gridView{
    [self setupDataArray];
}

#pragma mark - UISearchBarDelegate 协议

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    CGRect rectStatus =[[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGFloat seachBarHeight=rectStatus.size.height+rectNav.size.height;
    [self.searchBar resignFirstResponder];
    self.searchBar.text=@"";
    self.searchBar.showsCancelButton=NO;
    self.searchBar.frame=CGRectMake(0, seachBarHeight, SCREENWIDTH, 110-seachBarHeight);
    self.searchButton.frame=CGRectMake(0, 0, 0, 0);
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",@"3");
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
{
    CGRect rectStatus =[[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGFloat seachBarHeight=rectStatus.size.height+rectNav.size.height;
    self.searchBar.frame=CGRectMake(0, seachBarHeight, SCREENWIDTH-50, 110-seachBarHeight);
    self.searchButton =[[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-50, seachBarHeight, 50, 110-seachBarHeight)];
    [self.searchButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.searchButton setBackgroundColor:[UIColor whiteColor]];
    [self.searchButton setTitleColor:NAVBLUECOLOR forState:UIControlStateNormal];
    SEL selector = NSSelectorFromString(@"search");
    [self.searchButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.searchButton.titleLabel.font=[UIFont systemFontOfSize:18];
    [self.view addSubview:self.searchButton];
    self.searchBar.showsCancelButton=YES;

    UIView *subView0 = self.searchBar.subviews[0]; // IOS7.0中searchBar组成复杂点
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        for (UIView *subView in subView0.subviews)
        {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *cannelButton = (UIButton*)subView;
                [cannelButton setTitle:@"取消"forState:UIControlStateNormal];
                [cannelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                break;
            }  
        }
    }
}

-(void) search{
    NSLog(@"%@",@"123");
}

- (void)controlAccessoryView:(float)alphaValue{
    [UIView animateWithDuration:0.2 animations:^{
        [self.inputAccessoryView setAlpha:alphaValue];
    }completion:^(BOOL finished){
        if (alphaValue<=0) {
            [self.searchBar resignFirstResponder];
            [self.searchBar setShowsCancelButton:NO animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        
    }];
}
@end
