//
//  config.h
//  Ratings
//  asdfasdf
//  Created by gwb on 15/10/14.
//  Copyright (c) 2015年 gwb. All rights reserved.
//

#import <Foundation/Foundation.h>
#define APPDELEGATE  ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define SERVER_URL   @"http://10.10.10.172:8080/dagongcrm/"
#define NAVCOLOR     [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
#define NAVBLUECOLOR [UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]
#define TOTAL_PAGES     3
@interface config : NSObject

@end
