//
//  MarketViewController.m
//  CRMMobile
//
//  Created by gwb on 16/4/15.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "MarketViewController.h"
#import "config.h"
#import "HMSegmentedControl.h"
#import "saleLeadsTableViewController.h"
#import "SaleOppTableViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "saleLeadsTableViewController.h"
#import "MarketManagementViewController.h"
#import "AddSaleOppViewController.h"
#import "addSaleLeadsViewController.h"
#import "saleLeads.h"
#import "AddSaleOppViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

@interface MarketViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property saleLeads *saleLeads;
@end

@implementation MarketViewController

- (void)viewDidLoad {
    [self setUpUI];
    [self setUpSegView];
    [self setUpTableView];
}

- (void)setUpUI{
    [super viewDidLoad];
    self.title = @"市场";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self  action:nil];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:NAVBLUECOLOR];
    self.view.backgroundColor   = [UIColor whiteColor];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [rightButton setImage:[UIImage imageNamed:@"app_add.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchControllerForAdd)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void) setUpTableView{
    SaleOppTableViewController  *todo = [[SaleOppTableViewController alloc] init];
    todo.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:todo];
    todo.view.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT);
    [self.scrollView addSubview:todo.view];
    
    saleLeadsTableViewController  *sal = [[saleLeadsTableViewController alloc] init];
    sal.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:sal];
    sal.view.frame = CGRectMake(SCREENWIDTH, 20, SCREENWIDTH, SCREENHEIGHT);
    [self.scrollView addSubview:sal.view];
    
    MarketManagementViewController  *mal = [[MarketManagementViewController alloc] init];
    mal.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:mal];
    mal.view.frame = CGRectMake(SCREENWIDTH*2, -25, SCREENWIDTH, SCREENHEIGHT);
    [self.scrollView addSubview:mal.view];
}

-(void)searchControllerForAdd{
    if(self.segmentedControl.selectedSegmentIndex==0){
//           [self.navigationController pushViewController:[[TestARViewController alloc] init] animated:YES];
        [self.navigationController pushViewController:[[AddSaleOppViewController alloc] init] animated:YES];
    }
    if(self.segmentedControl.selectedSegmentIndex==1){
        self.saleLeads = [[saleLeads alloc] init];
        [self.saleLeads setIndex:@"addSaleLeads"];
        addSaleLeadsViewController *AddSaleLeads = [[addSaleLeadsViewController alloc]init];
        [AddSaleLeads setSaleLeads:self.saleLeads];
        [self.navigationController pushViewController:AddSaleLeads animated:YES];
//        [self.navigationController pushViewController:[[addSaleLeadsViewController alloc] init] animated:YES];
    }
}

- (void)setUpSegView{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    self.segmentedControl.sectionTitles = @[@"销售机会", @"销售线索", @"活动统计"];
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]};
    self.segmentedControl.selectionIndicatorColor = NAVBLUECOLOR;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
    [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];}];
    [self.view addSubview:self.segmentedControl];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, self.view.frame.size.height-50)];
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 3, 200);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, 200) animated:NO];
    [self.view addSubview:self.scrollView];
}

- (void)setApperanceForLabel:(UILabel *)label {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    label.backgroundColor = color;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:21.0f];
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}
@end
