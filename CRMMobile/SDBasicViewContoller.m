#import "SDBasicViewContoller.h"

@implementation SDBasicViewContoller

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:(247 / 255.0) green:(249 / 255.0) blue:(248 / 255.0) alpha:1];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:5]} forState:UIControlStateNormal];
}

@end
