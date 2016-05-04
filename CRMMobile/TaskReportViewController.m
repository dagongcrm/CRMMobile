//
//  TaskReportViewController.m
//  CRMMobile
//
//  Created by 刘国江 on 16/5/4.
//  Copyright © 2016年 dagong. All rights reserved.
//

#import "TaskReportViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "DailyTableViewController.h"
#import "WeekTableViewController.h"
#import "MonthTableViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

@interface TaskReportViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation TaskReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpSegView];
    [self setUpTableView];
}


- (void)setUpUI{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"工作日志";
    [self.navigationController.navigationBar setBarTintColor:NAVBLUECOLOR];
    self.view.backgroundColor   = [UIColor whiteColor];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
}

- (void) setUpTableView{
    DailyTableViewController  *todo = [[DailyTableViewController alloc] init];
    todo.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:todo];
    todo.view.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT);
    [self.scrollView addSubview:todo.view];
    
    WeekTableViewController  *sal = [[WeekTableViewController alloc] init];
    sal.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:sal];
    sal.view.frame = CGRectMake(SCREENWIDTH, 20, SCREENWIDTH, SCREENHEIGHT);
    [self.scrollView addSubview:sal.view];
    
    MonthTableViewController  *mon = [[MonthTableViewController alloc] init];
    mon.view.autoresizingMask = UIViewAutoresizingNone;
    [self addChildViewController:mon];
    mon.view.frame = CGRectMake(SCREENWIDTH*2, 20, SCREENWIDTH, SCREENHEIGHT);
    [self.scrollView addSubview:mon.view];
    
}


- (void)setUpSegView{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    self.segmentedControl.sectionTitles = @[@"工作日报", @"工作周报", @"工作月报"];
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
