//
//  ViewController.m
//  EAIntroView
//
//  Created by Evgeny Aleksandrov on 14.09.13.
//
#import "IntroViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [self showBasicIntroWithBg];
   
}

- (void)showBasicIntroWithBg {
    if(SCREENWIDTH>375){
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage=[UIImage imageNamed:@"guide3.png"];
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage=[UIImage imageNamed:@"guide4.png"];
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2]];
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
    }else{
        EAIntroPage *page1 = [EAIntroPage page];
        page1.bgImage=[UIImage imageNamed:@"guide1.png"];
        
        EAIntroPage *page2 = [EAIntroPage page];
        page2.bgImage=[UIImage imageNamed:@"guide2.png"];
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2]];
        [intro setDelegate:self];
        [intro showInView:self.view animateDuration:0.0];
    }
}


- (void)introDidFinish {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    myDelegate.window.rootViewController = loginViewController;
    myDelegate.window.backgroundColor = [UIColor whiteColor];
    [myDelegate.window makeKeyAndVisible];
}

@end
