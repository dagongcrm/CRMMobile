
//
//  AppDelegate.h
//  CRMMobile
//
//  Created by gwb on 15/10/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "options.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSDictionary  *sessionInfo;
}
@property  (strong ,nonatomic) NSString  *controllerJudge;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSDictionary *sessionInfo;
@property  NSInteger  index;
@property  (strong ,nonatomic) options    *options;
@property  NSInteger    *judge;
@property  NSString    *judgeSubmitID;

@property  NSString    *submitName;
@property  NSString    *yeWuZL;
@property  NSString    *yeWuZLBH;
@property  NSString    *hangYeFLBH;
@property  NSString    *hangYeFLMC;
@property  NSString    *heTongJE;
@property  NSString    *gezongSF;
@property  NSString    *genZongSFJE;
@property  NSString    *lianxiFS;
@end

