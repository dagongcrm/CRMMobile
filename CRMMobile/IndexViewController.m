//
//  ViewController.m
//  Reuse
//
//  Created by Allen Hsu on 12/14/14.
//  Copyright (c) 2014 Glow, Inc. All rights reserved.
//

#import "IndexViewController.h"
#import "GLReusableViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import "PureLayout.h"

@interface IndexViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *entities;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *navScrollView;
@property (weak, nonatomic) IBOutlet UIView *navContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navContentWidthConstraint;

@property (strong, nonatomic) NSNumber *currentPage;
@property (strong, nonatomic) NSMutableArray *reusableViewControllers;
@property (strong, nonatomic) NSMutableArray *visibleViewControllers;
@end



@implementation IndexViewController

- (NSMutableArray *)reusableViewControllers
{
    if (!_reusableViewControllers) {
        _reusableViewControllers = [NSMutableArray array];
    }
    return _reusableViewControllers;
}

- (NSMutableArray *)visibleViewControllers
{
    if (!_visibleViewControllers) {
        _visibleViewControllers = [NSMutableArray array];
    }
    return _visibleViewControllers;
}


-(void)viewWillAppear:(BOOL)animated{
    [self setupPages];
    [self loadPage:0];
    
}


- (void)viewDidLoad {
    self.entities = [[NSMutableArray alloc]init];
    NAVCOLOR;
    [super viewDidLoad];
    [self appUpdate:@"1"];
    [self setupPages];
    [self loadPage:0];
    
}
-(NSMutableArray *) appUpdate:(NSString *)page{
    NSError *error;
    NSString *sid = [[APPDELEGATE.sessionInfo objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"muserAction!findCodeIOS.action?"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    //    NSString *order = @"desc";
    //    NSString *sort = @"time";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@&page=%@",sid,page];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *list = [json objectForKey:@"obj"];
    NSLog(@"%@",list);
    NSString *userName = @"";
    for (int i = 0;i<[list count];i++) {
        NSDictionary *listDic =[list objectAtIndex:i];
        userName = [listDic objectForKeyedSubscript:@"userName"];
    }
    NSLog(@"%@",userName);
    
    NSString *str1 =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"%@",str1);
    if (![str1 isEqualToString:userName]&&![str1 isEqualToString:@"1.0"]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"提示信息" message:@"有最新的软件包哦，亲快下载吧~" delegate:self cancelButtonTitle:@"狠心拒绝" otherButtonTitles:@"立即更新", nil];
        [alertView show];
    }
    return self.entities;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *str1 =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        APPDELEGATE.appUpdate = str1;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    }
}

- (void)setupPages
{
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView withMultiplier:TOTAL_PAGES];
    
    [self.navContentWidthConstraint autoRemove];
    self.navContentWidthConstraint = [self.navContentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.navScrollView withMultiplier:TOTAL_PAGES];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.titleView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(0.0f, 0.5f);
    l.endPoint   = CGPointMake(1.0f, 0.5f);
    self.titleView.layer.mask = l;
    
    CGFloat x = 0;
    for (int i = 0; i < TOTAL_PAGES; ++i) {
        CGRect frame  = CGRectMake(x, 0.0, self.navScrollView.frame.size.width, self.navScrollView.frame.size.height - 10.0);
        UILabel *title = [[UILabel alloc] initWithFrame:frame];
        if (i==0) {
            title.text =@"今天";
        }
        if (i==1) {
            title.text =@"拜访计划";
        }
        if (i==2) {
            title.text =@"拜访记录";
        }
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor     = [UIColor whiteColor];
        title.font          = [UIFont boldSystemFontOfSize:14.0];
        [self.navContentView addSubview:title];
        x += self.navScrollView.frame.size.width;
    }
    self.pageControl.numberOfPages = TOTAL_PAGES;
    [self.scrollView bringSubviewToFront:self.contentView];
}

- (void)loadPage:(NSInteger)page
{
     self.pageControl.currentPage=page;
    if (self.currentPage && page == [self.currentPage integerValue]) {
        return;
    }
    // NSMutableArray *pagesToLoad = [@[@(page), @(page - 1), @(page + 1)]  mutableCopy];
    NSMutableArray *pagesToLoad = [@[@0, @1, @2]  mutableCopy];
    NSMutableArray *vcsToEnqueue = [NSMutableArray array];
    for (GLReusableViewController *vc in self.visibleViewControllers) {
        if (!vc.page || ![pagesToLoad containsObject:vc.page]) {
            [vcsToEnqueue addObject:vc];
        } else if (vc.page) {
            [pagesToLoad removeObject:vc.page];
        }
    }
    for (GLReusableViewController *vc in vcsToEnqueue) {
        [vc.view removeFromSuperview];
        [self.visibleViewControllers removeObject:vc];
        [self enqueueReusableViewController:vc];
    }
    for (NSNumber *page in pagesToLoad) {
        [self addViewControllerForPage:[page integerValue]];
    }
}

- (void)enqueueReusableViewController:(GLReusableViewController *)viewController
{
    [self.reusableViewControllers addObject:viewController];
}

- (GLReusableViewController *)dequeueReusableViewController
{
    static int numberOfInstance = 0;
    GLReusableViewController *vc = [self.reusableViewControllers firstObject];
    if (vc) {
        [self.reusableViewControllers removeObject:vc];
    } else {
        vc = [GLReusableViewController viewControllerFromStoryboard];
        vc.numberOfInstance = numberOfInstance;
        numberOfInstance++;
        [vc willMoveToParentViewController:self];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
    }
    return vc;
}

- (void)addViewControllerForPage:(NSInteger)page
{
    if (page < 0 || page >= TOTAL_PAGES) {
        return;
    }
    GLReusableViewController *vc = [self dequeueReusableViewController];
    vc.page = @(page);
    vc.view.frame = CGRectMake(self.scrollView.frame.size.width * page, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.contentView addSubview:vc.view];
    [self.visibleViewControllers addObject:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX=scrollView.contentOffset.x;
    offsetX=offsetX+(scrollView.frame.size.width);
    int page=offsetX/scrollView.frame.size.width;
    page = MAX(page, 0);
    page = MIN(page, TOTAL_PAGES-1);
    [self loadPage:page];
    if (scrollView == self.scrollView) {
        CGFloat navX = scrollView.contentOffset.x / scrollView.frame.size.width * self.navScrollView.frame.size.width;
        self.navScrollView.contentOffset = CGPointMake(navX, 0.0);
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX=scrollView.contentOffset.x;
    offsetX=offsetX+(scrollView.frame.size.width);
    int page=offsetX/scrollView.frame.size.width;
    self.pageControl.currentPage=page-1;
    [self.scrollView bringSubviewToFront:self.pageControl];
}

@end
