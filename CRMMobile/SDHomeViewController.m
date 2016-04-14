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

#define kHomeHeaderViewHeight 110

@interface SDHomeViewController () <SDHomeGridViewDeleate>
@property (nonatomic, weak)   UIView         *headerView;
@property (nonatomic, weak)   SDHomeGridView *mainView;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, strong) NSArray *destionClassArray;
@end

@implementation SDHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self  setupHeader];
    [self  setupMainView];
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.barTintColor = NAVBLUECOLOR;
    self.destionClassArray=@[[CustomerInformationTableViewController class],
                             [CustomercontactTableViewController class],
                             [CustomerCallPlanDetailViewController class],
                             [TaskRecordsTableViewController class],
                             [SubmitTableViewController class],
                             [trackingTableViewController class],
                             [SaleOppTableViewController class],
                             [MarketManagementViewController class],
                             [TaskReportTableViewController class]
                             ];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat headerY = 0;
    headerY = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) ? 64 : 0;
    _headerView.frame = CGRectMake(0, headerY, self.view.sd_width, kHomeHeaderViewHeight);
    _mainView.frame = CGRectMake(0, 150, self.view.sd_width, 360);
    UIView *navDividingLine = [[UIView alloc] initWithFrame:CGRectMake(0,_mainView.sd_height+150,self.view.sd_width,1.05)];
    navDividingLine.backgroundColor = [UIColor colorWithRed:(221 / 255.0) green:(221 / 255.0) blue:(221 / 255.0) alpha:1];
    [navDividingLine sizeToFit];
    [self.view addSubview:navDividingLine];
}

#pragma mark  -private actions
- (void)setupHeader
{
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

- (void)scanButtonClicked
{
    SDBasicViewContoller *desVc = [[SDScanViewController alloc] init];
    [self.navigationController pushViewController:desVc animated:YES];
}

- (void)setupMainView
{
    SDHomeGridView *mainView = [[SDHomeGridView alloc] init];
    mainView.gridViewDelegate = self;
    mainView.showsVerticalScrollIndicator = NO;
    [self setupDataArray];
    mainView.gridModelsArray = _dataArray;
    [self.view addSubview:mainView];
    _mainView = mainView;
}

- (void)setupDataArray
{
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

- (void)homeGrideView:(SDHomeGridView *)gridView selectItemAtIndex:(NSInteger)index
{
    
    SDHomeGridItemModel *model = _dataArray[index];
    [model setDestinationClass:[self.destionClassArray objectAtIndex:index]];
    UIViewController *vc = [[model.destinationClass alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeGrideViewmoreItemButtonClicked:(SDHomeGridView *)gridView
{
    SDAddItemViewController *addVc = [[SDAddItemViewController alloc] init];
    addVc.title = @"添加更多";
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)homeGrideViewDidChangeItems:(SDHomeGridView *)gridView
{
    [self setupDataArray];
}


@end
